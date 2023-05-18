//
//  OffPeriodVC.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import UIKit

class OffPeriodVC: UIViewController {
	
	weak public var coordinator: AppCoordinator?
	let notifications = Notifications()

	private var datePersistance: [DateSettings] = []

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
		label.numberOfLines = 0
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
		self.setupContent()
	}

	private func setupContent() {

		guard let calendarModel = self.calendarModel else { return }
		self.nextPeriodDate.text = DateCalculatiorService.shared.getDay(calendarModel.showDate)
		self.nextPeriodMonthAndWeek.text = DateCalculatiorService.shared.getMonthAndWeek(calendarModel.showDate)
		switch calendarModel.partOfCycle {
			case .notSet:
				self.descriptionText.text = "Please setup your period schadule in settings"
				self.buttonTwo.isHidden = true
				self.buttonOne.isHidden = true
				self.accentColor = UIColor(named: "mainColor")!
				self.mainColor = .white
			case .offPeriod:
				self.descriptionText.text = "Next period"
				self.buttonOne.setTitle("Started", for: .normal)
				self.buttonOne.isHidden = false
				self.buttonTwo.isHidden = true
				self.accentColor = UIColor(named: "mainColor")!
				self.mainColor = .white
			case .period:
				self.descriptionText.text = "Period is in progress"
				self.buttonOne.setTitle("Period ended early", for: .normal)
				self.buttonTwo.setTitle("Didn't start", for: .normal)
				self.accentColor = .white
				self.buttonOne.isHidden = false
				self.buttonTwo.isHidden = false
				self.mainColor = UIColor(named: "mainColor")!
			case .delay:
				self.descriptionText.text = "You have a delay"
				self.buttonOne.setTitle("Have started!!", for: .normal)
				self.buttonTwo.isHidden = true
				self.buttonOne.isHidden = false
				self.accentColor = UIColor(named: "mainColor")!
				self.mainColor = .white
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
			self.descriptionText.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
			self.descriptionText.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
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
		guard var calendarModel = self.calendarModel  else { return }
		var nextDate: Date
		switch calendarModel.partOfCycle {
			case .notSet:
				return
			// period have started early
			case .offPeriod, .delay:
				calendarModel.partOfCycle = .period
				let newDate = Date()
				calendarModel.startDate = newDate
				nextDate = DateCalculatiorService.shared.getNextPriodDate(newDate, cycle: calendarModel.cycle)
			// period ended early
			case .period:
				calendarModel.partOfCycle = .offPeriod
				nextDate = DateCalculatiorService.shared.getNextPriodDate(calendarModel.startDate, cycle: calendarModel.cycle)
				calendarModel.startDate = nextDate
		}
		let timeInterval = DateCalculatiorService.shared.calculateTimeInterval(to: nextDate)
		self.notifications.scheduleNotification(for: timeInterval)
		self.calendarModel = calendarModel
		UserProfileService.shared.setSettings(calendarModel)
		self.setupContent()
	}

	@objc func buttonTwoAction() {
		guard var calendarModel = self.calendarModel  else { return }
		switch calendarModel.partOfCycle {
			case .notSet, .offPeriod, .delay:
				return
			case .period:
				calendarModel.partOfCycle = .delay
		}
		self.calendarModel = calendarModel
		UserProfileService.shared.setSettings(calendarModel)
		self.setupContent()
		self.view.layoutIfNeeded()
	}

	// MARK: UserDefalts Interactions
	private func fetchData() {
		var calendarModel = UserProfileService.shared.getSettings()
		print(calendarModel)
		guard calendarModel.partOfCycle != .notSet else {
			self.calendarModel = calendarModel
			return
		}

		let periodStartDate = DateCalculatiorService.shared.calculateStartDate(calendarModel.startDate, cycle: calendarModel.cycle, period: calendarModel.period)
		let periodEndDate = DateCalculatiorService.shared.calculateEndDate(periodStartDate, period: calendarModel.period)
		if calendarModel.partOfCycle != .delay {
			let isPeriodCheck = DateCalculatiorService.shared.isPeriod(startDate: periodStartDate, endDate: periodEndDate)
			if isPeriodCheck {
				calendarModel.partOfCycle = .period
			} else {
				calendarModel.partOfCycle = .offPeriod
			}
		}
		self.calendarModel = calendarModel
		UserProfileService.shared.setSettings(calendarModel)
	}

	// MARK: Alerts
	private func startPeriodAlert(title: String, message: String, completion: @escaping () -> Void) {
		// Create Alert
		let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
		// Create OK button with action handler
		let ok = UIAlertAction(title: "OK", style: .destructive, handler: { (action) -> Void in
			completion()
		})
		// Create Cancel button with action handlder
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
		}
		ok.setValue(UIColor(named: "mainColor"), forKey: "titleTextColor")
		cancel.setValue(UIColor(named: "mainColor"), forKey: "titleTextColor")
		//Add OK and Cancel button to an Alert object
		dialogMessage.addAction(ok)
		dialogMessage.addAction(cancel)
		// Present alert message to user
		self.present(dialogMessage, animated: true, completion: nil)
	}
}
