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
    @IBOutlet weak var spreadLabel: UILabel!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!

    var viewModel: GBPToBitcoinViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        unitsTextField.delegate = self
        amountTextField.delegate = self

        unitsTextField.addDoneToolbar()
        amountTextField.addDoneToolbar()

        bindTextFieldsAndConfirmButton()
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

        viewModel.spreadRelay.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: spreadLabel.rx.text)
            .disposed(by: bag)

        _ = Observable.combineLatest(amountTextField.rx.text.orEmpty, viewModel.buyPriceRelay.asObservable())
            .observeOn(MainScheduler.instance)
            .filter { !$0.0.isEmpty }
            .flatMap(amountStringAndSellPriceToUnits)
            .map { String(format: "%.2f", $0) }
            .bind(to: unitsTextField.rx.text)
            .disposed(by: bag)

        _ = Observable.combineLatest(unitsTextField.rx.text.orEmpty, viewModel.buyPriceRelay.asObservable())
            .observeOn(MainScheduler.instance)
            .filter { !$0.0.isEmpty }
            .flatMap(unitsStringAndSellPriceToAmount)
            .map { String(format: "%.2f", $0) }
            .bind(to: amountTextField.rx.text)
            .disposed(by: bag)
    }

     fileprivate func bindTextFieldsAndConfirmButton() {
        unitsTextField.rx.controlEvent(.editingChanged)
            .observeOn(MainScheduler.instance)
            .flatMap(checkUnitsTextFieldContent)
            .subscribe()
            .disposed(by: bag)

        amountTextField.rx.controlEvent(.editingChanged)
            .observeOn(MainScheduler.instance)
            .flatMap(checkAmountTextFieldContent)
            .subscribe()
            .disposed(by: bag)

        _ = Observable.combineLatest(unitsTextField.rx.text.orEmpty, amountTextField.rx.text.orEmpty)
            .observeOn(MainScheduler.instance)
            .map { !($0.0.isEmpty && $0.1.isEmpty) }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: bag)

        amountTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [unowned self] in
                self.addBorderToTextField(self.amountTextField)
            })
            .disposed(by: bag)

        unitsTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [unowned self] in
                self.addBorderToTextField(self.unitsTextField)
            })
            .disposed(by: bag)

        amountTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] in
                self.removeBorderFromTextField(self.amountTextField)
            })
            .disposed(by: bag)

        unitsTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [unowned self] in
                self.removeBorderFromTextField(self.unitsTextField)
            })
            .disposed(by: bag)
    }
}

extension GBPToBitcoinViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var acceptedCharacterString = "0123456789"
        if let currentText = textField.text, !currentText.contains(".") {
            acceptedCharacterString.append(".")
        }
        let acceptedCharacterSet = CharacterSet(charactersIn: acceptedCharacterString)
        let typedCharacterSet = CharacterSet(charactersIn: string)

        guard typedCharacterSet.isSubset(of: acceptedCharacterSet) else { return false }

        guard let currentText = textField.text else { return true }

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

    private func convertStringToAttributedString(_ priceString: String,
                                                 withColor colour: UIColor) -> NSAttributedString {
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

    fileprivate func amountStringAndSellPriceToUnits(_ tuple: (String, Float)) -> Observable<Float> {
        return Observable.create { observer in
            let amount = Float(tuple.0) ?? 0.0
            let units = amount / tuple.1
            observer.onNext(units)
            return Disposables.create()
        }
    }

    fileprivate func unitsStringAndSellPriceToAmount(_ tuple: (String, Float)) -> Observable<Float> {
        return Observable.create { observer in
            let amount = Float(tuple.0) ?? 0.0
            let units = amount * tuple.1
            observer.onNext(units)
            return Disposables.create()
        }
    }

    fileprivate func checkAmountTextFieldContent() -> Observable<Void> {
        if let amountText = amountTextField.text, amountText.isEmpty {
            unitsTextField.text = ""
        }
        return Observable.empty()
    }

    fileprivate func checkUnitsTextFieldContent() -> Observable<Void> {
        if let unitsText = unitsTextField.text, unitsText.isEmpty {
            amountTextField.text = ""
        }
        return Observable.empty()
    }

    fileprivate func addBorderToTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 4.0
        textField.layer.borderColor = Color.blue.cgColor
    }

    fileprivate func removeBorderFromTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 0.0
    }
}
