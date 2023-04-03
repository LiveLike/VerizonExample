//
//  ViewController.swift
//  VerizonLivelike
//
//  Created by Changdeo Jadhav on 03/04/23.
//

import UIKit
import LiveLikeSwift

class ViewController: UIViewController {
    
    var livelike: LiveLike? = nil
    private let  interactiveTimelineWidgetViewDelegate = InteractiveTimelineWidgetViewDelegate()
    private let widgetView: UIView = {
        let widgetView = UIView()
        widgetView.translatesAutoresizingMaskIntoConstraints = false
        return widgetView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(widgetView)
        
        NSLayoutConstraint.activate([
            widgetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            widgetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            widgetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        widgetView.backgroundColor = .red
        
        initSDK()
        loadCheerMeterWidget()
    }
    
    func initSDK(){
        let config = LiveLikeConfig(clientID: "8PqSNDgIVHnXuJuGte1HdvOjOqhCFE1ZCR3qhqaS")
        self.livelike = LiveLike(config: config)
    }
    
    func loadCheerMeterWidget(){
        self.livelike?.getWidgetModel(id: "9cceb48d-dfc0-44a6-96a4-ae5ab1f8dd88", kind: WidgetKind.cheerMeter){ [self] result in
            handleResult(result: result)
            
        }
    }
    
    func handleResult(result: Result<WidgetModel, Error>){
        switch result {
        case .failure(let error):
            print(error)
        case .success(let widgetModel):
            switch widgetModel {
            case let .cheerMeter(model):
                DispatchQueue.main.async { [weak self] in
                    if let self = self {
                        let viewController = CustomCheerMeterWidgetViewController(model: model)
                        self.addChild(viewController)
                        viewController.didMove(toParent: self)
                        viewController.view.translatesAutoresizingMaskIntoConstraints = false
                        self.view.addSubview(viewController.view)
                        
                        NSLayoutConstraint.activate([
                            viewController.view.topAnchor.constraint(equalTo: self.widgetView.topAnchor),
                            viewController.view.leadingAnchor.constraint(equalTo: self.widgetView.leadingAnchor),
                            viewController.view.trailingAnchor.constraint(equalTo: self.widgetView.trailingAnchor),
                            viewController.view.bottomAnchor.constraint(equalTo: self.widgetView.bottomAnchor, constant: 50)
                        ])
                        
                        
                        viewController.delegate = self.interactiveTimelineWidgetViewDelegate
                        viewController.moveToNextState()
                    }
                    
                }
            case .alert(_):
                break
            case .quiz(_):
                break
            case .prediction(_):
                break
            case .predictionFollowUp(_):
                break
            case .poll(_):
                break
            case .imageSlider(_):
                break
            case .socialEmbed(_):
                break
            case .videoAlert(_):
                break
            case .textAsk(_):
                break
            case .numberPrediction(_):
                break
            case .numberPredictionFollowUp(_):
                break
                
            }
        }
    }
    
}

