//
//  AlarmEditReducer.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import SharedModels

import Foundation

import ComposableArchitecture

@Reducer
public struct AlarmEditReducer {
  @ObservableState
  public struct State: Equatable {
    public var alarmTime: Date
    public var memo: String
    public var selectedWeekdays: Set<Weekday>
    public var weekdays: [Weekday]

    public init(
      alarmTime: Date,
      memo: String = "",
      selectedWeekdays: Set<Weekday>,
      weekdays: [Weekday] = Weekday.allCases
    ) {
      self.alarmTime = alarmTime
      self.memo = memo
      self.selectedWeekdays = selectedWeekdays
      self.weekdays = weekdays
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case saveButtonTapped
    case weekdaySelected(Weekday)
  }

  public init() { }

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .saveButtonTapped:
        return .none

      case .weekdaySelected(let weekday):
        if state.selectedWeekdays.contains(weekday) {
          state.selectedWeekdays.remove(weekday)
        } else {
          state.selectedWeekdays.insert(weekday)
        }
        return .none
      }
    }
  }
}
