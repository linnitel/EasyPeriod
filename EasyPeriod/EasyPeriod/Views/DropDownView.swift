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

	private var bottomConstraint: NSLayoutConstraint?
	private var pickerTopConstraints: NSLayoutConstraint?
	private var pickerBottomConstraints: NSLayoutConstraint?
	private var pickerLeadingConstraints: NSLayoutConstraint?
	private var pickerTrailingConstraints: NSLayoutConstraint?


	lazy var labelTitle: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = label.font.withSize(17)
		return label
	}()

	lazy var valueLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .right
		label.textColor = UIColor(named: "mainColor")
		label.font = label.font.withSize(17)
		return label
	}()

	lazy var picker: UIPickerView = {
		let picker = UIPickerView()
		picker.translatesAutoresizingMaskIntoConstraints = false
		picker.backgroundColor = .white
		return picker
	}()

	@available(*, unavailable, message:"init is unavailable")
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

		self.addSubview(labelTitle)
		self.addSubview(valueLabel)
		self.addSubview(picker)

		self.bottomConstraint = self.valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
		self.pickerTopConstraints = self.picker.topAnchor.constraint(equalTo: self.labelTitle.bottomAnchor, constant: 12)
		self.pickerBottomConstraints = self.picker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		self.pickerLeadingConstraints = self.picker.leadingAnchor.constraint(equalTo: self.leadingAnchor)
		self.pickerTrailingConstraints = self.picker.trailingAnchor.constraint(equalTo: self.trailingAnchor)

		NSLayoutConstraint.activate([
			self.labelTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
			self.labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

			self.valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
			self.valueLabel.leadingAnchor.constraint(equalTo: self.labelTitle.trailingAnchor, constant: 8),
			self.valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

			self.bottomConstraint!,
			])
	}

	// MARK: Overrides
	override func layoutSubviews() {
		super.layoutSubviews()

		if isOpen {
			self.backgroundColor = UIColor(named:  "lightSelectorColor")
			self.picker.isHidden = false
			self.bottomConstraint?.isActive = false
			self.pickerTopConstraints?.isActive = true
			self.pickerBottomConstraints?.isActive = true
			self.pickerLeadingConstraints?.isActive = true
			self.pickerTrailingConstraints?.isActive = true
		} else {
			self.backgroundColor = .white
			self.picker.isHidden = true
			self.bottomConstraint?.isActive = true
			self.pickerTopConstraints?.isActive = false
			self.pickerBottomConstraints?.isActive = false
			self.pickerLeadingConstraints?.isActive = false
			self.pickerTrailingConstraints?.isActive = false
		}

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
