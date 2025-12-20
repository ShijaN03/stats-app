//
//  DetailedChartView.swift
//  StatisticsTestTask
//
//  Created by shijan on 20.12.2025.
//

import UIKit
import DGCharts
import PinLayout

class DetailedChartView: View, ChartViewDelegate {
    
    private var chartData: [Int] = []
    private var selectedIndex: Int = 0
    private var chartLabels: [String] = []
    
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
    
    private let tooltipView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.isHidden = true
        return view
    }()
    
    private let tooltipCountLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 18, weight: .bold)
        label.textColor = .mainThemeOrange
        return label
    }()
    
    private let tooltipDateLabel: UILabel = {
        let label = UILabel()
        label.font = .gilroy(size: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let chartView: LineChartView = {
        let view = LineChartView()
        view.legend.enabled = false
        view.rightAxis.enabled = false
        view.leftAxis.enabled = true
        view.leftAxis.drawLabelsEnabled = false
        view.leftAxis.drawAxisLineEnabled = false
        view.leftAxis.gridColor = .systemGray4
        view.leftAxis.gridLineWidth = 2
        view.leftAxis.gridLineDashLengths = [6, 4]
        view.leftAxis.setLabelCount(3, force: true)
        view.xAxis.labelPosition = .bottom
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.labelTextColor = .gray
        view.xAxis.labelFont = .systemFont(ofSize: 10)
        view.xAxis.drawAxisLineEnabled = false
        view.xAxis.avoidFirstLastClippingEnabled = true
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
        cardContainer.addSubview(tooltipView)
        tooltipView.addSubview(tooltipCountLabel)
        tooltipView.addSubview(tooltipDateLabel)
        
        chartView.delegate = self
        
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
            .top(60)
            .left(16)
            .right(16)
            .bottom(16)
        
        tooltipCountLabel.pin
            .top(8)
            .left(12)
            .sizeToFit()
        
        tooltipDateLabel.pin
            .below(of: tooltipCountLabel)
            .marginTop(2)
            .left(12)
            .sizeToFit()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let count = Int(entry.y)
        let index = Int(entry.x)
        
        tooltipCountLabel.text = "\(count) посетител\(getVisitorEnding(count))"
        if index < chartLabels.count {
            tooltipDateLabel.text = formatTooltipDate(chartLabels[index])
        }
        
        tooltipCountLabel.sizeToFit()
        tooltipDateLabel.sizeToFit()
        
        let width = max(tooltipCountLabel.bounds.width, tooltipDateLabel.bounds.width) + 24
        let height: CGFloat = 70
        
        tooltipView.frame = CGRect(x: 16, y: 8, width: width, height: height)
        
        tooltipCountLabel.frame = CGRect(x: 12, y: 12, width: tooltipCountLabel.bounds.width, height: tooltipCountLabel.bounds.height)
        tooltipDateLabel.frame = CGRect(x: 12, y: tooltipCountLabel.frame.maxY + 6, width: tooltipDateLabel.bounds.width, height: tooltipDateLabel.bounds.height)
        
        tooltipView.isHidden = false
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        tooltipView.isHidden = true
    }
    
    private func getVisitorEnding(_ count: Int) -> String {
        let lastTwo = count % 100
        let lastOne = count % 10
        
        if lastTwo >= 11 && lastTwo <= 19 {
            return "ей"
        }
        switch lastOne {
        case 1: return "ь"
        case 2, 3, 4: return "я"
        default: return "ей"
        }
    }
    
    private func formatTooltipDate(_ label: String) -> String {
        let months = ["01": "января", "02": "февраля", "03": "марта", "04": "апреля",
                      "05": "мая", "06": "июня", "07": "июля", "08": "августа",
                      "09": "сентября", "10": "октября", "11": "ноября", "12": "декабря"]
        
        let parts = label.split(separator: ".")
        if parts.count == 2 {
            let day = String(parts[0])
            let month = String(parts[1])
            return "\(Int(day) ?? 0) \(months[month] ?? label)"
        }
        return label
    }
    
    func updateData(with dates: [Int]) {
        chartData = dates
        updateChart()
    }
    
    private func updateChart() {
        guard !chartData.isEmpty else { return }
        
        let (entries, labels) = prepareChartData()
        guard !entries.isEmpty else { return }
        
        chartLabels = labels
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.circleRadius = 6
        dataSet.circleColors = [.mainThemeOrange]
        dataSet.circleHoleColor = .white
        dataSet.circleHoleRadius = 3
        dataSet.lineWidth = 3
        dataSet.setColor(.mainThemeOrange)
        dataSet.drawValuesEnabled = false
        dataSet.mode = .linear
        dataSet.highlightColor = .mainThemeOrange
        dataSet.highlightLineWidth = 1
        dataSet.highlightLineDashLengths = [4, 2]
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)
        chartView.xAxis.granularity = 1
        chartView.xAxis.setLabelCount(min(labels.count, 5), force: true)
        chartView.data = LineChartData(dataSet: dataSet)
        
        tooltipView.isHidden = true
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

