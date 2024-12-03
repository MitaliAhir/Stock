//
//  Model.swift
//  Stock
//
//  Created by Mitali Ahir on 2024-11-27.
//

import Foundation

struct ResultValues: Codable {
    var results: [TStock]
}

struct TStock: Codable {
    var name: String
    var performanceId: String
}

//Created enum to map Int values to the appropriate state.
enum StockState: Int32 {
    case watchlist = 1
    case active = 0
    
    static func fromInt(_ value: Int32) -> StockState {
        return StockState(rawValue: value) ?? .watchlist // Default to wishlist
    }
}

//Created enum to map Int values to the appropriate rank categories.
enum StockRank: Int32 {
    case cold = 0 // Cold
    case hot = 1  // Hot
    case veryHot = 2  // Very Hot
    
    static func fromInt(_ value: Int32) -> StockRank {
        return StockRank(rawValue: value) ?? .cold // Default to cold
    }
}

