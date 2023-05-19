//
//  UserProfileService.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation
import UIKit

struct UserProfileService {
	static let shared = UserProfileService()

//	let defaults = UserDefaults.standard
	let defaults = UserDefaults(suiteName: "group.easyPeriod.linnitel")!

	private init() {}

	func setStatus(_ status: CalendarModel.PartOfCycle) {
		defaults.set(status.rawValue, forKey: "periodStatus")
	}
	func getStatus() -> CalendarModel.PartOfCycle {
		let rawValue = defaults.integer(forKey: "periodStatus")
		let status = CalendarModel.PartOfCycle(rawValue: rawValue) ?? .offPeriod
		return status
	}

	func setStartDate(_ date: Date) {
		defaults.set(date.timeIntervalSince1970, forKey: "startDate")
	}
	func getStartDate() -> Date {
		Date(timeIntervalSince1970: defaults.double(forKey: "startDate"))
	}

	func setCycle(_ cycle: Int) {
		defaults.set(cycle, forKey: "cycle")
	}
	func getCycle() -> Int {
		defaults.integer(forKey: "cycle")
	}

	func setPeriod(_ cycle: Int) {
		defaults.set(cycle, forKey: "period")
	}
	func getPeriod() -> Int {
		defaults.integer(forKey: "period")
	}

	func setSettings(_ settings: CalendarModel) {
		self.setStatus(settings.partOfCycle)
		self.setStartDate(settings.startDate)
		self.setCycle(settings.cycle)
		self.setPeriod(settings.period)
	}
	func getSettings() -> CalendarModel {
		let startDate = self.getStartDate()
		let status = self.getStatus()
		let period = self.getPeriod()
		let cycle = self.getCycle()

		return CalendarModel(
			startDate: startDate,
			partOfCycle: status,
			period: period,
			cycle: cycle)
	}
}
