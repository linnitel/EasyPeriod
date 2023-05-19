//
//  String+Extention.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 18/05/2023.
//

import Foundation

public extension String {

	func localized() -> String {
		return NSLocalizedString(self, comment: "")
	}
}
