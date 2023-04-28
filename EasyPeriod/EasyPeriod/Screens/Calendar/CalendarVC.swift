//
//  CalendarVC.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import Foundation
import UIKit

class CalendarVC: UIViewController {
	
	weak public var coordinator: AppCoordinator?

	private var datePersistance: [DateSettings] = []
	private var delay: Bool {
		UserProfileService.shared.getDelay()
	}
	private var calendarModel: CalendarModel?

	private lazy var nextPeriodDate: UILabel = {
		let label = UILabel(frame: CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.midY - 200, width: self.view.bounds.width - 32, height: 200))
		label.font = .systemFont(ofSize: 150)
		label.backgroundColor = .orange
		label.textAlignment = .center
		return label
	}()

	private lazy var nextPeriodMonth: UILabel = {
		let label = UILabel(frame: CGRect(x: self.view.bounds.minX + 16, y: self.nextPeriodDate.frame.maxY + 12, width: (self.view.bounds.width - 36) / 2, height: 50))
		label.backgroundColor = .blue
		label.textAlignment = .right
		return label
	}()

	private lazy var nextPeriodWeekday: UILabel = {
		let label = UILabel(frame: CGRect(x: self.nextPeriodMonth.frame.maxX + 8, y: self.nextPeriodMonth.frame.minY, width: (self.view.bounds.width - 36) / 2, height: 50))
		label.backgroundColor = .systemPink
		return label
	}()

	private lazy var descriptionText: UILabel = {
		let label = UILabel(frame: CGRect(x: self.view.bounds.minX + 16, y: self.nextPeriodMonth.frame.maxY + 12, width: self.view.bounds.width - 32, height: 50))
		label.backgroundColor = .systemPink
		label.textAlignment = .center
		return label
	}()

	private lazy var buttonOne: UIButton = {
		let button = UIButton(frame: CGRect(x: self.view.bounds.midX - 70, y: self.descriptionText.frame.maxY + 12, width: 140, height: 50))
		button.backgroundColor = UIColor(cgColor: CGColor(red: 256, green: 0, blue: 25, alpha: 100))
		button.layer.cornerRadius = 8
		button.addTarget(self, action: #selector(self.buttonOneAction), for: .touchUpInside)
		return button
	}()

	private lazy var buttonTwo: UIButton = {
		let button = UIButton(frame: CGRect(x: self.view.bounds.midX - 70, y: self.buttonOne.frame.maxY + 12, width: 140, height: 50))
		button.backgroundColor = UIColor(cgColor: CGColor(red: 256, green: 0, blue: 25, alpha: 100))
		button.layer.cornerRadius = 8
		button.addTarget(self, action: #selector(self.buttonTwoAction), for: .touchUpInside)
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupViews()
		self.setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		self.fetchData()
	}

	private func calculateData(for date: Date, cycle: Int, period: Int) {
		let nextPeriodDate = DateCalculatiorService.shared.calculateDate(date, cycle: cycle, period: period, delay: delay)
		let partOfCycle = DateCalculatiorService.shared.calculateState(nextPeriodDate, cycle: cycle, period: period, delay: delay)
		self.calendarModel = CalendarModel(nextPeriodDate: nextPeriodDate, partOfCycle: partOfCycle)
		setupContent()
	}

	private func setupContent() {
		guard let calendarModel = self.calendarModel else { return }
		self.nextPeriodDate.text = DateCalculatiorService.shared.getDay(calendarModel.nextPeriodDate)
		self.nextPeriodMonth.text = DateCalculatiorService.shared.getMonth(calendarModel.nextPeriodDate)
		self.nextPeriodWeekday.text = DateCalculatiorService.shared.getWeekday(calendarModel.nextPeriodDate)
		switch calendarModel.partOfCycle {
			case .offPeriod:
				self.descriptionText.text = "Next period"
				self.buttonOne.setTitle("Started", for: .normal)
				self.buttonTwo.isHidden = true
			case .period:
				self.descriptionText.text = "Period is in progress"
				self.buttonOne.setTitle("Period ended early", for: .normal)
				self.buttonTwo.setTitle("Didn't start", for: .normal)
			case .delay:
				self.descriptionText.text = "You have a delay"
				self.buttonOne.setTitle("Have started!!", for: .normal)
				self.buttonTwo.isHidden = true
			case .startDay:
				self.descriptionText.text = "Period started?"
				self.buttonOne.setTitle("Yes", for: .normal)
				self.buttonTwo.setTitle("No", for: .normal)
		}
	}

	private func setupViews() {
		view.backgroundColor = .white
		view.frame = UIScreen.main.bounds
		view.addSubview(self.nextPeriodDate)
		view.addSubview(self.nextPeriodMonth)
		view.addSubview(self.nextPeriodWeekday)
		view.addSubview(self.descriptionText)
		view.addSubview(self.buttonOne)
		view.addSubview(self.buttonTwo)
	}

	private func setupNavigationBar() {
		let navigationRightItem = UIImage(systemName: "gearshape.fill")

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: navigationRightItem,
			style: .plain,
			target: self,
			action: #selector(action)
		)
		navigationItem.rightBarButtonItem?.tintColor = UIColor(
			cgColor:  CGColor(red: 256, green: 0, blue: 25, alpha: 100)
		)
	}

	@objc func action() {
		self.coordinator?.openSettings()
	}

	@objc func buttonOneAction() {
		guard let partOfCycle = self.calendarModel?.partOfCycle  else { return }
		switch partOfCycle {
			case .offPeriod:
				self.calendarModel?.partOfCycle = .period
				self.calendarModel?.nextPeriodDate = Date()
			case .period:
				self.calendarModel?.partOfCycle = .offPeriod
			case .delay:
				self.calendarModel?.partOfCycle = .period
				self.calendarModel?.nextPeriodDate = Date()
				UserProfileService.shared.setDelay(false)
				// add alert
			case .startDay:
				self.calendarModel?.partOfCycle = .period
				self.calendarModel?.nextPeriodDate = Date()
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
}
