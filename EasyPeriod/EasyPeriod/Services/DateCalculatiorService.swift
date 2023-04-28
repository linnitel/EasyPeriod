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

	func calculateDate(_ date: Date, cycle: Int, period: Int, delay: Bool) -> Date {
		let now = Date()
		if delay {
			return now
		}
		let possiblePeriod = Calendar.current.date(byAdding: .day, value: period, to: date)!
		if date > now, date < possiblePeriod || Calendar.current.isDate(now, equalTo: date, toGranularity: .day) {
			return date
		}
		var nextDate = Calendar.current.date(byAdding: .day, value: cycle, to: date)!
		while nextDate < now {
			nextDate = Calendar.current.date(byAdding: .day, value: cycle, to: nextDate)!
		}
//		if Calendar.current.isDate(now, equalTo: nextDate, toGranularity: .day) {
//		}
		return nextDate
	}

	func calculateState(_ nextDate: Date, cycle: Int, period: Int, delay: Bool) -> CalendarModel.PartOfCycle {
		if delay {
			return .delay
		}
		let now = Date()
		let endPeriod = Calendar.current.date(byAdding: .day, value: period, to: nextDate)!
		if Calendar.current.isDate(now, equalTo: nextDate, toGranularity: .day) {
			return .startDay
		} else if now < nextDate {
			return .offPeriod
		}
		return .period
	}

	func getDay(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func getMonth(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "LLLL", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func getWeekday(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "EE", calendar: Calendar.current)
		return formatter.string(from: date)
	}
}
