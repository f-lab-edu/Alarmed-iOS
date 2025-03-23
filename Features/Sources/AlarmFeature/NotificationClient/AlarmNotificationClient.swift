//
//  AlarmNotificationClient.swift
//  Features
//
//  Created by Geonhee on 3/23/25.
//

import SharedModels

import Foundation
import UserNotifications

import ComposableArchitecture

// MARK: - AlarmNotificationClient

@DependencyClient
public struct AlarmNotificationClient: Sendable {

  // MARK: Lifecycle

  public init(
    scheduleAlarm: @escaping @Sendable (Alarm, NotificationContent) -> NotificationContent)
  {
    self.scheduleAlarm = scheduleAlarm
  }

  // MARK: Public

  public struct NotificationContent: Equatable, Identifiable, Sendable {
    public let id: UUID
    public var title: String
    public var body: String

    public init(id: UUID, title: String, body: String) {
      self.id = id
      self.title = title
      self.body = body
    }
  }

  @discardableResult
  public func scheduleAlarm(_ alarm: Alarm, content: NotificationContent) async throws -> NotificationContent {
    try await scheduleAlarm(alarm, content)
  }

  // MARK: Internal

  var scheduleAlarm: @Sendable (Alarm, NotificationContent) async throws -> NotificationContent

}

extension AlarmNotificationClient {
  public static func live() -> Self {
    Self(
      scheduleAlarm: { alarm, content in
        let center = UNUserNotificationCenter.current()
        let triggerDate = alarm.time.nextAlarmDate()
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)

        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = notificationContent.title
        notificationContent.body = notificationContent.body

        let request = UNNotificationRequest(
          identifier: content.id.uuidString,
          content: notificationContent,
          trigger: trigger)

        try await center.add(request)
        return content
      })
  }
}

extension DependencyValues {
  public var alarmNotificationClient: AlarmNotificationClient {
    get { self[AlarmNotificationClientKey.self] }
    set { self[AlarmNotificationClientKey.self] = newValue }
  }
}

private enum AlarmNotificationClientKey: DependencyKey {
  static let liveValue = AlarmNotificationClient.live()
}
