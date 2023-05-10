//
//  CheerMeterPowerBar.swift
//  EngagementSDK
//
//  Created by Jelzon Monzon on 6/26/19.
//

import UIKit


class CheerMeterPowerBar: UIView {
    private let leftChoiceLabel: UILabel
    private let rightChoiceLabel: UILabel
    private let leftChoiceBar: GradientView
    private let rightChoiceBar: GradientView
    private let leftChoiceFlashView: UIView
    private let rightChoiceFlashView: UIView
    private var leftGradientWidthConstraint: NSLayoutConstraint!

  
    var leftChoiceText: String {
        get { return leftChoiceLabel.text ?? "" }
        set { leftChoiceLabel.text = newValue }
    }

    var rightChoiceText: String {
        get { return rightChoiceLabel.text ?? "" }
        set { rightChoiceLabel.text = newValue }
    }

    var leftScore: Int = 0 {
        didSet {
            updateWidthConstraint()
        }
    }

    var rightScore: Int = 0 {
        didSet {
            updateWidthConstraint()
        }
    }

    var shouldUpdateWidths: Bool = true

    init() {
        
        
        leftChoiceBar = constraintBased { GradientView(orientation: .horizontal, side: .left) }
        leftChoiceFlashView = constraintBased {
            let view = UIView(frame: .zero)
            view.backgroundColor = .white
            view.alpha = 0
            return view
        }

        leftChoiceLabel = constraintBased { UILabel(frame: .zero) }

        rightChoiceBar = constraintBased { GradientView(orientation: .horizontal, side: .right) }

        rightChoiceFlashView = constraintBased {
            let view = UIView(frame: .zero)
            view.backgroundColor = .white
            view.alpha = 0
            return view
        }

        rightChoiceLabel = constraintBased { UILabel(frame: .zero) }

        leftChoiceLabel.textColor = .white
        leftChoiceLabel.font = .systemFont(ofSize: 12, weight: .bold)
        // leftChoiceLabel.font = UIFont(name: "VerizonNHGeTX-Bold", size: 12)

        leftChoiceBar.livelike_startColor = .fill(color: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))
        leftChoiceBar.livelike_endColor = .fill(color: UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1))


        rightChoiceLabel.textColor = .white
        rightChoiceLabel.font = .systemFont(ofSize: 12, weight: .bold)
        // rightChoiceLabel.font = UIFont(name: "VerizonNHGeTX-Bold", size: 12)

        rightChoiceBar.livelike_startColor = .fill(color: UIColor(red: 0.933, green: 0, blue: 0, alpha: 1))
        rightChoiceBar.livelike_endColor = .fill(color: UIColor(red: 0.933, green: 0, blue: 0, alpha: 1))

        super.init(frame: .zero)

        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        updateWidthConstraint()
    }

    private func updateWidthConstraint() {
        let totalScore: Int = leftScore + rightScore
        guard shouldUpdateWidths, totalScore > 0 else {
            leftGradientWidthConstraint.constant = bounds.width * 0.5
            return
        }

        leftGradientWidthConstraint.constant = bounds.width * (CGFloat(leftScore) / CGFloat(totalScore))
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        })
    }

    private func configureLayout() {
        addSubview(leftChoiceBar)
        addSubview(leftChoiceLabel)
        addSubview(rightChoiceBar)
        addSubview(rightChoiceLabel)

        leftGradientWidthConstraint = leftChoiceBar.widthAnchor.constraint(equalToConstant: bounds.width * 0.5)
        NSLayoutConstraint.activate([
            rightChoiceBar.leadingAnchor.constraint(equalTo: leftChoiceBar.trailingAnchor),
            rightChoiceBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightChoiceBar.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            rightChoiceBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightChoiceBar.heightAnchor.constraint(equalToConstant: 24),

            leftGradientWidthConstraint,
            leftChoiceBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftChoiceBar.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            leftChoiceBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftChoiceBar.heightAnchor.constraint(equalToConstant: 24),

            leftChoiceLabel.centerXAnchor.constraint(equalTo: leftChoiceBar.centerXAnchor),
            leftChoiceLabel.centerYAnchor.constraint(equalTo: leftChoiceBar.centerYAnchor),
            leftChoiceLabel.widthAnchor.constraint(lessThanOrEqualTo: leftChoiceBar.widthAnchor),
            // leftChoiceLabel.heightAnchor.constraint(equalTo: leftChoiceBar.heightAnchor),
            leftChoiceLabel.heightAnchor.constraint(equalToConstant: 16),

            rightChoiceLabel.centerXAnchor.constraint(equalTo: rightChoiceBar.centerXAnchor),
            rightChoiceLabel.centerYAnchor.constraint(equalTo: rightChoiceBar.centerYAnchor),
            rightChoiceLabel.widthAnchor.constraint(lessThanOrEqualTo: rightChoiceBar.widthAnchor),
            // rightChoiceLabel.heightAnchor.constraint(equalTo: rightChoiceBar.heightAnchor)
            rightChoiceLabel.heightAnchor.constraint(equalToConstant: 16),

        ])

        leftChoiceBar.addSubview(leftChoiceFlashView)
        rightChoiceBar.addSubview(rightChoiceFlashView)

        leftChoiceFlashView.constraintsFill(to: leftChoiceBar)
        rightChoiceFlashView.constraintsFill(to: rightChoiceBar)

        self.layer.cornerRadius = 4
    }
}

extension UIView {
    func constraintsFill(to parentView: UIView, offset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            parentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset),
            parentView.topAnchor.constraint(equalTo: topAnchor, constant: -offset),
            parentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offset),
            parentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -offset)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func fillConstraints(to view: UIView, offset: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset),
            view.topAnchor.constraint(equalTo: topAnchor, constant: -offset),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offset),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -offset)
        ]
    }
}


// MARK: Animations

extension CheerMeterPowerBar {
    enum Side {
        case left
        case right
    }

    func flashLeft() {
        flash(view: leftChoiceFlashView)
    }

    func flashRight() {
        flash(view: rightChoiceFlashView)
    }

    private func flash(view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 0.05, animations: {
            view.alpha = 1
        }, completion: { complete in
            if complete {
                UIView.animate(withDuration: 0.05, animations: {
                    view.alpha = 0
                })
            }
        })
    }
}

func constraintBased<View>(factory: () -> View) -> View where View: UIView {
    let view = factory()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}
