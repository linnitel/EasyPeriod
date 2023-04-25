//
//  UserSettingsService.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation

struct UserProfileService {
	static let singleton = UserProfileService()

	let defaults = UserDefaults.standard

	private init() {}

	func isFirstLaunch() -> Bool {
		if defaults.bool(forKey: "isFirstLaunch") {
			defaults.set(false, forKey: "isAppAlreadyLaunchedOnce")
			print("App launched first time")
			return true
		}
		print("App already launched")
		return false
	}

}
