//
//  CalendarVC.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation
import UIKit

class CalendarVC: UIViewController {
	
	weak public var coordinator: Coordinator?

	private lazy var periodLengthTextField: UITextField = {
		let field = UITextField(frame: CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.midY - 100, width: self.view.bounds.width - 32, height: 50))
		field.placeholder = "Period Length: "
		field.backgroundColor = .white
		field.layer.borderColor = CGColor(red: 256, green: 0, blue: 25, alpha: 100)
		field.layer.borderWidth = 1
		field.layer.cornerRadius = 8
		return field
	}()

	private lazy var lastPeriodDateStart: UILabel = {
		let label = UILabel(frame: CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.midY - 100, width: self.view.bounds.width - 32, height: 50))
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
	}

	private func setupViews() {
		view.backgroundColor = .white
		view.frame = UIScreen.main.bounds
		view.addSubview(self.periodLengthTextField)
	}

	private func setupNavigationBar() {
	}
}
