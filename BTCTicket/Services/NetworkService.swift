//
//  NetworkService.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import Foundation
import RxSwift

struct NetworkService: NetworkingType {
    
    private let session: URLSession
    private let urlString: Observable<String>

    init(configuration: URLSessionConfiguration, urlString: String) {
        self.session = URLSession(configuration: configuration)
        self.urlString = Observable.just(urlString)
    }

    func decode<D: Decodable>(type: D.Type) -> Observable<D> {
        return urlString.flatMap { urlString -> Observable<D> in
            guard let url = URL(string: urlString) else { return .empty() }
            let request = URLRequest(url: url)
            return self.session.rx.decodable(request: request, type: D.self)
        }
    }
}

extension NetworkService {
    static let blockchainTickerURLString = "https://www.blockchain.com/ticker"
}
