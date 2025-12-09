//
//  UIFont.swift
//  StatisticsTestTask
//
//  Created by shijan on 09.12.2025.
//

import UIKit

extension UIFont {
    
    static func gilroy(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        
        let name: String
        
        switch weight {
        case .bold: name = "Gilroy-Bold"
        case .heavy: name = "Gilroy-Heavy"
        case .semibold: name = "Gilroy-Semibold"
        case .regular: name = "Gilroy-Regular"
        default:
            name = "Gilroy-Regular"
        }
        
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: weight)
    }
}
