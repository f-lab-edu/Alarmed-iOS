//
//  AppView.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import AlarmFeature

import SwiftUI

import ComposableArchitecture

public struct AppView: View {
  public init() { }

  public var body: some View {
    AlarmEditView(
      store: Store(
        initialState: AlarmEditReducer.State(alarmTime: Date(), selectedWeekdays: [.monday]))
      {
        AlarmEditReducer()
      })
  }
}
