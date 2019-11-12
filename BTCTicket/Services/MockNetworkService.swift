//
//  MockNetworkService.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import RxSwift

struct MockNetworkService: NetworkingType {

    func decode<D: Decodable>(type: D.Type) -> Observable<D> {
        let jsonFileDecoder = JSONFileDecoder()
        guard let service = try? jsonFileDecoder.decodeFromJSONFile("GBPBTC", toType: D.self) else {
            return .empty()
        }
        return Observable.just(service)
    }
}
