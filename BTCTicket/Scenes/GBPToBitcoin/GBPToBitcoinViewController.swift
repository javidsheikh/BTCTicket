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
        unitsTextField.delegate = self
        amountTextField.delegate = self
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

extension GBPToBitcoinViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var acceptedCharacterString = "0123456789"
        if textField.tag == 1, let currentText = textField.text, !currentText.contains(".") {
            acceptedCharacterString.append(".")
        }
        let acceptedCharacterSet = CharacterSet(charactersIn: acceptedCharacterString)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        guard typedCharacterSet.isSubset(of: acceptedCharacterSet) else { return false }
        
        guard textField.tag == 1, let currentText = textField.text else { return true }
        
        let newText = currentText + string
        let splitString = newText.split(separator: ".")
        guard splitString.count > 1 else { return true }
        guard splitString[1].count <= 2 else { return false }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension GBPToBitcoinViewController {
    
    fileprivate func priceChangeToAttributedString(_ priceChange: PriceChange) -> Observable<NSAttributedString> {
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
