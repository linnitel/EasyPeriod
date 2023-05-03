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

	private lazy var periodLengthView: DropDownPickerView = {
		let view = DropDownPickerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "Period Length (In days): "
		view.order = .isFirst
		let arrayInt = Array<Int>(1...10)
		var arrayString = [String]()
		arrayInt.forEach {
			arrayString.append(String($0))
		}
		view.pickerData = arrayString
		return view
	}()

	private lazy var cycleLengthView: DropDownPickerView = {
		let view = DropDownPickerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "Cycle length (In days): "
		view.order = .middle
//		let arrayInt = Array<Int>(21...40)
//		var arrayString = [String]()
//		arrayInt.forEach {
//			arrayString.append(String($0))
//		}
		view.pickerData = ["21", "22", "23", "24", "25",
						   "26", "27", "28", "29", "30",
						   "31", "32", "33", "34", "35",
						   "36", "37", "38", "39", "40"]
		return view
	}()

	private lazy var previousDateView: DropDownDateView = {
		let view = DropDownDateView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "Last period Date: "
		view.isOpen = false
		view.order = .isLast
		return view
	}()

	private lazy var buttonCalculate: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
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
		self.setupConstraints()
		self.setupNavigationBar()
	}

	private func setupViews() {
		self.view.backgroundColor = UIColor(named: "backgroundColor")

		view.addSubview(self.periodLengthView)
		view.addSubview(self.cycleLengthView)
		view.addSubview(self.buttonCalculate)
		view.addSubview(self.previousDateView)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			periodLengthView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			periodLengthView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			periodLengthView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),

			cycleLengthView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			cycleLengthView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			cycleLengthView.topAnchor.constraint(equalTo: periodLengthView.bottomAnchor),

			previousDateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			previousDateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			previousDateView.topAnchor.constraint(equalTo: cycleLengthView.bottomAnchor),

			buttonCalculate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonCalculate.topAnchor.constraint(equalTo: previousDateView.bottomAnchor, constant: 24),
			buttonCalculate.heightAnchor.constraint(equalToConstant: 56),
			buttonCalculate.widthAnchor.constraint(equalToConstant: 240)
		])
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

		guard let text = self.periodLengthView.valueLabel.text,
			let periodLength = Int(text),
			  let cycleText = self.cycleLengthView.valueLabel.text,
			  let cycleLength = Int(cycleText) else {
			// TODO: add alert that not all fields were filled
				return
			  }
		let settingsModel = SettingsModel(
			lastPeriodBeginDate: self.previousDateView.datePicker.date,
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
							self.periodLengthView.valueLabel.text = String(self.settingsModel!.periodLength)
							self.cycleLengthView.valueLabel.text = String(self.settingsModel!.cycleLength)
							self.previousDateView.datePicker.date = self.settingsModel!.lastPeriodBeginDate
							let date = DateFormatter(dateFormat: "d.MM.yyyy", calendar: Calendar.current).string(from: self.settingsModel!.lastPeriodBeginDate)
							self.previousDateView.valueLabel.text = date
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

