//
//  StatisticsWorker.swift
//  StatisticsTestTask
//
//  Created by shijan on 17.12.2025.
//

import Foundation
import RxSwift
import RealmSwift

public class StatisticsWorker {
    
    public static let shared = StatisticsWorker()
    
    private init() {}
    
    private func fetchFromNetwork() -> Observable<StatisticsResponse> {
        return NetworkManager.shared.request(APIEndpoints.statistics)
            .do(onNext: { [weak self] response in
                self?.saveToCache(response)
            })
    }
    
    public func getStatistics(forceRefresh: Bool = false) -> Observable<StatisticsResponse> {
        
        if forceRefresh {
            return fetchFromNetwork()
        }
        
        if let cached = getCachedStatistics() {
            return Observable
                .just(cached)
        }
        
        return fetchFromNetwork()
    }
    
    private func getCachedStatistics() -> StatisticsResponse? {
        do {
            let realm = try Realm()
            
            let cached = realm.objects(StatisticRealmObject.self)
            
            guard !cached.isEmpty else { return nil }
            
            let items = cached.map { item in
                Statistic(
                    userId: item.userId,
                    type: item.type,
                    dates: Array(item.dates)
                )
            }
            
            return StatisticsResponse(statistics: Array(items))
        } catch {
            print("\(AppError.cacheError)")
            return nil
        }
    }
    
    private func saveToCache(_ response: StatisticsResponse) {
        do {
            let realm = try Realm()
            
            try realm.write {
                let oldObjects = realm.objects(StatisticRealmObject.self)
                realm.delete(oldObjects)
                
                for item in response.statistics {
                    let object = StatisticRealmObject()
                    object.userId = item.userId
                    object.type = item.type
                    object.dates.append(objectsIn: item.dates)
                    realm.add(object)
                }
            }
        } catch {
            print("\(AppError.cacheError)")
        }
    }
    
    public func getUsers() -> Observable<UsersResponse> {
        return NetworkManager.shared.request(APIEndpoints.users)
    }
}
