//
//  Weekday.swift
//  Features
//
//  Created by Geonhee on 2/23/25.
//

import Foundation

public enum Weekday: Int, CaseIterable {
  case sunday = 1
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
}

extension Weekday: CustomStringConvertible {
  public var description: String {
    switch self {
    case .sunday:     return "Sunday"
    case .monday:     return "Monday"
    case .tuesday:    return "Tuesday"
    case .wednesday:  return "Wednesday"
    case .thursday:   return "Thursday"
    case .friday:     return "Friday"
    case .saturday:   return "Saturday"
    }
  }

  public var shortDescription: String {
    switch self {
    case .sunday:     return "Sun"
    case .monday:     return "Mon"
    case .tuesday:    return "Tue"
    case .wednesday:  return "Wed"
    case .thursday:   return "Thu"
    case .friday:     return "Fri"
    case .saturday:   return "Sat"
    }
  }
}
