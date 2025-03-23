//
//  Alarm.swift
//  Features
//
//  Created by Geonhee on 3/23/25.
//

import Foundation

import ComposableArchitecture

// MARK: - Alarm

public struct Alarm: Identifiable, Equatable, Sendable {

  // MARK: Lifecycle

  public init(
    id: UUID,
    time: Time,
    repetition: Repetition,
    sound: Sound,
    snooze: Snooze,
    memo: String)
  {
    self.id = id
    self.time = time
    self.repetition = repetition
    self.sound = sound
    self.snooze = snooze
    self.memo = memo
  }

  // MARK: Public

  public struct Time: Equatable, Sendable {

    // MARK: Lifecycle

    public init(hour: Int, minute: Int) {
      self.hour = hour
      self.minute = minute
    }

    // MARK: Public

    public var hour: Int
    public var minute: Int

    public var timeRemainingDescription: String {
      @Dependency(\.date.now) var now
      let target = nextAlarmDate()
      let interval = target.timeIntervalSince(now)
      if interval <= 0 { return "Ringing soon!" }
      let hours = Int(interval / 3600)
      let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
      return "Alarm will ring in \(hours) hours and \(minutes) minutes"
    }

    public func nextAlarmDate() -> Date {
      @Dependency(\.date.now) var now
      @Dependency(\.calendar) var calendar
      guard
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now))
      else {
        return now
      }

      var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
      components.hour = hour
      components.minute = minute
      components.second = 0
      return calendar.date(from: components) ?? now
    }

  }

  public struct Repetition: Equatable, Sendable {

    // MARK: Lifecycle

    public init(weekdays: [Weekday], selectedWeekdays: Set<Weekday>) {
      self.weekdays = weekdays
      self.selectedWeekdays = selectedWeekdays
    }

    // MARK: Public

    public var weekdays: [Weekday]
    public var selectedWeekdays: Set<Weekday>

    public var isDaily: Bool {
      get {
        selectedWeekdays == Set(weekdays)
      }
      set {
        if newValue {
          selectedWeekdays = Set(weekdays)
        } else {
          selectedWeekdays.removeAll()
        }
      }
    }
  }

  public struct Sound: Equatable, Sendable {
    public var volume: Double
    public var name: String

    public init(volume: Double, name: String) {
      self.volume = volume
      self.name = name
    }
  }

  public struct Snooze: Equatable, Sendable {
    public var minutes: Int
    public var repeatCount: Int

    public init(minutes: Int, repeatCount: Int) {
      self.minutes = minutes
      self.repeatCount = repeatCount
    }
  }

  public let id: UUID
  public var time: Time
  public var repetition: Repetition
  public var sound: Sound
  public var snooze: Snooze
  public var memo: String

}

extension Alarm {
  public static func `default`() -> Self {
    @Dependency(\.uuid) var uuid
    return Self(
      id: uuid(),
      time: .now(),
      repetition: .daily(),
      sound: .default(),
      snooze: .default(),
      memo: "")
  }
}

extension Alarm.Time {
  public static func now() -> Self {
    @Dependency(\.date.now) var now
    @Dependency(\.calendar) var calendar
    let components = calendar.dateComponents([.hour, .minute], from: now)
    return Self(hour: components.hour ?? 0, minute: components.minute ?? 0)
  }
}

extension Alarm.Repetition {
  public static func daily() -> Self {
    let allWeekdays = Weekday.allCases
    return Self(weekdays: allWeekdays, selectedWeekdays: Set(allWeekdays))
  }
}

extension Alarm.Sound {
  public static func `default`() -> Self {
    Self(volume: 0.5, name: "Ocarina")
  }
}

extension Alarm.Snooze {
  public static func `default`() -> Self {
    Self(minutes: 5, repeatCount: 3)
  }
}
