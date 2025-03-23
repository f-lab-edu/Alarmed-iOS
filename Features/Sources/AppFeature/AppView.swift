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
    NavigationStack {
      AlarmEditView(
        store: Store(initialState: AlarmEditReducer.State(alarm: .default())) {
          AlarmEditReducer()
        })
    }
  }
}
