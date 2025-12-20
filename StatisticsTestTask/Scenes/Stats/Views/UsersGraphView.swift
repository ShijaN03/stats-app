//
//  UsersGraphView.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import UIKit
import PinLayout

class UsersGraphView: View {
    
    private let allVisitorsChart = AllVisitorsChart()
    private var visitorsCount: Int = 0
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Посетители"
        view.font = .gilroy(size: 20, weight: .bold)
        return view
    }()
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .moduleBackground
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let countLabel: UILabel = {
        let view = UILabel()
        view.font = .gilroy(size: 24, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrow_up")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "Количество посетителей в\nэтом месяце выросло"
        view.font = .gilroy(size: 14, weight: .regular)
        view.textColor = .gray
        view.numberOfLines = 2
        return view
    }()
    
    override func setupContent() {
        addSubview(titleLabel)
        addSubview(cardContainer)
        cardContainer.addSubview(allVisitorsChart)
        cardContainer.addSubview(countLabel)
        cardContainer.addSubview(arrowImageView)
        cardContainer.addSubview(descriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.pin
            .top()
            .left(20)
            .sizeToFit()
        
        cardContainer.pin
            .below(of: titleLabel)
            .marginTop(12)
            .left(20)
            .right(20)
            .height(98)
        
        allVisitorsChart.pin
            .left(16)
            .top(15)
            .width(100)
            .height(70)
        
        countLabel.pin
            .after(of: allVisitorsChart)
            .marginLeft(16)
            .top(20)
            .sizeToFit()
        
        arrowImageView.pin
            .after(of: countLabel)
            .marginLeft(4)
            .vCenter(to: countLabel.edge.vCenter)
            .size(20)
        
        descriptionLabel.pin
            .after(of: allVisitorsChart)
            .marginLeft(16)
            .below(of: countLabel)
            .marginTop(4)
            .right(16)
            .sizeToFit()
    }
    
    func updateChart(with dates: [Int]) {
        visitorsCount = dates.count
        countLabel.text = "\(visitorsCount)"
        
        let grouped = Dictionary(grouping: dates) { $0 }
        let values = grouped.keys.sorted().map { Double(grouped[$0]?.count ?? 0) }
        let isGrowing = allVisitorsChart.updateData(values)
        
        if isGrowing {
            arrowImageView.image = UIImage(named: "arrow_up")
            descriptionLabel.text = "Количество посетителей в\nэтом месяце выросло"
        } else {
            arrowImageView.image = UIImage(named: "arrow_down")
            descriptionLabel.text = "Количество посетителей в\nэтом месяце упало"
        }
        
        setNeedsLayout()
    }
}
