//
//  UserSettingsService.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation

struct UserProfileService {
	static let shared = UserProfileService()

	let defaults = UserDefaults.standard

	private init() {}

	func isAppAlreadyLaunchedOnce() -> Bool {
		if !defaults.bool(forKey: "isAppAlreadyLaunchedOnce") {
			defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
			print("App launched first time")
			return false
		}
		print("App already launched")
		return true
	}

	func getDelay() -> Bool {
		defaults.bool(forKey: "delay")
	}

	func setDelay(_ delay: Bool) {
		defaults.set(delay, forKey: "delay")
	}

}
