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
		button.setTitle("Yes", for: .normal)
		button.layer.cornerRadius = 8
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.fetchData()
		self.setupViews()
		self.setupNavigationBar()
	}

	private func calculateData(for date: Date, cycle: Int, period: Int) {
		let nextPeriodDate = DateCalculatiorService.shared.calculateDate(date, cycle: cycle)
		let state = DateCalculatiorService.shared.calculateState(nextPeriodDate, cycle: cycle, period: period)
		self.calendarModel = CalendarModel(nextPeriodDate: nextPeriodDate, partOfCycle: state)
		self.nextPeriodDate.text = DateCalculatiorService.shared.getDay(nextPeriodDate)
		self.nextPeriodMonth.text = DateCalculatiorService.shared.getMonth(nextPeriodDate)
		self.nextPeriodWeekday.text = DateCalculatiorService.shared.getWeekday(nextPeriodDate)
		switch state {
			case .offPeriod:
				self.descriptionText.text = "Next period"
				self.buttonOne.setTitle("Period started", for: .normal)
			case .period:
				self.descriptionText.text = "Period is in progress"
				self.buttonOne.setTitle("Period ended", for: .normal)
			case .delay:
				self.descriptionText.text = "Delay"
				self.buttonOne.setTitle("Have started!!", for: .normal)
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
