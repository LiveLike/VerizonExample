//
//  WidgetViewModel.swift
//  
//
//  Created by Jelzon Monzon on 11/10/22.
//

import UIKit
import LiveLikeSwift

public protocol WidgetViewModel: AnyObject {
    var id: String { get }
    var kind: WidgetKind { get }
    var widgetTitle: String? { get }
    var widgetModel: WidgetModel? { get }

    /// The date and time the widget has been created
    var createdAt: Date { get }

    /// The date and time the widget has been published from the Producer Suite
    var publishedAt: Date? { get }

    /// The time interval for which the user is able to interact with the widget
    var interactionTimeInterval: TimeInterval? { get }

    /// A set of widget options if it has any.
    /// Some widgets like alert widgets do not have any options to display.
    var options: Set<WidgetOption>? { get }

    var customData: String? { get }
    var previousState: WidgetState? { get set }
    var currentState: WidgetState { get set }
    var delegate: WidgetViewDelegate? { get set }

    /// Has the user interacted with the widget
    var userDidInteract: Bool { get }

    var dismissSwipeableView: UIView { get }
    var theme: Theme { get set }

    func moveToNextState()
    func addCloseButton(_ completion: @escaping (WidgetViewModel) -> Void)
    func addTimer(seconds: TimeInterval, completion: @escaping (WidgetViewModel) -> Void)
    func cancelTimer()
}
