//
//  StatisticsViewController.swift
//  StatisticsTestTask
//
//  Created by shijan on 08.12.2025.
//

import UIKit

class StatisticsViewController: UIViewController {
    var interactor: StatisticsBusinessLogic?
    var router: StatisticsRoutingLogic?
    
    private lazy var rootView = StatisticsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainThemeBackground
    }
}

extension StatisticsViewController: StatisticsDisplayLogic {
    
}
