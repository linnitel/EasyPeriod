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

	private lazy var nextPeriodDateStart: UILabel = {
		let label = UILabel(frame: CGRect(x: self.view.bounds.minX + 16, y: self.view.bounds.midY - 100, width: self.view.bounds.width - 32, height: 200))
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupViews()
		self.setupNavigationBar()
	}

	private func setupViews() {
		view.backgroundColor = .white
		view.frame = UIScreen.main.bounds
		view.addSubview(self.nextPeriodDateStart)
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
