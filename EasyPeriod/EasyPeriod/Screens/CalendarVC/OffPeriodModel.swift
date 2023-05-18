//
//  OffPeriodModel.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation

struct OffPeriodModel {
	var startDate: Date

	var endDate: Date {
		Calendar.current.date(byAdding: .day, value: period, to: startDate)!
	}

	var showDate: Date {
		switch partOfCycle {
			case .notSet, .period, .delay:
				return Date()
			case .offPeriod:
				return startDate
		}
	}

	var partOfCycle: PartOfCycle
	var period: Int
	var cycle: Int

	enum PartOfCycle: Int {
		case notSet = 0
		case offPeriod = 1
		case period = 2
		case delay = 3
	}
}
