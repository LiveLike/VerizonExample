//
//  InteractiveWidgetTimelineViewDelegate.swift
//  EngagementSDK
//
//  Created by Jelzon Monzon on 5/18/21.
//

import Foundation
import LiveLikeSwift

/// A Widget state controller based on a common interactive timeline use-case
final public class InteractiveTimelineWidgetViewDelegate: WidgetViewDelegate {
    public init() {}

    public func widgetDidEnterState(widget: WidgetViewModel, state: WidgetState) {
        // Skip interacting state if widget interactivity has expired
        if
            let interactiveUntil = widget.widgetModel?.interactiveUntil,
            state == .interacting,
            interactiveUntil < Date()
        {
            widget.moveToNextState()
        }

        switch (state, widget.widgetModel) {
        case (.interacting, .poll(let model)):
            let canSubmitVote = model.mostRecentVote == nil || model.mostRecentVote?.canBeUpdated ?? true
            if !canSubmitVote {
                widget.moveToNextState()
            }
        case (.interacting, .prediction(let model)):
            let canSubmitVote = model.mostRecentVote == nil || model.mostRecentVote?.canBeUpdated ?? true
            if !canSubmitVote || model.isFollowUpPublished {
                widget.moveToNextState()
            }
        default:
            break
        }
    }

    public func widgetStateCanComplete(widget: WidgetViewModel, state: WidgetState) {
        switch state {
        case .ready:
            break
        case .interacting:
            if widget.kind.isOf(.textQuiz, .imageQuiz, .imageSlider) {
                widget.moveToNextState()
            }
        case .results:
            widget.moveToNextState()
        case .finished:
            break
        }
    }

    public func userDidInteract(_ widget: WidgetViewModel) { }

    public func userDidSubmitVote(_ widget: WidgetViewModel, selectedVote: ChoiceWidgetVote) { }
}
