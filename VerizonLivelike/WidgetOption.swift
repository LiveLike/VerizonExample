//
//  WidgetOption.swift
//  EngagementSDK
//
//  Created by Mike Moloksher on 3/11/20.
//

import UIKit

/// WidgetOption is a class which represents an option a widget can have
public class WidgetOption: Hashable {
    public let id: String
    let voteURL: URL? = nil
    public let text: String?
    public let image: UIImage?
    public var imageUrl: URL?
    public let isCorrect: Bool?
    public var voteCount: Int?

    init(
        id: String,
        voteURL: URL?,
        text: String? = nil,
        image: UIImage? = nil,
        imageURL: URL? = nil,
        isCorrect: Bool? = nil,
        voteCount: Int? = nil
    ) {
        self.id = id
        self.text = text
        self.image = image
        self.imageUrl = imageURL
        self.isCorrect = isCorrect
        self.voteCount = voteCount
    }

    public static func == (lhs: WidgetOption, rhs: WidgetOption) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
