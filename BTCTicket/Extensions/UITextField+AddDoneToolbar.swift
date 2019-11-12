//
//  UITextField+AddDoneToolbar.swift
//  BTCTicket
//
//  Created by Javid Sheikh on 12/11/2019.
//  Copyright © 2019 Quaxo Digital. All rights reserved.
//

import UIKit

extension UITextField {
    func addDoneToolbar() {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }

    @objc func doneButtonTapped() { resignFirstResponder() }
}
