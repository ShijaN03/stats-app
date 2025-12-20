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
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let newFollowersCard = ObserverCardView(isPositive: true)
    private let unfollowersCard = ObserverCardView(isPositive: false)
    
    override func setupContent() {
        addSubview(titleLabel)
        addSubview(cardContainer)
        cardContainer.addSubview(newFollowersCard)
        cardContainer.addSubview(separatorLine)
        cardContainer.addSubview(unfollowersCard)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.pin
            .top()
            .left(20)
            .sizeToFit()
        
        cardContainer.pin
            .below(of: titleLabel)
            .marginTop(16)
            .left(20)
            .right(20)
            .bottom()
        
        newFollowersCard.pin
            .top()
            .left()
            .right()
            .height(cardContainer.bounds.height / 2 - 0.5)
        
        separatorLine.pin
            .below(of: newFollowersCard)
            .left(16)
            .right(16)
            .height(1)
        
        unfollowersCard.pin
            .below(of: separatorLine)
            .left()
            .right()
            .bottom()
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
    private var chartColor: UIColor { isPositive ? .chartGreen : .chartRed }
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
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
    
    private let arrowImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
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
        
        arrowImageView.image = UIImage(named: isPositive ? "arrow_up" : "arrow_down")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupContent() {
        addSubview(cardContainer)
        cardContainer.addSubview(chartView)
        cardContainer.addSubview(countLabel)
        cardContainer.addSubview(arrowImageView)
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
        
        arrowImageView.pin
            .after(of: countLabel)
            .marginLeft(4)
            .vCenter(to: countLabel.edge.vCenter)
            .size(18)
        
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
        var values = grouped.keys.sorted().map { Double(grouped[$0]?.count ?? 0) }
        
        guard !values.isEmpty else { return }
        
        // Если только одна точка, добавляем точки для визуализации
        if values.count == 1 {
            let singleValue = values[0]
            values = [singleValue * 0.5, singleValue * 0.7, singleValue]
        } else if values.count == 2 {
            let first = values[0]
            let second = values[1]
            values = [first, (first + second) / 2, second]
        }
        
        var entries: [ChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }
        
        // Линия без кругов
        let lineDataSet = LineChartDataSet(entries: entries)
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.lineWidth = 3
        lineDataSet.setColor(chartColor)
        lineDataSet.drawValuesEnabled = false
        lineDataSet.mode = .cubicBezier
        lineDataSet.cubicIntensity = 0.2
        lineDataSet.lineDashLengths = nil
        
        // Точка только на конце
        let lastEntry = entries.last!
        let pointDataSet = LineChartDataSet(entries: [lastEntry])
        pointDataSet.drawCirclesEnabled = true
        pointDataSet.circleRadius = 5
        pointDataSet.circleColors = [chartColor]
        pointDataSet.circleHoleRadius = 2
        pointDataSet.circleHoleColor = .white
        pointDataSet.lineWidth = 0
        pointDataSet.drawValuesEnabled = false
        
        chartView.data = LineChartData(dataSets: [lineDataSet, pointDataSet])
    }
}
