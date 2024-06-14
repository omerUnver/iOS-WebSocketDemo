//
//  BinanceMarketPriceModel.swift
//  WebSocketDemo
//
//  Created by M.Ömer Ünver on 14.06.2024.
//

import Foundation
struct BinanceMarketPriceModel: Codable, Identifiable, Hashable {
    var id = UUID()
    let e : String
    let E : Int
    let s : String
    let p : String
    let P : String
    let i : String
    let r : String
    let T : Int
    
    enum CodingKeys: String, CodingKey {
            case e, E, s, p, P, i, r, T
        }
}

struct BinanceMarketPrice : Codable {
    let stream : String
    let data : [BinanceMarketPriceModel]
}
