//
//  AddDetailViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/05/06.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit


class AddDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    

    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var meaning1TextField: UITextField!
    @IBOutlet weak var meaning2TextField: UITextField!
    @IBOutlet weak var meaning3TextField: UITextField!
    @IBOutlet weak var classificationTextField: UITextField!
    @IBOutlet weak var exampleTextView: UITextView!
    @IBOutlet weak var exampleTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //最初に単語を選択する
        wordTextField.delegate = self
        wordTextField.becomeFirstResponder()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let avcParent = self.parent as! AddViewController
        avcParent.saveContainerViewRefference(vc: self)
    }
    
    //Returnキーを押したら次のフィールドへ移動
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wordTextField.resignFirstResponder()
        if textField == wordTextField {
            meaning1TextField.becomeFirstResponder()
        } else if textField == meaning1TextField {
            meaning2TextField.becomeFirstResponder()
        } else if textField == meaning2TextField {
            meaning3TextField.becomeFirstResponder()
        } else if textField == meaning3TextField {
            classificationTextField.becomeFirstResponder()
        } else if textField == classificationTextField {
            exampleTextView.becomeFirstResponder()
        } else {
            return true
        }
        return false
    }
    
    // Keyboardを消えるようにする
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if wordTextField.isFirstResponder {
            wordTextField.resignFirstResponder()
        } else if meaning1TextField.isFirstResponder {
            meaning1TextField.resignFirstResponder()
        } else if meaning1TextField.isFirstResponder {
            meaning2TextField.resignFirstResponder()
        } else if meaning2TextField.isFirstResponder {
            meaning3TextField.resignFirstResponder()
        } else if meaning3TextField.isFirstResponder {
            meaning3TextField.resignFirstResponder()
        } else if classificationTextField.isFirstResponder {
            classificationTextField.resignFirstResponder()
        } else if exampleTextView.isFirstResponder {
            exampleTextView.resignFirstResponder()
        }
    }
    
    //例文の文字を消せるようにする
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        exampleTextLabel.isHidden = true
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if exampleTextView.text.isEmpty == true {
            exampleTextLabel.isHidden = false
        }
    }
    
    
    
}
