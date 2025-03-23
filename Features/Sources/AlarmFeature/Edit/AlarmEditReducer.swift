//
//  AlarmEditReducer.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import SharedModels

import Foundation

import ComposableArchitecture

// MARK: - AlarmEditReducer

@Reducer
public struct AlarmEditReducer: Sendable {

  // MARK: Lifecycle

  public init() { }

  // MARK: Public

  @Reducer(state: .equatable, .sendable)
  public enum Destination {
    case alert(AlertState<Alert>)

    public enum Alert: Equatable {
      case confirmDismissalButtonTapped
    }
  }

  @ObservableState
  public struct State: Equatable {
    public var alarm: Alarm
    @Presents public var destination: Destination.State?

    public var timeRemainingDescription: String {
      alarm.time.timeRemainingDescription
    }

    public init(
      alarm: Alarm)
    {
      self.alarm = alarm
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case changeSoundButtonTapped
    case destination(PresentationAction<Destination.Action>)
    case saveButtonTapped
    case scheduleAlarmFailed(Swift.Error)
    case weekdaySelected(Weekday)
  }

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .changeSoundButtonTapped:
        return .none

      case .destination(.presented(.alert(.confirmDismissalButtonTapped))):
        state.destination = nil
        return .none

      case .destination:
        return .none

      case .saveButtonTapped:
        return .run { [alarm = state.alarm] _ in
          let content = AlarmNotificationClient.NotificationContent(
            id: uuid(),
            title: "Alarm",
            body: alarm.memo.isEmpty ? "It's time for your alarm!" : alarm.memo)
          try await alarmNotificationClient.scheduleAlarm(alarm, content: content)
        } catch: { error, send in
          await send(.scheduleAlarmFailed(error))
        }

      case .scheduleAlarmFailed(let error):
        state.destination = .alert(.scheduleAlarmFailed(error))
        return .none

      case .weekdaySelected(let weekday):
        if state.alarm.repetition.selectedWeekdays.contains(weekday) {
          state.alarm.repetition.selectedWeekdays.remove(weekday)
        } else {
          state.alarm.repetition.selectedWeekdays.insert(weekday)
        }
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }

  // MARK: Internal

  @Dependency(\.alarmNotificationClient) var alarmNotificationClient
  @Dependency(\.uuid) var uuid

}

extension AlertState<AlarmEditReducer.Destination.Alert> {
  fileprivate static func scheduleAlarmFailed(_ error: Swift.Error) -> Self {
    Self(
      title: { TextState("Failed to schedule alarm") },
      actions: {
        ButtonState(action: .confirmDismissalButtonTapped) {
          TextState("OK")
        }
      },
      message: {
        TextState(error.localizedDescription)
      })
  }
}
