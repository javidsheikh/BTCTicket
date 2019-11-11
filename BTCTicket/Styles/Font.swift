//
//  Font.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import UIKit

enum Font {
    case pricePound, pricePence

    var attributes: [NSAttributedString.Key: Any] {
        switch self {
        case .pricePound:
            return [NSAttributedString.Key.font: UIFont(name: "PingFangHK-Medium", size: 32.0) as Any]
        case .pricePence:
            return [NSAttributedString.Key.font: UIFont(name: "PingFangHK-Medium", size: 18.0) as Any]
        }
    }
}
