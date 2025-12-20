//
//  DetailedChartView.swift
//  StatisticsTestTask
//
//  Created by shijan on 20.12.2025.
//

import UIKit
import DGCharts
import PinLayout

class DetailedChartView: View {
    
    private var chartData: [Int] = []
    private var selectedIndex: Int = 0
    
    private let btnDays: UIButton = {
        let btn = UIButton()
        btn.setTitle("По дням", for: .normal)
        btn.titleLabel?.font = .gilroy(size: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let btnWeeks: UIButton = {
        let btn = UIButton()
        btn.setTitle("По неделям", for: .normal)
        btn.titleLabel?.font = .gilroy(size: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let btnMonths: UIButton = {
        let btn = UIButton()
        btn.setTitle("По месяцам", for: .normal)
        btn.titleLabel?.font = .gilroy(size: 14, weight: .medium)
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let chartView: LineChartView = {
        let view = LineChartView()
        view.legend.enabled = false
        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.xAxis.labelPosition = .bottom
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.labelTextColor = .gray
        view.xAxis.labelFont = .systemFont(ofSize: 11)
        view.backgroundColor = .clear
        view.doubleTapToZoomEnabled = false
        view.pinchZoomEnabled = false
        return view
    }()
    
    override func setupContent() {
        addSubview(btnDays)
        addSubview(btnWeeks)
        addSubview(btnMonths)
        addSubview(cardContainer)
        cardContainer.addSubview(chartView)
        
        btnDays.addTarget(self, action: #selector(daysTapped), for: .touchUpInside)
        btnWeeks.addTarget(self, action: #selector(weeksTapped), for: .touchUpInside)
        btnMonths.addTarget(self, action: #selector(monthsTapped), for: .touchUpInside)
        
        updateButtonStyles()
    }
    
    @objc private func daysTapped() {
        selectedIndex = 0
        updateButtonStyles()
        updateChart()
    }
    
    @objc private func weeksTapped() {
        selectedIndex = 1
        updateButtonStyles()
        updateChart()
    }
    
    @objc private func monthsTapped() {
        selectedIndex = 2
        updateButtonStyles()
        updateChart()
    }
    
    private func updateButtonStyles() {
        let buttons = [btnDays, btnWeeks, btnMonths]
        for (index, btn) in buttons.enumerated() {
            if index == selectedIndex {
                btn.backgroundColor = .mainThemeOrange
                btn.setTitleColor(.white, for: .normal)
                btn.layer.borderWidth = 0
            } else {
                btn.backgroundColor = .clear
                btn.setTitleColor(.black, for: .normal)
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor.systemGray4.cgColor
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = (bounds.width - 40 - 16) / 3
        
        btnDays.pin
            .top()
            .left(20)
            .width(buttonWidth)
            .height(40)
        
        btnWeeks.pin
            .top()
            .after(of: btnDays)
            .marginLeft(8)
            .width(buttonWidth)
            .height(40)
        
        btnMonths.pin
            .top()
            .after(of: btnWeeks)
            .marginLeft(8)
            .width(buttonWidth)
            .height(40)
        
        cardContainer.pin
            .below(of: btnDays)
            .marginTop(16)
            .left(20)
            .right(20)
            .bottom()
        
        chartView.pin
            .all()
            .margin(16)
    }
    
    func updateData(with dates: [Int]) {
        chartData = dates
        updateChart()
    }
    
    private func updateChart() {
        guard !chartData.isEmpty else { return }
        
        let (entries, labels) = prepareChartData()
        guard !entries.isEmpty else { return }
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.circleRadius = 6
        dataSet.circleColors = [.mainThemeOrange]
        dataSet.circleHoleColor = .moduleBackground
        dataSet.circleHoleRadius = 4
        dataSet.lineWidth = 4
        dataSet.setColor(.mainThemeOrange)
        dataSet.drawValuesEnabled = false
        dataSet.mode = .linear
        dataSet.highlightColor = .mainThemeOrange
        dataSet.highlightLineWidth = 1
        dataSet.highlightLineDashLengths = [4, 2]
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelCount = min(labels.count, 7)
        chartView.data = LineChartData(dataSet: dataSet)
    }
    
    private func prepareChartData() -> ([ChartDataEntry], [String]) {
        var entries: [ChartDataEntry] = []
        var labels: [String] = []
        
        switch selectedIndex {
        case 0:
            let grouped = Dictionary(grouping: chartData) { $0 }
            let sorted = grouped.keys.sorted()
            for (i, date) in sorted.enumerated() {
                entries.append(ChartDataEntry(x: Double(i), y: Double(grouped[date]?.count ?? 0)))
                labels.append(formatDay(date))
            }
        case 1:
            var weekData: [Int: Int] = [:]
            for date in chartData {
                let week = (date / 1000000 - 1) / 7 + 1
                weekData[week, default: 0] += 1
            }
            for (i, week) in weekData.keys.sorted().enumerated() {
                entries.append(ChartDataEntry(x: Double(i), y: Double(weekData[week] ?? 0)))
                labels.append("Нед \(week)")
            }
        case 2:
            var monthData: [Int: Int] = [:]
            for date in chartData {
                let month = (date / 10000) % 100
                monthData[month, default: 0] += 1
            }
            let monthNames = ["", "Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
            for (i, month) in monthData.keys.sorted().enumerated() {
                entries.append(ChartDataEntry(x: Double(i), y: Double(monthData[month] ?? 0)))
                let name = month <= 12 ? monthNames[month] : "?"
                labels.append(name)
            }
        default:
            break
        }
        
        return (entries, labels)
    }
    
    private func formatDay(_ date: Int) -> String {
        let day = date / 1000000
        let month = (date / 10000) % 100
        return String(format: "%02d.%02d", day, month)
    }
}
