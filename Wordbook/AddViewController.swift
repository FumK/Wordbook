//
//  AddViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/05/06.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    var addDetailVC: AddDetailViewController?
    var wordbookDataArray = [WordbookData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //キャンセルボタンを押した時
    @IBAction func cancelButton(_ sender: Any) {
        //単語帳を値渡し
        let preNC = self.presentingViewController as! UINavigationController
        let preVC = preNC.viewControllers[preNC.viewControllers.count - 1] as! WordbookViewController
//        let preVC = preNC.topViewController as! WordbookViewController
        preVC.wordbookDataArray = self.wordbookDataArray
        //更新
//        preVC.tableUpdate()
        //戻る
        self.dismiss(animated: true, completion: nil)
        
        print(addDetailVC?.exampleTextView.text)
        if let x = addDetailVC?.exampleTextView.text {
            let xx = x.replacingOccurrences(of: "\n", with: "!#%&").replacingOccurrences(of: ",", with: "@$^*")
            print(x)
            print(xx)
            let xxx = xx.replacingOccurrences(of: "!#%&", with: "\n").replacingOccurrences(of: "@$^*", with: ",")
            print(xxx)
        }
        
    }
    
    //登録ボタンを押した時
    @IBAction func registerButton(_ sender: Any) {
        //空欄判定
        if let word = addDetailVC?.wordTextField.text {
            if word.isEmpty == true {
            } else {
                //入力内容を取り出す
                let meaning1 = addDetailVC?.meaning1TextField.text!
                let meaning2 = addDetailVC?.meaning2TextField.text!
                let meaning3 = addDetailVC?.meaning3TextField.text!
                let classification = addDetailVC?.classificationTextField.text!
                let exampleSentence = addDetailVC?.exampleTextView.text!
                
                //CSVを読み込む
                WordbookDataManager.sharedInstance.loadWordbook()
                //読み込んだ単語帳を格納
                wordbookDataArray = WordbookDataManager.sharedInstance.wordbookDataArray
                //新規に入力されたデータを格納
                let dataNumber = wordbookDataArray.count + 1 // 総データ数に1加える
                var wordbookDataSourceArray:[String] = []
                wordbookDataSourceArray.append(String(dataNumber))
                wordbookDataSourceArray.append(word)
                wordbookDataSourceArray.append(meaning1!)
                wordbookDataSourceArray.append(meaning2!)
                wordbookDataSourceArray.append(meaning3!)
                wordbookDataSourceArray.append(exampleSentence!)
                wordbookDataSourceArray.append(classification!)
                wordbookDataSourceArray.append("0")
                wordbookDataSourceArray.append("0")
                
                print(wordbookDataSourceArray)
                
                //型に当てはめる
                let wordbookData = WordbookData(wordbookSourceDataArray: wordbookDataSourceArray)
                //単語帳に加える
                wordbookDataArray.append(wordbookData)
                //CSVに保存
                WordbookDataManager.sharedInstance.saveCSV(targetArray: wordbookDataArray)

                //アラート表示
                let alertController = UIAlertController(title: "登録完了", message: "単語を登録しました。", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true)
                
                //入力内容を消去する
                addDetailVC?.wordTextField.text = ""
                addDetailVC?.meaning1TextField.text = ""
                addDetailVC?.meaning2TextField.text = ""
                addDetailVC?.meaning3TextField.text = ""
                addDetailVC?.classificationTextField.text = ""
                addDetailVC?.exampleTextView.text = ""
            }
        }
        

//        }
    }
    
    // AddDetailVCから取り出す用
    func saveContainerViewRefference(vc:AddDetailViewController) {
        self.addDetailVC = vc
    }
    
}

//更新用
extension AddViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController =  presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
