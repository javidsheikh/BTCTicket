//
//  URLSession+Rx.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {

    func decodable<D: Decodable>(request: URLRequest, type: D.Type) -> Observable<D> {
        return data(request: request).map { data in
            let decoder = JSONDecoder()
            return try decoder.decode(D.self, from: data)
        }
    }
}
