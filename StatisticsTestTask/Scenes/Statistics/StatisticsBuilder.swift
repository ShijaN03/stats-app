//
//  StatisticsBuilder.swift
//  StatisticsTestTask
//
//  Created by shijan on 08.12.2025.
//

import UIKit

final class StatisticsBuilder {
    static func build() -> UIViewController {
        let view = StatisticsViewController()
        let presenter = StatisticsPresenter()
        let interactor = StatisticsInteractor()
        let router = StatisticsRouter()
        let worker = StatisticsWorker()
        view.interactor = interactor
        view.router = router
        
        presenter.view = view
        
        interactor.presenter = presenter
        interactor.worker = worker
        
        router.viewController = view
        
        return view
    }
}
