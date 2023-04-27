//
//  DateCalculatiorService.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 27/04/2023.
//

import Foundation

class DateCalculatiorService {

	static let shared = DateCalculatiorService()

	private init() {}

	func calculateDate(_ date: Date, cycle: Int) -> Date {
		return Date()
	}

	func calculateState(_ nextDate: Date, cycle: Int, period: Int) -> CalendarModel.PartOfCycle {
		.period
	}

	func getDay(_ date: Date) -> String {
		return "28"
	}

	func getMonth(_ date: Date) -> String {
		return "april"
	}

	func getWeekday(_ date: Date) -> String {
		return "wed"
	}
}
