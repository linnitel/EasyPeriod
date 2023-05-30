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
	let notifications = Notifications()

	public var isFirstLaunch: Bool?

	private var calendarModel: CalendarModel?

	private lazy var periodLengthView: DropDownPickerView = {
		let view = DropDownPickerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "UserSettingsVC.periodLengthView.text".localized()
		view.order = .isFirst
		let arrayInt = Array<Int>(1...10)
		var arrayString = [String]()
		arrayInt.forEach {
			arrayString.append(String($0))
		}
		view.pickerData = arrayString
		let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.periodLengthAction))
		view.addGestureRecognizer(gesture)
		return view
	}()

	private lazy var cycleLengthView: DropDownPickerView = {
		let view = DropDownPickerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "UserSettingsVC.cycleLengthView.text".localized()
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
		let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.cycleLengthAction))
		view.addGestureRecognizer(gesture)
		return view
	}()

	private lazy var previousDateView: DropDownDateView = {
		let view = DropDownDateView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.labelTitle.text = "UserSettingsVC.previousDateView.text".localized()
		view.isOpen = false
		view.order = .isLast
		let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.previousDateAction))
		view.addGestureRecognizer(gesture)
		return view
	}()

	private lazy var buttonCalculate: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .white
		button.setTitle("UserSettingsVC.buttonCalculate".localized(), for: .normal)
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
		self.title = "UserSettingsVC.NavigationBar.title".localized()
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
		} else {
			navigationItem.setHidesBackButton(true, animated: false)
		}
	}

	@objc private func goBack() {
		self.showGoBackAlert()
	}

	@objc private func goBackSaving() {
		guard let text = self.periodLengthView.valueLabel.text,
			let periodLength = Int(text),
			  let cycleText = self.cycleLengthView.valueLabel.text,
			  let cycleLength = Int(cycleText),
			  let dateText = self.previousDateView.valueLabel.text,
			  !dateText.isEmpty else {
			self.showFillingAllFieldsAlert()
			return
			  }

		guard var model = self.calendarModel else { return }

		var periodStartDate = DateCalculatiorService.shared.calculateStartDate(
			self.previousDateView.datePicker.date,
			cycle: cycleLength,
			period: periodLength
		)
		model.startDate = periodStartDate
		model.cycle = cycleLength
		model.period = periodLength
		if model.partOfCycle == .notSet {
			model.partOfCycle = .offPeriod
		}
		UserProfileService.shared.setSettings(model)

		// Setap notification
		let now = Date()
		if periodStartDate < now ||
			Calendar.current.isDate(now, equalTo: periodStartDate, toGranularity: .day) ||
			Calendar.current.isDate(now, equalTo: Calendar.current.date(byAdding: .day, value: -1, to: periodStartDate)!, toGranularity: .day) {
			periodStartDate = DateCalculatiorService.shared.getNextPriodDate(periodStartDate, cycle: cycleLength)
		}
		let timeInterval = DateCalculatiorService.shared.calculateTimeInterval(to: periodStartDate)
		if timeInterval > 0 {
			self.notifications.scheduleNotification(for: timeInterval)
		}

		self.coordinator?.closeSettings()
	}

	// MARK: UserDefalts Interactions
	private func fetchData() {
		let settings = UserProfileService.shared.getSettings()
		guard settings.partOfCycle != .notSet else {
			self.calendarModel = settings
			return
		}
		self.cycleLengthView.valueLabel.text = String(settings.cycle)
		self.periodLengthView.valueLabel.text = String(settings.period)
		self.previousDateView.datePicker.date = settings.startDate
		let date = DateFormatter(dateFormat: "d.MM.yyyy", calendar: Calendar.current).string(from: settings.startDate)
		self.previousDateView.valueLabel.text = date
		self.calendarModel = settings
	}

	// MARK: Alerts
	private func showGoBackAlert() {
		// Create Alert
		let dialogMessage = UIAlertController(title: "UserSettingsVC.GoBackAlert.title".localized(), message: "UserSettingsVC.GoBackAlert.message".localized(), preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "UserSettingsVC.GoBackAlert.ok".localized(), style: .destructive, handler: { (action) -> Void in

			self.coordinator?.closeSettings()
		})
		// Create Cancel button with action handlder
		let cancel = UIAlertAction(title: "UserSettingsVC.GoBackAlert.cancel".localized(), style: .cancel) { (action) -> Void in
		}
		ok.setValue(UIColor(named: "mainColor"), forKey: "titleTextColor")
		cancel.setValue(UIColor(named: "mainColor"), forKey: "titleTextColor")
		//Add OK and Cancel button to an Alert object
		dialogMessage.addAction(ok)
		dialogMessage.addAction(cancel)
		// Present alert message to user
		self.present(dialogMessage, animated: true, completion: nil)
	}

	private func showFillingAllFieldsAlert() {
		// Create Alert
		let dialogMessage = UIAlertController(title: "UserSettingsVC.FillingAllFieldsAlert.title".localized(), message: "UserSettingsVC.FillingAllFieldsAlert.message".localized(), preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "UserSettingsVC.FillingAllFieldsAlert.ok".localized(), style: .default, handler: { (action) -> Void in
		})
		ok.setValue(UIColor(named: "mainColor"), forKey: "titleTextColor")
		//Add OK and Cancel button to an Alert object
		dialogMessage.addAction(ok)
		// Present alert message to user
		self.present(dialogMessage, animated: true, completion: nil)
	}

	// MARK: gestures
	@objc func periodLengthAction(sender : UITapGestureRecognizer) {
		self.periodLengthView.isOpen.toggle()
		self.periodLengthView.picker.isHidden.toggle()

		self.cycleLengthView.isOpen = false
		self.cycleLengthView.picker.isHidden = true
		self.previousDateView.isOpen = false
		self.previousDateView.datePicker.isHidden = true
	}

	@objc func cycleLengthAction(sender : UITapGestureRecognizer) {
		self.cycleLengthView.isOpen.toggle()
		self.cycleLengthView.picker.isHidden.toggle()

		self.periodLengthView.isOpen = false
		self.periodLengthView.picker.isHidden = true
		self.previousDateView.isOpen = false
		self.previousDateView.datePicker.isHidden = true
	}

	@objc func previousDateAction(sender : UITapGestureRecognizer) {
		self.previousDateView.isOpen.toggle()
		self.previousDateView.datePicker.isHidden.toggle()

		self.cycleLengthView.isOpen = false
		self.cycleLengthView.picker.isHidden = true
		self.periodLengthView.isOpen = false
		self.periodLengthView.picker.isHidden = true
	}
}

