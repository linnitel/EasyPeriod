//
//  ViewController.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 24/04/2023.
//

import UIKit
import Foundation
import CoreData

class UserSettingsVC: UIViewController {

	weak public var coordinator: AppCoordinator?
	public var isFirstLaunch: Bool?

	private var datePersistance: [DateSettings] = []
	private var settingsModel: SettingsModel?

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
		field.placeholder = "Cycle length: "
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
		button.addTarget(self, action: #selector(self.goBackSaving), for: .touchUpInside)
		button.layer.cornerRadius = 8
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.fetchData()
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
				action: #selector(goBack)
			)
			navigationItem.leftBarButtonItem?.tintColor = UIColor(
				cgColor:  CGColor(red: 256, green: 0, blue: 25, alpha: 100)
			)
		}
	}

	@objc private func goBack() {
		// TODO add alert that date will not be saved
		self.coordinator?.closeSettings()
	}

	@objc private func goBackSaving() {
		guard let periodLength = Int(periodLengthTextField.text!),
			  let cycleLength = Int(cycleLengthTextField.text!) else {
			// TODO create alert that asks all date to be filled in
				return
			  }
		let settingsModel = SettingsModel(
			lastPeriodBeginDate: datePicker.date,
			periodLength: periodLength,
			cycleLength: cycleLength)
		self.save(settingsModel: settingsModel) {
			print(settingsModel)
			self.coordinator?.closeSettings()
		}
	}

	// CoreData Interactions

	private func fetchData() {
		PersistanceService.shared.fetchData { result in
			switch result {
				case .success(let date):
					DispatchQueue.main.async {
						self.datePersistance = date
						if !date.isEmpty,
						   let lastPeriodDate = date[0].lastPeriodDate {
							self.settingsModel = SettingsModel(
								lastPeriodBeginDate: lastPeriodDate,
								periodLength: Int(date[0].periodLength),
								cycleLength: Int(date[0].cycleLength)
							)
							self.cycleLengthTextField.text = String(self.settingsModel!.cycleLength)
							self.periodLengthTextField.text = String(self.settingsModel!.periodLength)
							self.datePicker.date = self.settingsModel!.lastPeriodBeginDate
						}
					}
				case .failure(let error):
					print(error.localizedDescription)
			}
		}
	}

	private func save(settingsModel: SettingsModel, completion: ()-> Void) {
		defer {
			completion()
		}
		if self.datePersistance.isEmpty {
			PersistanceService.shared.create(settingsModel) { settingsModel in
				return
			}
		} else {
			PersistanceService.shared.update(self.datePersistance[0], with: settingsModel)
		}
	}


}

