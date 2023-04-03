//
//  WidgetView.swift
//  LiveLikeSDK
//
//  Created by Cory Sullivan on 2019-01-31.
//

import UIKit
import LiveLikeSwift

open class Widget: UIViewController, WidgetViewModel {

    // MARK: Public Properties

    public let id: String
    public let kind: WidgetKind
    public let widgetTitle: String?
    public let createdAt: Date
    public let publishedAt: Date?
    public let interactionTimeInterval: TimeInterval?
    public let options: Set<WidgetOption>?
    public let customData: String?
    public let widgetModel: WidgetModel?

    open var previousState: WidgetState?
    open var currentState: WidgetState
    open weak var delegate: WidgetViewDelegate?
    open var userDidInteract: Bool
    open var dismissSwipeableView: UIView {
        return view
    }

    // MARK: Internal Properties

    let widgetLink: URL?
    let optionsArray: [WidgetOption]?
    var interactionCount: Int = 0
    var timeOfLastInteraction: Date?
    var interactableState: InteractableState = .closedToInteraction
    private var interactivityExpirationTimer: Timer?

    public init() {
        self.id = ""
        self.kind = .alert
        self.widgetTitle = nil
        self.createdAt = Date()
        self.publishedAt = nil
        self.interactionTimeInterval = nil
        self.optionsArray = []
        self.options = Set()
        self.customData = nil
        self.previousState = nil
        self.currentState = .ready
        self.userDidInteract = false
        self.widgetLink = nil
        self.widgetModel = nil
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        interactivityExpirationTimer?.invalidate()
        interactivityExpirationTimer = nil
    }

    init(
        id: String,
        kind: WidgetKind,
        widgetTitle: String?,
        createdAt: Date,
        publishedAt: Date?,
        interactionTimeInterval: TimeInterval?,
        options: [WidgetOption]
    ) {
        self.id = id
        self.kind = kind
        self.widgetTitle = widgetTitle
        self.createdAt = createdAt
        self.publishedAt = publishedAt
        self.interactionTimeInterval = interactionTimeInterval
        self.optionsArray = options
        self.options = Set(options)
        self.customData = nil
        self.previousState = nil
        self.currentState = .ready
        self.userDidInteract = false
        self.widgetLink = nil
        self.widgetModel = nil
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: CheerMeterWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.title
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        let opts = model.options.map {
            WidgetOption(
                id: $0.id,
                voteURL: nil,
                text: $0.text,
                image: nil,
                voteCount: $0.voteCount
            )
        }
        self.optionsArray = opts
        self.options = Set(opts)
        self.customData = nil
        self.widgetLink = nil
        self.widgetModel = .cheerMeter(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: AlertWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.title
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        self.optionsArray = nil
        self.options = nil
        self.customData = model.customData
        self.widgetLink = model.linkURL
        self.widgetModel = .alert(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: VideoAlertWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.title
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        self.optionsArray = nil
        self.options = nil
        self.customData = model.customData
        self.widgetLink = model.linkURL
        self.widgetModel = .videoAlert(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: QuizWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.question
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        let opts = model.choices.map {
            return WidgetOption(
                id: $0.id,
                voteURL: nil,
                text: $0.text,
                image: nil,
                imageURL: $0.imageURL,
                isCorrect: $0.isCorrect,
                voteCount: $0.answerCount
            )
        }
        self.optionsArray = opts
        self.options = Set(opts)
        self.customData = model.customData
        self.widgetLink = nil
        self.widgetModel = .quiz(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: PredictionWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.question
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        let opts = model.options.map {
            return WidgetOption(
                id: $0.id,
                voteURL: nil,
                text: $0.text,
                image: nil,
                imageURL: $0.imageURL,
                isCorrect: nil,
                voteCount: $0.voteCount
            )
        }
        self.optionsArray = opts
        self.options = Set(opts)
        self.customData = model.customData
        self.widgetLink = nil
        self.widgetModel = .prediction(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: PredictionFollowUpWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.question
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        let opts = model.options.map {
            return WidgetOption(
                id: $0.id,
                voteURL: nil,
                text: $0.text,
                image: nil,
                imageURL: $0.imageURL,
                isCorrect: nil,
                voteCount: $0.voteCount
            )
        }
        self.optionsArray = opts
        self.options = Set(opts)
        self.customData = model.customData
        self.widgetLink = nil
        self.widgetModel = .predictionFollowUp(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: PollWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.question
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        let opts = model.options.map {
            return WidgetOption(
                id: $0.id,
                voteURL: nil,
                text: $0.text,
                image: nil,
                imageURL: $0.imageURL,
                voteCount: $0.voteCount
            )
        }
        self.optionsArray = opts
        self.options = Set(opts)
        self.customData = model.customData
        self.widgetLink = nil
        self.widgetModel = .poll(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: ImageSliderWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.question
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        let opts = model.options.map {
            return WidgetOption(
                id: $0.id,
                voteURL: nil,
                text: nil,
                image: nil,
                imageURL: $0.imageURL,
                voteCount: nil
            )
        }
        self.optionsArray = opts
        self.options = Set(opts)
        self.customData = model.customData
        self.widgetLink = nil
        self.widgetModel = .imageSlider(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: SocialEmbedWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.comment
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        self.optionsArray = nil
        self.options = nil
        self.customData = model.customData
        self.widgetLink = nil
        self.widgetModel = .socialEmbed(model)
        super.init(nibName: nil, bundle: nil)
    }

    public init(model: TextAskWidgetModel) {
        self.id = model.id
        self.kind = model.kind
        self.widgetTitle = model.title
        self.createdAt = model.createdAt
        self.publishedAt = model.publishedAt
        self.interactionTimeInterval = model.interactionTimeInterval
        self.currentState = .ready
        self.userDidInteract = false
        self.optionsArray = nil
        self.options = nil
        self.customData = model.customData
        self.widgetLink = nil
        self.widgetModel = .textAsk(model)
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func moveToNextState() { }
    open func addCloseButton(_ completion: @escaping (WidgetViewModel) -> Void) { }
    open func addTimer(seconds: TimeInterval, completion: @escaping (WidgetViewModel) -> Void) { }
    open func cancelTimer() { }

    func beginInteractiveUntilTimer(completion: @escaping () -> Void) {
        guard let interactivityTimeRemaining = self.widgetModel?.getSecondsUntilInteractivityExpiration() else {
            return
        }
        interactivityExpirationTimer = Timer.scheduledTimer(
            withTimeInterval: interactivityTimeRemaining,
            repeats: false
        ) { _ in
            completion()
        }
    }
}
