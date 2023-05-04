import UIKit
import LiveLikeSwift

class CustomCheerMeterWidgetViewController: Widget {
    private let model: CheerMeterWidgetModel

    private var cheerMeterWidgetView: CustomCheerMeterWidgetView!
    private var leftCheerOption: CheerMeterWidgetModel.Option
    private var rightCheerOption: CheerMeterWidgetModel.Option
    
    override init(model: CheerMeterWidgetModel) {
        self.model = model
        self.leftCheerOption = model.options[0]
        self.rightCheerOption = model.options[1]
        super.init(model: model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let cheerMeterView = CustomCheerMeterWidgetView()

        cheerMeterView.titleLabel.text = model.title
        cheerMeterView.leftChoiceText = "0"
        cheerMeterView.rightChoiceText = "0"

        cheerMeterView.optionViewA.optionLabel.text = model.options[0].text
        cheerMeterView.optionViewA.button.addTarget(self, action: #selector(optionViewASelected), for: .touchUpInside)
        do {
            let imageData = try Data(contentsOf: model.options[0].imageURL)
            cheerMeterView.optionViewA.imageView.image = UIImage(data: imageData)
        } catch {
            print(error)
        }

        cheerMeterView.optionViewB.optionLabel.text = model.options[1].text
        cheerMeterView.optionViewB.button.addTarget(self, action: #selector(optionViewBSelected), for: .touchUpInside)
        do {
            let imageData = try Data(contentsOf: model.options[1].imageURL)
            cheerMeterView.optionViewB.imageView.image = UIImage(data: imageData)
        } catch {
            print(error)
        }

        
        cheerMeterWidgetView = cheerMeterView

        view = cheerMeterView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        if model.userVotes.isEmpty {
            cheerMeterWidgetView.hidePowerBar()
        }
        self.model.registerImpression()
    }

    
    override func moveToNextState() {
        showResultsFromWidgetOptions()
    }
    
    public func showResultsFromWidgetOptions() {

        guard let cheerResults = options else { return }
        
        let totalVotes = model.options.map { $0.voteCount }.reduce(0, +)
        
        if let leftResults = cheerResults.first(where: { $0.id == leftCheerOption.id }) {
            let voteCount = (leftResults.voteCount ?? 0)
            let voteParts = totalVotes > 0 ? CGFloat(voteCount) / CGFloat(totalVotes) : 0
            let votePerecentage = voteParts * 100
            self.cheerMeterWidgetView.leftChoiceScore = voteCount
            self.cheerMeterWidgetView.leftChoiceText = String(format: "%.0f%%", votePerecentage)
        }
        if let rightResults = cheerResults.first(where: { $0.id == rightCheerOption.id }) {
            let voteCount = (rightResults.voteCount ?? 0)
            let voteParts = totalVotes > 0 ? CGFloat(voteCount) / CGFloat(totalVotes) : 0
            let votePerecentage = voteParts * 100
            self.cheerMeterWidgetView.rightChoiceScore = voteCount
            self.cheerMeterWidgetView.rightChoiceText = String(format: "%.0f%%", votePerecentage)
        }
       

    }

    @objc func optionViewASelected() {
        self.cheerMeterWidgetView.showPowerBar()
        self.cheerMeterWidgetView.optionViewA.layer.borderColor = UIColor.white.cgColor
        self.cheerMeterWidgetView.optionViewB.layer.borderColor = UIColor.gray.cgColor
        model.submitVote(optionID: model.options[0].id)
    }

    @objc func optionViewBSelected() {
        self.cheerMeterWidgetView.showPowerBar()
        self.cheerMeterWidgetView.optionViewB.layer.borderColor = UIColor.white.cgColor
        self.cheerMeterWidgetView.optionViewA.layer.borderColor = UIColor.gray.cgColor
        model.submitVote(optionID: model.options[1].id)
    }
}

extension CustomCheerMeterWidgetViewController: CheerMeterWidgetModelDelegate {
    func cheerMeterWidgetModel(
        _ model: CheerMeterWidgetModel,
        voteCountDidChange voteCount: Int,
        forOption optionID: String
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let totalVotes = model.options.map { $0.voteCount }.reduce(0, +)
            let voteParts = totalVotes > 0 ? CGFloat(voteCount) / CGFloat(totalVotes) : 0
            let votePerecentage = voteParts * 100
            if optionID == model.options[0].id {
                self.cheerMeterWidgetView.leftChoiceScore = voteCount
                self.cheerMeterWidgetView.leftChoiceText = String(format: "%.0f%%", votePerecentage)
            } else if optionID == model.options[1].id {
                self.cheerMeterWidgetView.rightChoiceScore = voteCount
                self.cheerMeterWidgetView.rightChoiceText = String(format: "%.0f%%", votePerecentage)
            }
        }
    }

    func cheerMeterWidgetModel(_ model: CheerMeterWidgetModel, voteRequest: CheerMeterWidgetModel.VoteRequest, didComplete result: Result<CheerMeterWidgetModel.Vote, Error>) {}
}
