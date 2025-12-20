//
//  AllVisitorsChart.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import UIKit
import DGCharts
import PinLayout

class AllVisitorsChart: View {
    
    private let chartView: LineChartView = {
        let view = LineChartView()
        view.legend.enabled = false
        view.xAxis.enabled = false
        view.leftAxis.enabled = false
        view.rightAxis.enabled = false
        view.drawGridBackgroundEnabled = false
        view.drawBordersEnabled = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }()
    
    override func setupContent() {
        addSubview(chartView)
    }
    
    override func layoutSubviews() {
        chartView.pin.all()
    }
    
    func updateData(_ values: [Double]) -> Bool {
        guard !values.isEmpty else { return true }
        
        var entries: [ChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }
        
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 5
        dataSet.circleColors = Array(repeating: .clear, count: max(0, values.count - 1)) + [.systemGreen]
        dataSet.circleHoleRadius = 0
        dataSet.lineWidth = 3
        dataSet.setColor(.systemGreen)
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        
        chartView.data = LineChartData(dataSet: dataSet)
        
        let isGrowing = values.count < 2 || values.last! >= values.first!
        return isGrowing
    }
}
