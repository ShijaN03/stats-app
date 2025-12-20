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
        view.minOffset = 0
        view.extraTopOffset = 10
        view.extraBottomOffset = 10
        view.extraLeftOffset = 10
        view.extraRightOffset = 10
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
        
        let isGrowing = values.count < 2 || values.last! >= values.first!
        let chartColor: UIColor = isGrowing ? .chartGreen : .chartRed
        
        var entries: [ChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: value))
        }
        
        let lineDataSet = LineChartDataSet(entries: entries)
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.lineWidth = 4
        lineDataSet.setColor(chartColor)
        lineDataSet.drawValuesEnabled = false
        lineDataSet.mode = .cubicBezier
        lineDataSet.cubicIntensity = 0.2
        lineDataSet.lineDashLengths = nil
        
        let lastEntry = entries.last!
        let pointDataSet = LineChartDataSet(entries: [lastEntry])
        pointDataSet.drawCirclesEnabled = true
        pointDataSet.circleRadius = 6
        pointDataSet.circleColors = [chartColor]
        pointDataSet.circleHoleRadius = 3
        pointDataSet.circleHoleColor = .white
        pointDataSet.lineWidth = 0
        pointDataSet.drawValuesEnabled = false
        
        chartView.data = LineChartData(dataSets: [lineDataSet, pointDataSet])
        
        return isGrowing
    }
}
