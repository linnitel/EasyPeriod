//
//  Date+Extention.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 29/05/2023.
//

import Foundation

extension Date {
	func isInSameDay(with date: Date) -> Bool {
		let calendar = Calendar(identifier: .gregorian)
		let lhsYear = calendar.component(.year, from: self)
		let lhsMonth = calendar.component(.month, from: self)
		let lhsDay = calendar.component(.day, from: self)
		let rhsYear = calendar.component(.year, from: date)
		let rhsMonth = calendar.component(.month, from: date)
		let rhsDay = calendar.component(.day, from: date)
		return lhsYear == rhsYear && lhsMonth == rhsMonth && lhsDay == rhsDay
	}
}
