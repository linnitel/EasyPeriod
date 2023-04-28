//
//  DateFormatter+Extention.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 28/04/2023.
//

import Foundation

extension DateFormatter {
	convenience init(dateFormat: String, calendar: Calendar) {
		self.init()
		self.dateFormat = dateFormat
		self.calendar = calendar
	}
}
