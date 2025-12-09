//
//  View.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import UIKit

open class View: UIView {
    
    open func setupContent() { }
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupContent()
        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
