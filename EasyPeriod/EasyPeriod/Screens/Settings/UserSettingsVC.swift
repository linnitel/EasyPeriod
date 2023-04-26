//
//  ViewController.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 24/04/2023.
//

import UIKit
import Foundation

class UserSettingsVC: UIViewController {

	weak public var coordinator: AppCoordinator?
	public var isFirstLaunch: Bool?

	private lazy var periodLengthTextField: UITextField = {
		let field = UITextField(frame: CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.midY - 100, width: self.view.bounds.width - 32, height: 50))
		field.placeholder = "Period Length: "
		field.backgroundColor = .white
		field.layer.borderColor = CGColor(red: 256, green: 0, blue: 25, alpha: 100)
		field.layer.borderWidth = 1
		field.layer.cornerRadius = 8
		return field
	}()

	private lazy var cycleLengthTextField: UITextField = {
		let field = UITextField(frame: CGRect(x: self.view.bounds.minX + 16, y: self.periodLengthTextField.frame.maxY + 12, width: self.view.bounds.width - 32, height: 50))
		field.placeholder = "Last period Date: "
		field.backgroundColor = .white
		field.layer.borderColor = CGColor(red: 256, green: 0, blue: 25, alpha: 100)
		field.layer.borderWidth = 1
		field.layer.cornerRadius = 8
		return field
	}()

	private lazy var lastPeriodLable: UILabel = {
		let label = UILabel(frame: CGRect(x: self.view.bounds.minX + 16, y: self.cycleLengthTextField.frame.maxY + 12, width: self.view.bounds.width - 32, height: 50))
		label.text = "Last period Date: "
		return label
	}()

	private lazy var datePicker: UIDatePicker = {
		let picker = UIDatePicker(frame: CGRect(x: self.view.bounds.minX + 16, y: self.lastPeriodLable.frame.minY + 8, width: self.view.bounds.width - 32, height: 50))
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

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
		self.setupNavigationBar()
	}

	private func setupViews() {
		view.backgroundColor = .white
		view.frame = UIScreen.main.bounds
		view.addSubview(self.periodLengthTextField)
		view.addSubview(self.cycleLengthTextField)
		view.addSubview(self.datePicker)
		view.addSubview(self.buttonCalculate)
		view.addSubview(self.lastPeriodLable)
	}

	private func setupNavigationBar() {
		if let isFirstLaunch = self.isFirstLaunch,
		   !isFirstLaunch {
			let navigationLeftItem = UIImage(systemName: "arrow.left")

			navigationItem.leftBarButtonItem = UIBarButtonItem(
				image: navigationLeftItem,
				style: .plain,
				target: self,
				action: #selector(action)
			)
			navigationItem.leftBarButtonItem?.tintColor = UIColor(
				cgColor:  CGColor(red: 256, green: 0, blue: 25, alpha: 100)
			)
		}
	}

	@objc func action() {
		self.coordinator?.closeSettings()
	}
}

