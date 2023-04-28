//
//  DropDownView.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 25/04/2023.
//

import UIKit

class DropDownView: UIView {

	var order: Order = .middle {
		didSet {
			self.layoutSubviews()
		}
	}

	var isOpen: Bool = false {
		didSet {
			self.layoutSubviews()
		}
	}

	lazy var labelTitle: UILabel = {
		let label = UILabel()
		label.font = label.font.withSize(17)
		return label
	}()

	lazy var valueLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .right
		label.textColor = UIColor(named: "mainColor")
		label.font = label.font.withSize(17)
		return label
	}()

	lazy var picker: UIPickerView = {
		let picker = UIPickerView()
		picker.backgroundColor = .white
		return picker
	}()

	@available(*, unavailable, message:"init is unavailable")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

//		self.clipsToBounds = true
		self.addSubview(labelTitle)
		self.addSubview(valueLabel)
		self.addSubview(picker)
	}

	// MARK: Overrides
	override func layoutSubviews() {
		super.layoutSubviews()

		self.backgroundColor = self.isOpen ? UIColor(named:  "lightSelectorColor") : .white
		switch order {
			case .isFirst:
				self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
				self.layer.cornerRadius = 8
			case .middle:
				break
			case .isLast:
				self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
				self.layer.cornerRadius = 8
		}
		if isOpen {
			print("view is open")
		}

		self.labelTitle.frame = CGRect(
			x: self.bounds.minX + 16,
			y: self.bounds.minY,
			width: (self.bounds.width - 36) / 2,
			height: 50)

		self.valueLabel.frame = CGRect(
			x: self.labelTitle.frame.maxX + 8,
			y: self.bounds.minY,
			width: (self.bounds.width - 36) / 2,
			height: 50)

		self.picker.frame = CGRect(
			x: self.bounds.minX,
			y: self.labelTitle.frame.maxX + 12,
			width: self.bounds.width - 32,
			height: 150)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.isOpen.toggle()
		self.picker.isHidden.toggle()
	}

	enum Order {
		case isFirst
		case middle
		case isLast
	}
}
