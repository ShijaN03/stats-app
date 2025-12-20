//
//  ObserversView.swift
//  StatisticsTestTask
//
//  Created by shijan on 20.12.2025.
//

import UIKit
import DGCharts
import PinLayout
import StatBusinessLogic

class ObserversView: View {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Наблюдатели"
        label.font = .gilroy(size: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let newFollowersCard = ObserverCardView(isPositive: true)
    private let unfollowersCard = ObserverCardView(isPositive: false)
    
    override func setupContent() {
        addSubview(titleLabel)
        addSubview(newFollowersCard)
        addSubview(unfollowersCard)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.pin
            .top()
            .left(20)
            .sizeToFit()
        
        newFollowersCard.pin
            .below(of: titleLabel)
            .marginTop(16)
            .left(20)
            .right(20)
            .height(100)
        
        unfollowersCard.pin
            .below(of: newFollowersCard)
            .marginTop(12)
            .left(20)
            .right(20)
            .height(100)
    }
    
    func configure(with statistics: [Statistic]) {
        let subscribeDates = statistics
            .filter { $0.type == "subscription" }
            .flatMap { $0.dates }
        
        let unsubscribeDates = statistics
            .filter { $0.type == "unsubscription" }
            .flatMap { $0.dates }
        
        newFollowersCard.configure(
            count: subscribeDates.count,
            description: "Новые наблюдатели в\nэтом месяце",
            dates: subscribeDates
        )
        
        unfollowersCard.configure(
            count: unsubscribeDates.count,
            description: "Пользователей перестали\nза Вами наблюдать",
            dates: unsubscribeDates
        )
    }
}

class ObserverCardView: View {
    
    private let isPositive: Bool
    private var chartColor: UIColor { isPositive ? .systemGreen : .systemRed }
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let chartView: LineChartView = {
        let view = LineChartView()
        view.legend.enabled = false
        view.xAxis.enabled = false
        view.leftAxis.enabled = false
        view.rightAxis.enabled = false
        view.drawGridBackgroundEnabled = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let arrowLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 2
        return label
    }()
    
    init(isPositive: Bool) {
        self.isPositive = isPositive
        super.init()
        
        arrowLabel.text = isPositive ? "↑" : "↓"
        arrowLabel.textColor = chartColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent() {
        addSubview(cardContainer)
        cardContainer.addSubview(chartView)
        cardContainer.addSubview(countLabel)
        cardContainer.addSubview(arrowLabel)
        cardContainer.addSubview(descriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardContainer.pin.all()
        
        chartView.pin
            .left(16)
            .vCenter()
            .width(100)
            .height(50)
        
        countLabel.pin
            .after(of: chartView)
            .marginLeft(16)
            .top(20)
            .sizeToFit()
        
        arrowLabel.pin
            .after(of: countLabel)
            .marginLeft(4)
            .top(to: countLabel.edge.top)
            .sizeToFit()
        
        descriptionLabel.pin
            .after(of: chartView)
            .marginLeft(16)
            .below(of: countLabel)
            .marginTop(4)
            .right(16)
            .sizeToFit()
    }
    
    func configure(count: Int, description: String, dates: [Int]) {
        countLabel.text = "\(count)"
        descriptionLabel.text = description
        updateChart(with: dates)
        setNeedsLayout()
    }
    
    private func updateChart(with dates: [Int]) {
        let grouped = Dictionary(grouping: dates) { $0 }
        let values = grouped.keys.sorted().map { Double(grouped[$0]?.count ?? 0) }
        
        guard !values.isEmpty else { return }
        
        var entries: [ChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4
        dataSet.circleColors = Array(repeating: .clear, count: max(0, values.count - 1)) + [chartColor]
        dataSet.circleHoleRadius = 0
        dataSet.lineWidth = 2
        dataSet.setColor(chartColor)
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        
        chartView.data = LineChartData(dataSet: dataSet)
    }
}
