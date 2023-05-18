//
//  Notifications.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 15/05/2023.
//

import Foundation
import UserNotifications

class Notifications: NSObject {
	let notificationCenter = UNUserNotificationCenter.current()

	func notificationRequest() {

		let options: UNAuthorizationOptions = [.alert, .sound, .badge]

		notificationCenter.requestAuthorization(options: options) { success, error in
			if success {
				print("All set!")
			} else if let error = error {
				print(error.localizedDescription)
			} else {
				print("User didn't allow notifications")
			}
		}
	}

	func scheduleNotification(for timeInterval: TimeInterval) {

		let content = UNMutableNotificationContent() // Содержимое уведомления

		content.title = "Periods are comming."
		content.body = "Your next period starts tomorrow."
		content.sound = UNNotificationSound.default
		content.badge = 1

		let trigger = createTrigger(for: timeInterval)

		let identifier = "Local Notification"
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

		self.notificationCenter.add(request) { (error) in
			if let error = error {
				print("Error \(error.localizedDescription)")
			}
		}
	}

	func createTrigger(for timeInterval: TimeInterval) -> UNTimeIntervalNotificationTrigger {
		return UNTimeIntervalNotificationTrigger(timeInterval: Double(timeInterval), repeats: true)
//		return UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
	}
}

extension Notifications: UNUserNotificationCenterDelegate {
	
}
