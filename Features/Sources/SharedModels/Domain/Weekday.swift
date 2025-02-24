//
//  Weekday.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import Foundation

// MARK: - Weekday

public enum Weekday: Int, CaseIterable {
  case sunday = 1
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
}

// MARK: CustomStringConvertible

extension Weekday: CustomStringConvertible {
  public var description: String {
    switch self {
    case .sunday: "Sunday"
    case .monday: "Monday"
    case .tuesday: "Tuesday"
    case .wednesday: "Wednesday"
    case .thursday: "Thursday"
    case .friday: "Friday"
    case .saturday: "Saturday"
    }
  }

  public var shortDescription: String {
    switch self {
    case .sunday: "Sun"
    case .monday: "Mon"
    case .tuesday: "Tue"
    case .wednesday: "Wed"
    case .thursday: "Thu"
    case .friday: "Fri"
    case .saturday: "Sat"
    }
  }
}
