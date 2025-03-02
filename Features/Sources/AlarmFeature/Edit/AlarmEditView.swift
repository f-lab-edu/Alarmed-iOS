//
//  AlarmEditView.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import SwiftUI

import ComposableArchitecture

public struct AlarmEditView: View {

  // MARK: Lifecycle

  public init(store: StoreOf<AlarmEditReducer>) {
    self.store = store
  }

  // MARK: Public

  public var body: some View {
    Form {
      Section {
        DatePicker(
          "Alarm Time Picker",
          selection: $store.alarmTime,
          displayedComponents: .hourAndMinute)
          .datePickerStyle(.wheel)
          .labelsHidden()
      }

      Section {
        HStack(spacing: Metrics.labelSpacingHorizontal) {
          ForEach(store.weekdays, id: \.self) { weekday in
            Button {
              store.send(.weekdaySelected(weekday))
            } label: {
              Text(weekday.shortDescription)
                .foregroundStyle(
                  store.selectedWeekdays.contains(weekday) ? Color.blue : Color.gray)
            }
            .buttonStyle(.borderless)
          }
        }

        HStack(spacing: Metrics.labelSpacingHorizontal) {
          Text("Memo")
          TextField("Describe your alarm", text: $store.memo)
        }
      }

      Button {
        store.send(.saveButtonTapped)
      } label: {
        Text("Save")
      }
    }
  }

  // MARK: Private

  private enum Metrics {
    static let labelSpacingHorizontal: CGFloat = 8
  }

  @Bindable private var store: StoreOf<AlarmEditReducer>

}

#Preview {
  AlarmEditView(
    store: Store(
      initialState: AlarmEditReducer.State(
        alarmTime: Date(),
        selectedWeekdays: [.monday]))
    {
      AlarmEditReducer()
    })
}
