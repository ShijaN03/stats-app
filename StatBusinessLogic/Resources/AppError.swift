//
//  APIError.swift
//  StatisticsTestTask
//
//  Created by shijan on 14.12.2025.
//

enum AppError: Error {
    case invalidURL
    case serverError
    case invalidResponse
    case noData
    case decodeError
    case cacheError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Некорректная ссылка"
        case .serverError:
            return "Ошибка сервера"
        case .invalidResponse:
            return "Неверный ответ сервера"
        case .noData:
            return "Нет данных от сервера"
        case .decodeError:
            return "Ошибка при декодировании"
        case .cacheError:
            return "Ошибка при кешировании"
        }
    }
}
