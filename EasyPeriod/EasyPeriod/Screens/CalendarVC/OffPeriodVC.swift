//
//  OffPeriodVC.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation
import UIKit

class OffPeriodVC: UIViewController {
	
	weak public var coordinator: AppCoordinator?

	private var datePersistance: [DateSettings] = []
	private var delay: Bool {
		UserProfileService.shared.getDelay()
	}

	private var isPeriod: Bool {
		UserProfileService.shared.getIsPeriod()
	}
	private var calendarModel: OffPeriodModel?

	private var accentColor: UIColor = UIColor(named: "mainColor")! {
		didSet {
			self.descriptionText.textColor = self.accentColor
			self.buttonOne.backgroundColor = self.accentColor
			self.buttonTwo.backgroundColor = self.accentColor
			self.navigationItem.rightBarButtonItem?.tintColor = self.accentColor
			self.shape.dropColor = self.accentColor
		}
	}
	private var mainColor: UIColor = .white {
		didSet {
			self.buttonOne.setTitleColor(self.mainColor, for: .normal)
			self.buttonTwo.setTitleColor(self.mainColor, for: .normal)
			self.nextPeriodDate.textColor = self.mainColor
			self.nextPeriodMonthAndWeek.textColor = self.mainColor
			self.view.backgroundColor = self.mainColor
		}
	}

	private lazy var shape: DropShapeView = {
		let view = DropShapeView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		return view
	}()

