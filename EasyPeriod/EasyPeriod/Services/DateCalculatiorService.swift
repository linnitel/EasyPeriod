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

	func calculateStartDate(_ date: Date, cycle: Int, period: Int) -> Date {
		let now = Date()
		var nextDate = date
		if nextDate > now {
			return nextDate
		}

		while nextDate < now, !Calendar.current.isDate(now, equalTo: nextDate, toGranularity: .day) {
			nextDate = Calendar.current.date(byAdding: .day, value: cycle, to: nextDate)!
		}
		nextDate = Calendar.current.date(byAdding: .day, value: -cycle, to: nextDate)!
		let endDate = Calendar.current.date(byAdding: .day, value: period, to: nextDate)!
		
		if now > endDate, !Calendar.current.isDate(now, equalTo: endDate, toGranularity: .day) {
			nextDate = Calendar.current.date(byAdding: .day, value: cycle, to: nextDate)!
		}
		return nextDate
	}

	func calculateEndDate(_ startDate: Date, period: Int) -> Date {
		Calendar.current.date(byAdding: .day, value: period, to: startDate)!
	}

	func isPeriod(startDate: Date, endDate: Date) -> Bool {
		let now = Date()
		if now >= startDate, now <= endDate {
			return true
		} else if Calendar.current.isDate(now, equalTo: startDate, toGranularity: .day) ||
					Calendar.current.isDate(now, equalTo: endDate, toGranularity: .day) {
			return true
		}
		return false
	}

	func getNextPriodDate(_ date: Date, cycle: Int) -> Date {
		Calendar.current.date(byAdding: .day, value: cycle, to: date)!
	}

	func calculateTimeInterval(to date: Date) -> TimeInterval {
		let now = Date()
		let dateBefore = Calendar.current.date(byAdding: .day, value: -1, to: date)!
		return dateBefore.timeIntervalSinceReferenceDate - now.timeIntervalSinceReferenceDate + 12 * 360
	}

//	func calculateDate(_ date: Date, cycle: Int, period: Int, delay: Bool, isPeriod: Bool) -> Date {
//		let now = Date()
//		if delay || isPeriod {
//			return now
//		}
//		let possiblePeriod = Calendar.current.date(byAdding: .day, value: period, to: date)!
//		if date > now, date <= possiblePeriod || Calendar.current.isDate(now, equalTo: date, toGranularity: .day) || Calendar.current.isDate(possiblePeriod, equalTo: date, toGranularity: .day) {
//			return now
//		}
//		var nextDate = Calendar.current.date(byAdding: .day, value: cycle, to: date)!
//		while nextDate < now {
//			nextDate = Calendar.current.date(byAdding: .day, value: cycle, to: nextDate)!
//		}
//		if Calendar.current.isDate(now, equalTo: nextDate, toGranularity: .day) {
//		}
//		return nextDate
//	}

//	func calculateState(_ nextDate: Date, cycle: Int, period: Int, delay: Bool) -> OffPeriodModel.PartOfCycle {
//		if delay {
//			return .delay
//		}
//		let now = Date()
//		let endPeriod = Calendar.current.date(byAdding: .day, value: period, to: nextDate)!
//		if Calendar.current.isDate(now, equalTo: nextDate, toGranularity: .day) {
//			return .startDay
//		} else if now < nextDate {
//			return .offPeriod
//		}
//		return .period
//	}

	func getDay(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "d", calendar: Calendar.current)
		return formatter.string(from: date)
	}

	func getMonthAndWeek(_ date: Date) -> String {
		let formatter = DateFormatter(dateFormat: "MMMM, E", calendar: Calendar.current)
		return formatter.string(from: date)
	}
}
