//
//  SettingViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var correctThresholdTextField: UITextField!
    // 記録準備
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初期値を定義
        userDefaults.register(defaults: ["threshold" : 1])
        //値を取り出す
        let threshold = userDefaults.float(forKey: "threshold")
        //TextFieldに反映
        correctThresholdTextField.text = String(Int(threshold*100))
        
    }
    
    // Keyboardを消えるようにする
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if correctThresholdTextField.isFirstResponder {
            correctThresholdTextField.resignFirstResponder()
        }
    }
    
    //コピペ禁止
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }
        return true
    }
    
    
    // Saveと同時に保存する
    @IBAction func saveButton(_ sender: Any) {
        //入力された値を抜き出す
        var threshold:Float = 0
        if correctThresholdTextField.text! != "" {
            let tempstr = correctThresholdTextField.text!
            threshold = Float(tempstr)!
        }
        let thresholdPercent = threshold / 100
        
        //100%以上の時の処理
        if thresholdPercent > 1 {
            //Alert画面の追加
            let alertController = UIAlertController(title: "Save Error", message: "閾値は100%以内に設定して下さい", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            
        } else { // 100%以下は記録する
            
            print(thresholdPercent)
            //記録
            userDefaults.set(thresholdPercent, forKey: "threshold")
            //同期
            userDefaults.synchronize()
            
            //Alert画面の追加
            let alertController = UIAlertController(title: "Save完了", message: "保存しました。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            
        }
    }
    
    //正答率リセットボタン
    @IBAction func resetButton(_ sender: Any) {
        //Alert画面を表示
        let alertController = UIAlertController(title: "注意", message: "本当に正答率をリセットしますか？", preferredStyle: .alert)
        //OKの時
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            
            //CSV読み込み
            WordbookDataManager.sharedInstance.loadWordbook()
            //単語帳を取得
            let wordbookDataArray = WordbookDataManager.sharedInstance.wordbookDataArray
            //正答率をゼロに置き換え
            for (i,_) in wordbookDataArray.enumerated() {
                wordbookDataArray[i].numberOfAppearance = 0
                wordbookDataArray[i].numberOfCorrect = 0
            }
            //CSVに保存
            WordbookDataManager.sharedInstance.saveCSV(targetArray: wordbookDataArray)
        })
        //キャンセルの時
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        
        //ボタンを追加
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        //表示実行
        present(alertController, animated: true)
    }
    
    //単語帳リセットボタン
    
    @IBAction func resetWordbookButton(_ sender: Any) {
        print("動いてる？")
        //Alert画面を表示
        let alertController = UIAlertController(title: "注意", message: "本当に単語帳をリセットしますか？", preferredStyle: .alert)
        //OKの時
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action: UIAlertAction!) -> Void in
            
            //削除処理
            var path: String = ""
            do {
                //ユーザーが保存したCSVファイルのパス
                let csvFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/wordbook" + ".csv"
                path = csvFilePath
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("消せなかったよ！！！")
            }
            
        })
        //キャンセルの時
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        
        //ボタンを追加
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        //表示実行
        present(alertController, animated: true)
    }
    
}



