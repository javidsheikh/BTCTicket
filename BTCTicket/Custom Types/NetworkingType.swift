//
//  NetworkingType.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkingType {
    func decode<D: Decodable>(type: D.Type) -> Observable<D>
}
