//
//  DropShapeView.swift
//  EasyPeriod
//
//  Created by Julia Martcenko on 04/05/2023.
//

import UIKit

class DropShapeView: UIView {
	var dropColor: UIColor = UIColor(named: "mainColor") ?? UIColor.systemPink {
		didSet {
			self.setNeedsLayout()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let path = UIBezierPath(
			arcCenter: CGPoint(x: bounds.midX, y: bounds.maxY * 2 / 3),
			radius: bounds.midX * 0.85,
			startAngle: 0,
			endAngle: .pi,
			clockwise: true)
		path.addCurve(
			to: CGPoint(x: bounds.midX, y: bounds.minY),
			controlPoint1: CGPoint(x: bounds.midX / 8, y: bounds.midY * 3 / 4),
			controlPoint2: CGPoint(x: bounds.midX, y: bounds.minY))
		path.addCurve(
			to: CGPoint(x: bounds.midX + bounds.midX * 0.85, y: bounds.midY * 2 / 3 + bounds.midX * 0.85),
			controlPoint1: CGPoint(x: bounds.midX + bounds.midX * 7 / 8, y: bounds.midY * 3 / 4),
			controlPoint2: CGPoint(x: bounds.midX + bounds.midX * 0.85, y: bounds.midY * 2 / 3 + bounds.midX * 0.85))
		path.close()
		path.fill()

		let shapeLayer = CAShapeLayer()
		shapeLayer.path = path.cgPath
		shapeLayer.fillColor = self.dropColor.cgColor
		self.layer.addSublayer(shapeLayer)
	}
}
