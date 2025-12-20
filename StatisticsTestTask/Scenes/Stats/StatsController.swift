//
//  StatisticsViewController.swift
//  StatisticsTestTask
//
//  Created by shijan on 08.12.2025.
//

import UIKit
import RxSwift
import StatBusinessLogic

class StatsController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let rootView = StatsView()
    private let refreshControl = UIRefreshControl()
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPullToRefresh()
        loadData()
    }
    
    private func loadData(forceRefresh: Bool = false) {
        StatisticsWorker.shared.getStatistics(forceRefresh: forceRefresh)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] response in
                    self?.rootView.updateVisitorsChart(with: response.statistics)
                },
                onError: { error in
                    print("Statistics error: \(error)")
                }
            )
            .disposed(by: disposeBag)
        
        StatisticsWorker.shared.getUsers()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] response in
                    self?.refreshControl.endRefreshing()
                    self?.rootView.updateTopVisitors(with: response.users)
                },
                onError: { [weak self] error in
                    self?.refreshControl.endRefreshing()
                    print("Users error: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
        
    private func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        rootView.scrollView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        loadData(forceRefresh: true)
    }
}
