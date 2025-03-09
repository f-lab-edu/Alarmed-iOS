//
//  AlarmEditView.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import SwiftUI

public struct AlarmEditView: View {
  public init() { }

  public var body: some View {
    VStack(spacing: 8) {
      Image(systemName: "alarm")
        .imageScale(.large)
        .foregroundStyle(.tint)

      Text("Alarm Edit View")
    }
    .padding()
  }
}

#Preview {
  AlarmEditView()
}
