//
//  AlarmEditView.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import SharedModels

import SwiftUI

import ComposableArchitecture

// MARK: - AlarmEditView

public struct AlarmEditView: View {

  // MARK: Lifecycle

  public init(store: StoreOf<AlarmEditReducer>) {
    self.store = store
  }

  // MARK: Public

  public var body: some View {
    ScrollView {
      VStack(spacing: Metrics.settingsComponentSpacingVertical) {
        TimeWheelSection(
          hour: $store.alarm.time.hour,
          minute: $store.alarm.time.minute)

        Toggle("Every Day", isOn: $store.alarm.repetition.isDaily)
          .toggleStyle(SwitchToggleStyle(tint: .blue))

        WeekdaySelectionSection(
          weekdays: store.alarm.repetition.weekdays,
          selectedWeekdays: store.alarm.repetition.selectedWeekdays,
          onTapWeekday: { store.send(.weekdaySelected($0)) })

        VStack(alignment: .leading, spacing: Metrics.soundCotentSpacingHorizontal) {
          HStack {
            Text("Sound")
            Spacer()
            Text(store.alarm.sound.name)
            Button("Change") {
              store.send(.changeSoundButtonTapped)
            }
          }
          Slider(value: $store.alarm.sound.volume, in: 0...1)
        }

        HStack {
          Text("Snooze")
          Spacer()
          Text("\(store.alarm.snooze.minutes) min, \(store.alarm.snooze.repeatCount) times")
            .foregroundColor(.gray)
        }

        HStack {
          Text("Memo")
          Spacer()
          TextField("No memo", text: $store.alarm.memo)
            .multilineTextAlignment(.trailing)
        }
      }
      .padding()
    }
    .safeAreaInset(edge: .bottom) {
      HStack {
        Spacer()
        Button {
          store.send(.saveButtonTapped)
        } label: {
          Image(systemName: "checkmark")
            .padding()
            .background(Circle().fill(Color.blue))
            .foregroundColor(.white)
            .shadow(radius: Metrics.saveButtonShadowRadius)
        }
        .padding([.bottom, .trailing])
      }
    }
    .navigationTitle(store.timeRemainingDescription)
    .navigationBarTitleDisplayMode(.inline)
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
  }

  // MARK: Private

  private enum Metrics {
    static let saveButtonShadowRadius: CGFloat = 2
    static let settingsComponentSpacingVertical: CGFloat = 20
    static let soundCotentSpacingHorizontal: CGFloat = 8
  }

  @Bindable private var store: StoreOf<AlarmEditReducer>

}

// MARK: - TimeWheelSection

private struct TimeWheelSection: View {

  // MARK: Internal

  @Binding var hour: Int
  @Binding var minute: Int

  var body: some View {
    HStack(spacing: Metrics.spacingHorizontal) {
      Picker("Hour", selection: $hour) {
        ForEach(0..<24, id: \.self) { h in
          Text("\(h)").tag(h)
        }
      }
      #if os(iOS)
      .pickerStyle(.wheel)
      #endif
      .frame(width: Metrics.pickerWidth)
      .clipped()

      Text(":")
        .font(.title3)
        .bold()

      Picker("Minute", selection: $minute) {
        ForEach(0..<60, id: \.self) { m in
          Text(String(format: "%02d", m)).tag(m)
        }
      }
      #if os(iOS)
      .pickerStyle(.wheel)
      #endif
      .frame(width: Metrics.pickerWidth)
      .clipped()
    }
  }

  // MARK: Private

  private enum Metrics {
    static let spacingHorizontal: CGFloat = 8
    static let pickerWidth: CGFloat = 70
  }
}

// MARK: - WeekdaySelectionSection

private struct WeekdaySelectionSection: View {

  // MARK: Internal

  let weekdays: [Weekday]
  let selectedWeekdays: Set<Weekday>
  let onTapWeekday: (Weekday) -> Void

  var body: some View {
    HStack(spacing: Metrics.spacingHorizontal) {
      ForEach(weekdays, id: \.self) { day in
        Button {
          onTapWeekday(day)
        } label: {
          Text(day.shortDescription)
            .foregroundColor(selectedWeekdays.contains(day) ? .blue : .gray)
            .padding(.horizontal, Metrics.horizontalPadding)
            .padding(.vertical, Metrics.verticalPadding)
            .overlay(
              RoundedRectangle(cornerRadius: Metrics.cornerRadius)
                .stroke(
                  selectedWeekdays.contains(day) ? Color.blue : Color.gray,
                  lineWidth: Metrics.strokeWidth))
        }
      }
    }
  }

  // MARK: Private

  private enum Metrics {
    static let spacingHorizontal: CGFloat = 8
    static let horizontalPadding: CGFloat = 8
    static let verticalPadding: CGFloat = 4
    static let cornerRadius: CGFloat = 8
    static let strokeWidth: CGFloat = 1
  }
}

#Preview {
  AlarmEditView(
    store: Store(initialState: AlarmEditReducer.State(alarm: .default())) {
      AlarmEditReducer()
    })
}
