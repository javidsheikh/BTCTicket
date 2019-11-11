//
//  GBPToBitcoinViewController.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 11/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import UIKit
import RxSwift

class GBPToBitcoinViewController: UIViewController {
    
    var viewModel: GBPToBitcoinViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension GBPToBitcoinViewController: BindableType {
    
    func bindViewModel() {
        viewModel.bitcoinPriceSubject
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: bag)
    }
}
