//
//  StatisticsView.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import UIKit
import PinLayout
import StatBusinessLogic

class StatsView: View {
    
    private let usersGraph = UsersGraphView()
    private let detailedChart = DetailedChartView()
    private let topVisitors = TopVisitorsView()
    private let genderAge = GenderAgeView()
    private let observers = ObserversView()
    private var currentStatistics: [Statistic] = []
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .mainThemeBackground
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Статистика"
        view.font = .gilroy(size: 32, weight: .bold)
        return view
    }()
    
    
    override func setupContent() {
        addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(usersGraph)
        scrollView.addSubview(detailedChart)
        scrollView.addSubview(topVisitors)
        scrollView.addSubview(genderAge)
        scrollView.addSubview(observers)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin.all()
        
        titleLabel.pin
            .top(50)
            .left(20)
            .sizeToFit()
        
        usersGraph.pin
            .below(of: titleLabel)
            .marginTop(20)
            .left()
            .right()
            .height(140)
        
        detailedChart.pin
            .below(of: usersGraph)
            .marginTop(20)
            .left()
            .right()
            .height(300)
        
        topVisitors.pin
            .below(of: detailedChart)
            .marginTop(30)
            .left()
            .right()
            .height(250)
        
        genderAge.pin
            .below(of: topVisitors)
            .marginTop(30)
            .left()
            .right()
            .height(600)
        
        observers.pin
            .below(of: genderAge)
            .marginTop(30)
            .left()
            .right()
            .height(260)
        
        scrollView.contentSize = CGSize(
            width: bounds.width,
            height: observers.frame.maxY + 40
        )
    }
    
    func updateVisitorsChart(with statistics: [Statistic]) {
        currentStatistics = statistics
        let viewDates = statistics
            .filter { $0.type == "view" }
            .flatMap { $0.dates }
        usersGraph.updateChart(with: viewDates)
        detailedChart.updateData(with: viewDates)
        observers.configure(with: statistics)
    }
    
    func updateTopVisitors(with users: [User]) {
        topVisitors.configure(with: users)
        genderAge.configure(with: users)
    }
}
