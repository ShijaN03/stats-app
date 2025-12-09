//
//  StatisticsViewController.swift
//  StatisticsTestTask
//
//  Created by shijan on 08.12.2025.
//

import UIKit

class StatsController: UIViewController {
    
    private let rootView = StatsView()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
