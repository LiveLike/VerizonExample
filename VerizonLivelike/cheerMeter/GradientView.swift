import UIKit

final class GradientView: UIView {

    enum Orientation {
        case horizontal
        case vertical
    }

    var livelike_startColor: Background = .fill(color: .clear) {
        didSet {
            updateGradient()
        }
    }

    var livelike_endColor: Background = .fill(color: .red) {
        didSet {
            updateGradient()
        }
    }

    private var orientation: Orientation = .vertical
    private var gradientLayer: CAGradientLayer?

    init(orientation: Orientation = .vertical) {
        self.orientation = orientation
        super.init(frame: .zero)
        gradientLayer = layer as? CAGradientLayer
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer = layer as? CAGradientLayer
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gradientLayer = layer as? CAGradientLayer
        configure()
    }

    private func configure() {
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        updateOrientation()
    }

    override class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0) {
        didSet {
            updateGradient()
        }
    }

    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0) {
        didSet {
            updateGradient()
        }
    }

//    var livelike_cornerRadius: CGFloat {
//        didSet {
//            gradientLayer?.cornerRadius = livelike_cornerRadius
//        }
//    }

    private func updateGradient() {
        var colors: [UIColor] = []

        switch livelike_startColor {
        case .fill(let color):
            colors.append(color)
        case .gradient(let gradient):
            colors.append(contentsOf: gradient.colors)
        }

        switch livelike_endColor {
        case .fill(let color):
            colors.append(color)
        case .gradient(let gradient):
            colors.append(contentsOf: gradient.colors)
        }

        gradientLayer?.colors = colors.map { $0.cgColor }
        gradientLayer?.startPoint = startPoint
        gradientLayer?.endPoint = endPoint
    }

    private func updateOrientation() {
        switch orientation {
        case .vertical:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
        case .horizontal:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
        }
    }
}

public enum Background {
    // swiftlint:disable nesting
    public struct Gradient {
        public var colors: [UIColor]
        public var start: CGPoint
        public var end: CGPoint

        public init(colors: [UIColor]) {
            self.colors = colors
            start = CGPoint(x: 0, y: 0.5)
            end = CGPoint(x: 1, y: 0.5)
        }

        public init(colors: [UIColor], start: CGPoint, end: CGPoint) {
            self.colors = colors
            self.start = start
            self.end = end
        }
    }

    case gradient(gradient: Gradient)
    case fill(color: UIColor)
}
