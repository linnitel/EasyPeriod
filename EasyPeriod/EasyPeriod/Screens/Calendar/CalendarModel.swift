//
//  CalendarModel.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation

struct CalendarModel {
	let nextPeriodDate: Date
	let partOfCycle: PartOfCycle

	enum PartOfCycle {
		case period
		case menstruation
		case delay
	}
}