	private lazy var nextPeriodDate: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 150)
		label.textAlignment = .center
		return label
	}()

	private lazy var nextPeriodMonthAndWeek: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .right
		return label
	}()

	private lazy var descriptionText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		return label
	}()

	private lazy var buttonOne: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = self.accentColor
		button.layer.cornerRadius = 28
		button.addTarget(self, action: #selector(self.buttonOneAction), for: .touchUpInside)
		return button
	}()

	private lazy var buttonTwo: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = self.accentColor
		button.layer.cornerRadius = 28
		button.addTarget(self, action: #selector(self.buttonTwoAction), for: .touchUpInside)
		button.setTitleColor(self.mainColor, for: .normal)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupViews()
		self.setupConstraints()
		self.setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		self.fetchData()

	}

	private func calculateData(for date: Date, cycle: Int, period: Int) {

		let periodStartDate = DateCalculatiorService.shared.calculateStartDate(date, cycle: cycle, period: period)
		let periodEndDate = DateCalculatiorService.shared.calculateEndDate(periodStartDate, period: period)
		var showDate: Date
		var partOfCycle: OffPeriodModel.PartOfCycle

		if delay {
			showDate = Date()
			partOfCycle = .delay
			self.calendarModel = OffPeriodModel(date: showDate, partOfCycle: partOfCycle)
			setupContent()
			return
		}

		let isPeriodCheck = DateCalculatiorService.shared.isPeriod(startDate: periodStartDate, endDate: periodEndDate)
		UserProfileService.shared.setIsPeriod(isPeriodCheck)
		if isPeriodCheck {
			partOfCycle = .period
			showDate = Date()
		} else {
			showDate = periodStartDate
			partOfCycle = .offPeriod
		}
		self.calendarModel = OffPeriodModel(date: showDate, partOfCycle: partOfCycle)
		setupContent()
	}

	private func setupContent() {

		guard let calendarModel = self.calendarModel else { return }
		self.nextPeriodDate.text = DateCalculatiorService.shared.getDay(calendarModel.date)
		self.nextPeriodMonthAndWeek.text = DateCalculatiorService.shared.getMonthAndWeek(calendarModel.date)
		switch calendarModel.partOfCycle {
			case .offPeriod:
				self.descriptionText.text = "Next period"
				self.buttonOne.setTitle("Started", for: .normal)
				self.buttonTwo.isHidden = true
				self.accentColor = UIColor(named: "mainColor")!
				self.mainColor = .white
			case .period:
				self.descriptionText.text = "Period is in progress"
				self.buttonOne.setTitle("Period ended early", for: .normal)
				self.buttonTwo.setTitle("Didn't start", for: .normal)
				self.accentColor = .white
				self.buttonTwo.isHidden = false
				self.mainColor = UIColor(named: "mainColor")!
			case .delay:
				self.descriptionText.text = "You have a delay"
				self.buttonOne.setTitle("Have started!!", for: .normal)
				self.buttonTwo.isHidden = true
				self.accentColor = UIColor(named: "mainColor")!
				self.mainColor = .white
			case .startDay:
				self.descriptionText.text = "Period started?"
				self.buttonOne.setTitle("Yes", for: .normal)
				self.buttonTwo.setTitle("No", for: .normal)
				self.buttonTwo.isHidden = false
				self.accentColor = .white
				self.mainColor = UIColor(named: "mainColor")!
		}
	}

	private func setupConstraints() {
		NSLayoutConstraint.activate([
			self.shape.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			self.shape.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
			self.shape.widthAnchor.constraint(equalToConstant: 240),
			self.shape.heightAnchor.constraint(equalToConstant: 320),

			self.nextPeriodDate.centerXAnchor.constraint(equalTo: self.shape.centerXAnchor),
			self.nextPeriodDate.centerYAnchor.constraint(equalTo: self.shape.centerYAnchor, constant: 30),

			self.nextPeriodMonthAndWeek.topAnchor.constraint(equalTo: self.nextPeriodDate.bottomAnchor, constant: -20),
			self.nextPeriodMonthAndWeek.centerXAnchor.constraint(equalTo: self.nextPeriodDate.centerXAnchor),

			self.descriptionText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.descriptionText.topAnchor.constraint(equalTo: self.shape.bottomAnchor, constant: 30),

			self.buttonOne.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.buttonOne.topAnchor.constraint(equalTo: self.descriptionText.bottomAnchor, constant: 30),
			self.buttonOne.widthAnchor.constraint(equalToConstant: 240),
			self.buttonOne.heightAnchor.constraint(equalToConstant: 56),

			self.buttonTwo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.buttonTwo.topAnchor.constraint(equalTo: self.buttonOne.bottomAnchor, constant: 16),
			self.buttonTwo.widthAnchor.constraint(equalToConstant: 240),
			self.buttonTwo.heightAnchor.constraint(equalToConstant: 56)
			])
	}

	private func setupViews() {
		view.backgroundColor = .white
		view.frame = UIScreen.main.bounds
		view.addSubview(self.shape)
		view.addSubview(self.nextPeriodDate)
		view.addSubview(self.nextPeriodMonthAndWeek)
		view.addSubview(self.descriptionText)
		view.addSubview(self.buttonOne)
		view.addSubview(self.buttonTwo)
	}

	private func setupNavigationBar() {
		let navigationRightItem = UIImage(systemName: "gearshape")

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: navigationRightItem,
			style: .plain,
			target: self,
			action: #selector(action)
		)
		navigationItem.rightBarButtonItem?.tintColor = self.accentColor
	}

	@objc func action() {
		self.coordinator?.openSettings()
	}

	@objc func buttonOneAction() {
		guard let partOfCycle = self.calendarModel?.partOfCycle  else { return }
		switch partOfCycle {
			case .offPeriod:
				self.calendarModel?.partOfCycle = .period
				self.calendarModel?.date = Date()
			case .period:
				self.calendarModel?.partOfCycle = .offPeriod
			case .delay:
				self.calendarModel?.partOfCycle = .period
				self.calendarModel?.date = Date()
				UserProfileService.shared.setDelay(false)
				// add alert
			case .startDay:
				self.calendarModel?.partOfCycle = .period
				self.calendarModel?.date = Date()
		}
		self.setupContent()
		self.view.layoutSubviews()
	}

	@objc func buttonTwoAction() {
		guard let partOfCycle = self.calendarModel?.partOfCycle  else { return }
		switch partOfCycle {
			case .offPeriod, .delay:
				return
			case .startDay, .period:
				UserProfileService.shared.setDelay(true)
				self.calendarModel?.partOfCycle = .delay
		}
		self.setupContent()
		self.view.layoutIfNeeded()
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
							self.calculateData(
								for: lastPeriodDate,
								cycle: Int(date[0].cycleLength),
								period: Int(date[0].periodLength)
							)
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
