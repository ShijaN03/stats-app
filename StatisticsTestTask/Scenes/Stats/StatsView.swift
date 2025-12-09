//
//  StatisticsView.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import UIKit
import PinLayout

class StatsView: View {
    
    private lazy var scrollView: UIScrollView = {
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin
            .all()
        titleLabel.pin
            .top(100)
            .left(20)
            .sizeToFit()
    }
}
