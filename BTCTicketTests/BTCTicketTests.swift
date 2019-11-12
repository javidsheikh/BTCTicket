//
//  BTCTicketTests.swift
//  
//
//  Created by Javid Sheikh on 11/11/2019.
//

import Quick
import Nimble
import RxSwift
@testable import BTCTicket

class BTCTicketTests: QuickSpec {

    override func spec() {
        var viewModel: GBPToBitcoinViewModel!
        let bag = DisposeBag()
        
        beforeEach {
            let networkService = MockNetworkService()
            viewModel = GBPToBitcoinViewModel(networkingService: networkService)
        }

        describe("I am in the ticket scene") {

            context("I check the Bitcoin sell price") {
                it("it should update every 15 seconds with the current sell price") {
                    viewModel.sellPriceChangeSubject
                        .subscribe(onNext: {
                            switch $0 {
                            case .increase(let price):
                                expect(price).to(equal("6787.33"))
                            default:
                                XCTFail()
                            }
                        })
                        .disposed(by: bag)
                }
            }

            context("I check the Bitcoin buy price") {
                it("it should update every 15 seconds with the current buy price") {
                    viewModel.buyPriceChangeSubject
                        .subscribe(onNext: {
                            switch $0 {
                            case .increase(let price):
                                expect(price).to(equal("6783.01"))
                            default:
                                XCTFail()
                            }
                        })
                        .disposed(by: bag)
                }
            }

            context("the Bitcoin prices update") {
                it("the spread label should update accordingly") {
                    viewModel.spreadRelay.asObservable()
                        .subscribe(onNext: {
                            expect($0).to(equal("4.32"))
                        })
                        .disposed(by: bag)
                }
            }

            context("I input a number of units") {
                it("the amount text field should be automatically populated with the correct amount using the current buy price") {

                }
            }

            context("I input an amount") {
                it("the units text field should be automatically populated with the correct number of units using the current buy price") {

                }
            }
        }
    }
}
