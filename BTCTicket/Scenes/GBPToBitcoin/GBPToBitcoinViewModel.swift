//
//  GBPToBitcoinViewModel.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct GBPToBitcoinViewModel {

    private let networkingService: NetworkingType
    private let globalScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    private let bag = DisposeBag()

    var sellPriceRelay: BehaviorRelay<Float>!
    var buyPriceRelay: BehaviorRelay<Float>!
    var spreadRelay: BehaviorRelay<String>!
    var sellPriceChangeSubject: PublishSubject<(PriceChange)>!
    var buyPriceChangeSubject: PublishSubject<(PriceChange)>!

    init(networkingService: NetworkingType) {
        self.networkingService = networkingService
        self.sellPriceRelay = BehaviorRelay<Float>(value: 0.00)
        self.buyPriceRelay = BehaviorRelay<Float>(value: 0.00)
        self.spreadRelay = BehaviorRelay<String>(value: "")
        self.sellPriceChangeSubject = PublishSubject<(PriceChange)>()
        self.buyPriceChangeSubject = PublishSubject<(PriceChange)>()

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
        switch bitcoinPrice.sell {
        case let price where price > sellPriceRelay.value:
            sellPriceChangeSubject.onNext(.increase(String(price)))
        case let price where price < sellPriceRelay.value:
            sellPriceChangeSubject.onNext(.decrease(String(price)))
        default:
            sellPriceChangeSubject.onNext(.noChange(String(bitcoinPrice.sell)))
        }

        switch bitcoinPrice.buy {
        case let price where price > sellPriceRelay.value:
            buyPriceChangeSubject.onNext(.increase(String(format: "%.2f", price)))
        case let price where price < sellPriceRelay.value:
            buyPriceChangeSubject.onNext(.decrease(String(format: "%.2f", price)))
        default:
            buyPriceChangeSubject.onNext(.noChange(String(format: "%.2f", bitcoinPrice.buy)))
        }

        sellPriceRelay.accept(bitcoinPrice.sell)
        buyPriceRelay.accept(bitcoinPrice.buy)

        let spread = round((bitcoinPrice.sell - bitcoinPrice.buy) * 100) / 100
        let spreadString = String(format: "%.2f", spread)
        spreadRelay.accept(spreadString)

        return Observable.empty()
    }
}
