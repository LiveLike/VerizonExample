//
//  ChoiceWidgetOption.swift
//  EngagementSDK
//
//  Created by Jelzon Monzon on 7/18/19.
//

import UIKit

typealias ChoiceWidgetOptionButton = UIView & ChoiceWidgetOption

protocol ChoiceWidgetOptionDelegate: AnyObject {
    func wasSelected(_ option: ChoiceWidgetOption)
    func wasDeselected(_ option: ChoiceWidgetOption)
}

protocol ChoiceWidgetOption: AnyObject {
    init(id: String)
    var id: String { get }
    var delegate: ChoiceWidgetOptionDelegate? { get set }
    var borderColor: UIColor { get set }
    func setImage(_ imageURL: URL)
    var text: String? { get set }
    var image: UIImage? { get set }
    func setProgress(_ percent: CGFloat)
    var borderWidth: CGFloat { get set }
    var descriptionFont: UIFont? { get set }
    var descriptionTextColor: UIColor? { get set }
    var percentageFont: UIFont? { get set }
    var percentageTextColor: UIColor? { get set }
    var isProgressLabelHidden: Bool { get set }
    var isProgressBarHidden: Bool { get set }
}

enum OptionThemeStyle {
    case selected
    case unselected
    case correct
    case incorrect
}


/// `ChoiceWidgetVote` represents the user's interaction with a particular choice widget providing details of the interacted option.
public struct ChoiceWidgetVote {
    /// String object representing the unique identifier of the option the user interacted with
    public let id: String
    /// String object representing the description of the option the user interacted with
    public var text: String?
    /// Image object representing the description of the option the user interacted with
    public var image: UIImage?

    public init(id: String, text: String? = nil, image: UIImage? = nil) {
        self.id = id
        self.text = text
        self.image = image
    }

    init(from choiceWidgetOption: ChoiceWidgetOption) {
        self.id = choiceWidgetOption.id
        self.text = choiceWidgetOption.text
        self.image = choiceWidgetOption.image
    }
}
