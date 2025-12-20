//
//  NetworkManager.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import Foundation
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(_ endpoint: URL) -> Observable<T> {
        return Observable.create { observer in
            
            let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
                
                if let error = error {
                    observer.onError(AppError.serverError)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    observer.onError(AppError.invalidResponse)
                    return
                }
                
                guard let data = data else {
                    observer.onError(AppError.noData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    observer.onNext(result)
                    observer.onCompleted()
                } catch {
                    observer.onError(AppError.decodeError)
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
