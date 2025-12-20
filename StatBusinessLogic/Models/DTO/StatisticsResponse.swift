//
//  StatisticsResponse.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import Foundation

public struct StatisticsResponse: Codable {
    public let statistics: [Statistic]
}

public struct Statistic: Codable {
    public let userId: Int
    public let type: String
    public let dates: [Int]
    
    public init(userId: Int, type: String, dates: [Int]) {
        self.userId = userId
        self.type = type
        self.dates = dates
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case type
        case dates
    }
}
