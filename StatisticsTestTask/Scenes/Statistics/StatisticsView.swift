//
//  StatisticsView.swift
//  StatisticsTestTask
//
//  Created by shijan on 08.12.2025.
//

import UIKit

class StatisticsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupContent()
        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private func setupLayout() {
        addSubview(scrollView)
    }
    
    private func setupContent() {
        
    }
    
    
}
