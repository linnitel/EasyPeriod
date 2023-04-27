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

	private lazy var buttonTwo: UIButton = {
		let button = UIButton(frame: CGRect(x: self.view.bounds.midX - 70, y: self.buttonOne.frame.maxY + 12, width: 140, height: 50))
		button.backgroundColor = UIColor(cgColor: CGColor(red: 256, green: 0, blue: 25, alpha: 100))
		button.setTitle("No", for: .normal)
		button.layer.cornerRadius = 8
		return button
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.getData()
		self.setupViews()
		self.setupNavigationBar()
	}

	private func getData() {
		self.calendarModel = CalendarModel(nextPeriodDate: Date(), partOfCycle: .period)
		self.nextPeriodDate.text = "28"
		self.nextPeriodMonth.text = "april"
		self.nextPeriodWeekday.text = "wed"
		self.descriptionText.text = "Periods started?"
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
}
