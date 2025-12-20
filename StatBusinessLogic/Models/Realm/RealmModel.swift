//
//  RealmModel.swift
//  StatisticsTestTask
//
//  Created by shijan on 17.12.2025.
//

import RealmSwift
import Foundation

class StatisticRealmObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var userId: Int
    @Persisted var type: String
    @Persisted var dates: List<Int>
    @Persisted var cachedAt: Date = Date()
}

class UserRealm: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var sex: String
    @Persisted var username: String
    @Persisted var isOnline: Bool
    @Persisted var age: Int
    @Persisted var avatarURL: String?
    @Persisted var cachedAt: Date = Date()
}
