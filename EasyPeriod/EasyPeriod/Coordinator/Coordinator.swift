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

	override func start() {
		let isFirstLaunch = UserProfileService.singleton.isFirstLaunch()
		if isFirstLaunch {
			let userSettingsVC = UserSettingsVC()
			userSettingsVC.coordinator = self
			self.router?.setViewControllers([userSettingsVC], animated: false)
		} else {
			let calendarVC = CalendarVC()
			calendarVC.coordinator = self
			self.router?.setViewControllers([calendarVC], animated: false)
		}
	}
}
