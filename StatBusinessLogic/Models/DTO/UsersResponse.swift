//
//  UsersResponse.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import Foundation

public struct UsersResponse: Codable {
    public let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case users
    }
}

public struct User: Codable {
    public let id: Int
    public let sex: String
    public let username: String
    public let isOnline: Bool
    public let age: Int
    public let files: [UserFile]
}

public struct UserFile: Codable {
    public let id: Int
    public let url: String
    public let type: String
}
