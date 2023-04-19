import UIKit


class CustomCheerMeterWidgetView: UIView {
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()

    private let powerBar: CheerMeterPowerBar = CheerMeterPowerBar()

    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var leftChoiceText: String {
        get { return powerBar.leftChoiceText }
        set { powerBar.leftChoiceText = newValue }
    }

    var rightChoiceText: String {
        get { return powerBar.rightChoiceText }
        set { powerBar.rightChoiceText = newValue }
    }

    var leftChoiceScore: Int {
        get { return powerBar.leftScore }
        set { powerBar.leftScore = newValue }
    }

    var rightChoiceScore: Int {
        get { return powerBar.rightScore }
        set { powerBar.rightScore = newValue }
    }

    func showScores() {
        powerBar.shouldUpdateWidths = true
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        // label.font = UIFont(name: "VerizonNHGeTX-Bold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bodyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let versusAnimationView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        // label.font = UIFont(name: "VerizonNHGeTX-Bold", size: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "vs"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let optionViewA: CustomCheerMeterWidgetOptionView = {
        let optionView = CustomCheerMeterWidgetOptionView()
        optionView.translatesAutoresizingMaskIntoConstraints = false
        return optionView
    }()


    let optionViewB: CustomCheerMeterWidgetOptionView = {
        let optionView = CustomCheerMeterWidgetOptionView()
        optionView.translatesAutoresizingMaskIntoConstraints = false
        return optionView
    }()


    init() {
        super.init(frame: .zero)

        self.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        self.layer.cornerRadius = 8

        addSubview(stackView)
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(powerBar)
        stackView.addArrangedSubview(bodyView)

        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70).isActive = true


        headerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 32).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true

        bodyView.addSubview(optionViewA)
        optionViewA.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 16).isActive = true
        optionViewA.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 0).isActive = true
        optionViewA.heightAnchor.constraint(equalToConstant: 125).isActive = true
        optionViewA.widthAnchor.constraint(equalToConstant: 125).isActive = true
        optionViewA.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor).isActive = true


        bodyView.addSubview(optionViewB)
        optionViewB.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 16).isActive = true
        optionViewB.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: 0).isActive = true
        optionViewB.heightAnchor.constraint(equalToConstant: 125).isActive = true
        optionViewB.widthAnchor.constraint(equalToConstant: 125).isActive = true
        optionViewB.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor).isActive = true


        bodyView.addSubview(versusAnimationView)
        versusAnimationView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 16).isActive = true
        versusAnimationView.bottomAnchor.constraint(equalTo: optionViewA.bottomAnchor).isActive = true
        versusAnimationView.leadingAnchor.constraint(equalTo: optionViewA.trailingAnchor, constant: 5).isActive = true
        versusAnimationView.trailingAnchor.constraint(equalTo: optionViewB.leadingAnchor, constant: -5).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hidePowerBar(){
        self.powerBar.isHidden = true
    }
    
    func showPowerBar(){
        self.powerBar.isHidden = false
    }
}

class CustomCheerMeterWidgetOptionView: UIView {
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        // label.font = UIFont(name: "VerizonNHGeTX-Bold", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()



    init() {
        super.init(frame: .zero)

        layer.cornerRadius = 4
        //layer.borderColor = UIColor(red: 230, green: 230, blue: 230, alpha: ).cgColor
        layer.borderWidth = 2
        clipsToBounds = true

        button.layer.borderWidth = 2
        addSubview(imageView)
        addSubview(optionLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 2),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -2),
            imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -56),
            //imageView.heightAnchor.constraint(equalToConstant: 48),

            optionLabel.heightAnchor.constraint(equalToConstant: 16),
            optionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            optionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 2),
            optionLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -2)

        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

