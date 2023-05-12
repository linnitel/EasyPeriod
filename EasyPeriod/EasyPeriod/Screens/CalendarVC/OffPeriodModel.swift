//
//  OffPeriodModel.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation

struct OffPeriodModel {
	var date: Date
	var partOfCycle: PartOfCycle
	var period: Int
	var cycle: Int

	enum PartOfCycle {
		case offPeriod
		case period
		case delay
	}
}
