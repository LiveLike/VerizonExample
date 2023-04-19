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
    
    private let widgetTimeline: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let widgetView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
//    private let widgetView: UIView = {
//        let widgetView = UIView()
//        widgetView.translatesAutoresizingMaskIntoConstraints = false
//        return widgetView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(widgetTimeline)
        NSLayoutConstraint.activate([
            widgetTimeline.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            widgetTimeline.topAnchor.constraint(equalTo: view.topAnchor),
            widgetTimeline.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            widgetTimeline.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.widgetTimeline.addSubview(widgetView)
        NSLayoutConstraint.activate([
            widgetView.leadingAnchor.constraint(equalTo: widgetTimeline.leadingAnchor),
            widgetView.topAnchor.constraint(equalTo: widgetTimeline.topAnchor),
            widgetView.trailingAnchor.constraint(equalTo: widgetTimeline.trailingAnchor),
            widgetView.bottomAnchor.constraint(equalTo: widgetTimeline.bottomAnchor),
            widgetView.widthAnchor.constraint(equalTo: widgetTimeline.widthAnchor)
        ])
        
       
        initSDK()
        loadCheerMeterWidget()
    }
    
    func initSDK(){
        var config = LiveLikeConfig(clientID: "8PqSNDgIVHnXuJuGte1HdvOjOqhCFE1ZCR3qhqaS")
        config.accessTokenStorage = self
        self.livelike = LiveLike(config: config)
    }
    
    
    func loadCheerMeterWidget(){
        self.livelike?.getWidgetModel(id: "9cceb48d-dfc0-44a6-96a4-ae5ab1f8dd88", kind: WidgetKind.cheerMeter){ [self] result in
            handleResult(result: result)
        }
        
        self.livelike?.getWidgetModel(id: "5ee6405e-a6bf-4030-b477-5243a087d237", kind: WidgetKind.textPoll){ [self] result in
            handleResult(result: result)
        }
        
        
        self.livelike?.getWidgetModel(id: "3b11b5a3-1e2b-4e59-bf8e-f01994164d8c", kind: WidgetKind.textPoll){ [self] result in
            handleResult(result: result)
        }
        
    }
    
    func presentWidget(widgetViewController: Widget){
        DispatchQueue.main.async { [weak self] in
            if let self = self {
                let viewController = widgetViewController
                self.addChild(viewController)
                viewController.didMove(toParent: self)
                viewController.view.translatesAutoresizingMaskIntoConstraints = false
                self.widgetView.addArrangedSubview(viewController.view)
                viewController.delegate = self.interactiveTimelineWidgetViewDelegate
                viewController.moveToNextState()
            }
            
        }
    }
    
    func handleResult(result: Result<WidgetModel, Error>){
        switch result {
        case .failure(let error):
            print(error)
        case .success(let widgetModel):
            switch widgetModel {
            case let .cheerMeter(model):
                model.loadInteractionHistory { result in
                    switch result {
                    case .failure(let error):
                        print("\(error)")
                    case .success(let interations):
                        self.presentWidget(widgetViewController: CustomCheerMeterWidgetViewController(model: model))
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
            case let .poll(model):
                model.loadInteractionHistory { result in
                    switch result {
                    case .failure(let error):
                        print("\(error)")
                    case .success(let interations):
                        self.presentWidget(widgetViewController: CustomTextPollWidgetViewController(model: model))
                    }
                }
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

extension ViewController: AccessTokenStorage {
    func fetchAccessToken() -> String? {
        return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2Nlc3NfdG9rZW4iOiJlNTc5YmQxOWNlNTRkYmU2N2VlMmE5ODE4MjljYTliOWQxMDEzOTNmIiwiaXNzIjoiYmxhc3RydCIsImNsaWVudF9pZCI6IjhQcVNORGdJVkhuWHVKdUd0ZTFIZHZPak9xaENGRTFaQ1IzcWhxYVMiLCJpYXQiOjE2ODA3NzU1MDksImlkIjoiZWFiYWRkY2UtOGJlOS00ZDA1LWI1MmMtNmE4ODUyZmU4NDVmIn0.DYOSKGCyGkMCNl_LUAJXi6RJA_v8Ufa9mXF9NG3Gk0Q"
    }
    
    func storeAccessToken(accessToken: String) {
        //As VZ will be providing token always, we do not need to store token
    }
}

