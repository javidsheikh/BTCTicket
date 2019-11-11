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
    
    @IBOutlet weak var sellPriceLabel: UILabel!
    @IBOutlet weak var buyPriceLabel: UILabel!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    var viewModel: GBPToBitcoinViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension GBPToBitcoinViewController: BindableType {
    
    func bindViewModel() {
        viewModel.sellPriceSubject
            .observeOn(MainScheduler.instance)
            .bind(to: sellPriceLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.buyPriceSubject
            .observeOn(MainScheduler.instance)
            .bind(to: buyPriceLabel.rx.text)
            .disposed(by: bag)
    }
}
