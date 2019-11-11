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
        viewModel.sellPriceChangeSubject
            .observeOn(MainScheduler.instance)
            .flatMap(priceChangeToAttributedString)
            .bind(to: sellPriceLabel.rx.attributedText)
            .disposed(by: bag)
        
        viewModel.buyPriceChangeSubject
            .observeOn(MainScheduler.instance)
            .flatMap(priceChangeToAttributedString)
            .bind(to: buyPriceLabel.rx.attributedText)
            .disposed(by: bag)
    }
}

extension GBPToBitcoinViewController {
    
    func priceChangeToAttributedString(_ priceChange: PriceChange) -> Observable<NSAttributedString> {
        return Observable.create { [unowned self] observer in

            switch priceChange {
            case .increase(let priceString):
                observer.onNext(self.convertStringToAttributedString(priceString, withColor: .green))
            case .decrease(let priceString):
                observer.onNext(self.convertStringToAttributedString(priceString, withColor: .red))
            case .noChange(let priceString):
                observer.onNext(self.convertStringToAttributedString(priceString, withColor: .white))
            }
                    
            return Disposables.create()
        }
    }
    
    private func convertStringToAttributedString(_ priceString: String, withColor colour: UIColor) -> NSAttributedString {
        let splitPriceStringArray = priceString.split(separator: ".")
        var attributes = Font.pricePound.attributes
        attributes[NSAttributedString.Key.foregroundColor] = colour
        let priceAttrString = NSMutableAttributedString(string: priceString, attributes: attributes)

        if splitPriceStringArray.count > 1 {
            let penceRange = NSString(string: priceString).range(of: String(splitPriceStringArray[1]))
            priceAttrString.addAttributes(Font.pricePence.attributes, range: penceRange)
        }
        
        return priceAttrString
    }
}
