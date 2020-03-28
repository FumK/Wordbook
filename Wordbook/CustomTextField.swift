//
//  CustomTextField.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/25.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return true
    }

}
