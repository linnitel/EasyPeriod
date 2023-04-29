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

	private lazy var periodLengthView: DropDownView = {
//		let view = DropDownView(frame: CGRect(
//			x: self.view.bounds.minX + 16,
//			y: self.view.bounds.midY - 200,
//			width: self.view.bounds.width - 32,
//			height: 50)
//		)
		let view = DropDownView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "Period Length (In days): "
		view.order = .isFirst
		return view
	}()

	private lazy var cycleLengthView: DropDownView = {
//		let view = DropDownView(frame: CGRect(
//			x: self.view.bounds.minX + 16,
//			y: self.periodLengthView.frame.maxY,
//			width: self.view.bounds.width - 32,
//			height: 50)
//		)
		let view = DropDownView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "Cycle length (In days): "
		view.order = .middle
		return view
	}()

	private lazy var lastPeriodLable: UILabel = {
//		let label = UILabel(frame: CGRect(
//			x: self.view.bounds.minX + 16,
//			y: self.cycleLengthView.frame.maxY,
//			width: self.view.bounds.width - 32,
//			height: 50))
		let label = UILabel()
		view.translatesAutoresizingMaskIntoConstraints = false
		label.font = label.font.withSize(17)
		label.text = "Last period Date: "
		return label
	}()

	private lazy var datePicker: UIDatePicker = {
//		let picker = UIDatePicker(frame: CGRect(x: self.view.bounds.minX + 16, y: self.lastPeriodLable.frame.maxY + 12, width: self.view.bounds.width - 32, height: 150))
		let picker = UIDatePicker()
		picker.translatesAutoresizingMaskIntoConstraints = false
		picker.datePickerMode = .date
		picker.maximumDate = .now
		picker.minimumDate = .distantPast
		picker.preferredDatePickerStyle = .wheels
		picker.subviews[0].subviews[0].subviews[0].alpha = 0
		picker.calendar = Calendar(identifier: .gregorian)
		return picker
	}()

	private lazy var buttonCalculate: UIButton = {
//		let button = UIButton(frame: CGRect(
//			x: self.view.bounds.midX - 120,
//			y: self.datePicker.frame.maxY + 12,
//			width: 240,
//			height: 56)
//		)
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
//		view.addSubview(self.datePicker)
//		view.addSubview(self.buttonCalculate)
//		view.addSubview(self.lastPeriodLable)
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			periodLengthView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			periodLengthView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			periodLengthView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),

			cycleLengthView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
			cycleLengthView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
			cycleLengthView.topAnchor.constraint(equalTo: periodLengthView.bottomAnchor),

//			lastPeriodLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//			lastPeriodLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//			lastPeriodLable.topAnchor.constraint(equalTo: cycleLengthView.bottomAnchor),
//			lastPeriodLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//
//			datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//			datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//			datePicker.topAnchor.constraint(equalTo: lastPeriodLable.bottomAnchor),

//			buttonCalculate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//			buttonCalculate.topAnchor.constraint(equalTo: periodLengthView.topAnchor, constant: 24),
//			buttonCalculate.heightAnchor.constraint(equalToConstant: 56),
//			buttonCalculate.widthAnchor.constraint(equalToConstant: 250)
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
		// TODO: change for selectors
		guard let periodLength = Int(self.periodLengthView.valueLabel.text!),
			  let cycleLength = Int(self.cycleLengthView.valueLabel.text!) else {
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
							self.cycleLengthView.valueLabel.text = String(self.settingsModel!.cycleLength)
							self.periodLengthView.valueLabel.text = String(self.settingsModel!.periodLength)
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

