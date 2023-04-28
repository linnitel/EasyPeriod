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

	private lazy var periodLengthLabel: UILabel = {
		let label = UILabel(frame: CGRect(
			x: self.view.bounds.minX + 16,
			y: self.view.bounds.midY - 100,
			width: (self.view.bounds.width - 36) / 2,
			height: 50)
		)
		label.text = "Period Length: "
		return label
	}()

	private lazy var periodLengthTextField: UITextField = {
		let field = UITextField(frame: CGRect(
			x: self.periodLengthLabel.frame.maxX + 8,
			y: self.view.bounds.midY - 100,
			width: (self.view.bounds.width - 36) / 2,
			height: 50)
		)
		field.backgroundColor = .white
		field.layer.borderColor = UIColor(named: "mainColor")?.cgColor
		field.layer.borderWidth = 1
		field.layer.cornerRadius = 8
		return field
	}()

	private lazy var cycleLengthLabel: UILabel = {
		let label = UILabel(frame: CGRect(
			x: self.view.bounds.minX + 16,
			y: self.periodLengthTextField.frame.maxY + 12,
			width: (self.view.bounds.width - 36) / 2,
			height: 50)
		)
		label.text = "Cycle length: "
		label.backgroundColor = .white
		label.layer.cornerRadius = 8
		return label
	}()

	private lazy var cycleLengthTextField: UITextField = {
		let field = UITextField(frame: CGRect(
			x: self.cycleLengthLabel.frame.maxX + 8,
			y: self.periodLengthTextField.frame.maxY + 12,
			width: (self.view.bounds.width - 36) / 2,
			height: 50)
		)
		field.backgroundColor = .white
		field.layer.borderColor = UIColor(named: "mainColor")?.cgColor
		field.layer.borderWidth = 1
		field.layer.cornerRadius = 8
		return field
	}()

	private lazy var lastPeriodLable: UILabel = {
		let label = UILabel(frame: CGRect(
			x: self.view.bounds.minX + 16,
			y: self.cycleLengthTextField.frame.maxY + 12,
			width: self.view.bounds.width - 32,
			height: 50))
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
		let button = UIButton(frame: CGRect(
			x: self.view.bounds.midX - 120,
			y: self.datePicker.frame.maxY + 12,
			width: 240,
			height: 56)
		)
		button.backgroundColor = .white
		button.setTitle("Calculate", for: .normal)
		button.addTarget(self, action: #selector(self.goBackSaving), for: .touchUpInside)
		button.layer.cornerRadius = 28
		button.setTitleColor(UIColor(named: "mainColor"), for: .normal)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.fetchData()
		self.setupViews()
		self.setupNavigationBar()
	}

	private func setupViews() {
		self.view.backgroundColor = UIColor(named: "backgroundColor")
		view.frame = UIScreen.main.bounds
		view.addSubview(self.periodLengthLabel)
		view.addSubview(self.periodLengthTextField)
		view.addSubview(self.cycleLengthLabel)
		view.addSubview(self.cycleLengthTextField)
		view.addSubview(self.datePicker)
		view.addSubview(self.buttonCalculate)
		view.addSubview(self.lastPeriodLable)
	}

	private func setupNavigationBar() {
		self.title = "Settings"
		self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "mainColor") ?? .black]
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
				cgColor:  UIColor(named: "mainColor")?.cgColor ?? CGColor(red: 0, green: 0, blue: 0, alpha: 100)
			)
		}
	}

	@objc private func goBack() {
		// TODO: add alert that date will not be saved
		self.coordinator?.closeSettings()
	}

	@objc private func goBackSaving() {
		// TODO: change for selectors
		guard let periodLength = Int(periodLengthTextField.text!),
			  let cycleLength = Int(cycleLengthTextField.text!) else {
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

	// MARK: CoreData Interactions

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

