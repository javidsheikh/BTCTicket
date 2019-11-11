//
//  BitcoinPrice.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

struct BitcoinPrice: Decodable {
    let fifteenMin: Float
    let last: Float
    let buy: Float
    let sell: Float
    let symbol: String
    
    private enum CodingKeys: String, CodingKey {
        case fifteenMin = "15m"
        case last
        case buy
        case sell
        case symbol
    }
}
