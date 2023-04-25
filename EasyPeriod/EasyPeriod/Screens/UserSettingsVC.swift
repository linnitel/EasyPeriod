//
//  ViewController.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 24/04/2023.
//

import UIKit

class UserSettingsVC: UIViewController {

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

	private lazy var lastPeriodDate: UITextField = {
		let field = UITextField(frame: CGRect(x: self.view.bounds.minX + 16, y: self.periodLengthTextField.frame.maxY + 12, width: self.view.bounds.width - 32, height: 50))
		field.placeholder = "Last period Date: "
		field.backgroundColor = .white
		field.layer.borderColor = CGColor(red: 256, green: 0, blue: 25, alpha: 100)
		field.layer.borderWidth = 1
		field.layer.cornerRadius = 8
		return field
	}()

	private lazy var datePicker: UIDatePicker = {
		let picker = UIDatePicker(frame: CGRect(x: self.view.bounds.minX + 16, y: self.lastPeriodDate.frame.minY + 8, width: self.view.bounds.width - 32, height: 50))
		picker.datePickerMode = .date
		picker.maximumDate = .now
		picker.subviews[0].subviews[0].subviews[0].alpha = 0
		picker.calendar = Calendar(identifier: .gregorian)
		return picker
	}()

	private lazy var buttonCalculate: UIButton = {
		let button = UIButton(frame: CGRect(x: self.view.bounds.midX - 70, y: self.datePicker.frame.maxY + 12, width: 140, height: 50))
		button.backgroundColor = UIColor(cgColor: CGColor(red: 256, green: 0, blue: 25, alpha: 100))
		button.setTitle("Calculate", for: .normal)
		button.layer.cornerRadius = 8
		return button
	}()

//	private lazy var dateRrange: UITextView = {
//
//	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
	}


	private func setupViews() {
		view.backgroundColor = .white
		view.frame = UIScreen.main.bounds
		view.addSubview(self.periodLengthTextField)
		view.addSubview(self.lastPeriodDate)
		view.addSubview(self.datePicker)
		view.addSubview(self.buttonCalculate)
	}
}

