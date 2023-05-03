//
//  Coordinator.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 24/04/2023.
//

import UIKit
import Foundation

class Coordinator {

	weak var router: UINavigationController?


	init(router: UINavigationController?) {
		self.router = router
	}

	func start() {
		print("the coordinator is running")
	}
}

class AppCoordinator: Coordinator {
	// TODO: add check for all fields are filled? with data
	override func start() {
		let isAppAlreadyLaunchedOnce = UserProfileService.shared.isAppAlreadyLaunchedOnce()
		if !isAppAlreadyLaunchedOnce {
			let userSettingsVC = UserSettingsVC()
			userSettingsVC.coordinator = self
			userSettingsVC.isFirstLaunch = true
			UserProfileService.shared.setDelay(false)
			self.router?.setViewControllers([userSettingsVC], animated: false)
		} else {
			let calendarVC = CalendarVC()
			calendarVC.coordinator = self
			self.router?.setViewControllers([calendarVC], animated: false)
		}
	}

	func openSettings() {
		let userSettingsVC = UserSettingsVC()
		userSettingsVC.coordinator = self
		userSettingsVC.isFirstLaunch = false
		self.router?.pushViewController(userSettingsVC, animated: true)
	}

	func openCalendar() {
		let calendarVC = CalendarVC()
		calendarVC.coordinator = self
		self.router?.pushViewController(calendarVC, animated: true)
	}

	func closeSettings() {
		self.router?.popViewController(animated: true)
	}
}
