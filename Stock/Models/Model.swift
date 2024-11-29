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
