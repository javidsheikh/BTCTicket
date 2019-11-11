//
//  GBPToBitcoinViewModel.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import Foundation
import RxSwift

struct GBPToBitcoinViewModel {
    
    private let networkingService: NetworkingType
    private let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    private let bag = DisposeBag()

    var sellPriceSubject: PublishSubject<String>!
    var buyPriceSubject: PublishSubject<String>!

    init(networkingService: NetworkingType) {
        self.networkingService = networkingService
        self.sellPriceSubject = PublishSubject<String>()
        self.buyPriceSubject = PublishSubject<String>()
        
        _ = Observable<Int>.timer(0.0, period: 15.0, scheduler: globalScheduler)
            .map { _ in }
            .flatMap(startPollingService)
            .flatMap(postPriceToSubject)
            .subscribe()
            .disposed(by: bag)
    }
    
    private func startPollingService() -> Observable<BitcoinPrice> {
        return networkingService.decode(type: GBPToBitcoin.self)
            .map { $0.GBP }
    }
    
    private func postPriceToSubject(_ bitcoinPrice: BitcoinPrice) -> Observable<Void> {
        sellPriceSubject?.onNext(String(bitcoinPrice.sell))
        buyPriceSubject?.onNext(String(bitcoinPrice.buy))

        return Observable.empty()
    }
}
