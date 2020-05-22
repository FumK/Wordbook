//
//  ViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//
// 正答率フィルタをかけている際、問題がなくなってしまうと受けわたすデータがなくなってしまい、エラーとなる。。
// 対策として、wordBookDataがnilの時はアラートを出し遷移させない。＋遷移をStoryboardではなくコード上で行う。

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func testStartButton(_ sender: Any) {
        // CSV読み込み
        WordbookDataManager.sharedInstance.loadWordbook()
        
        // 遷移先情報ゲット
        let testPageViewController = storyboard!.instantiateViewController(withIdentifier: "pageView") as! TestPageViewController
        //Managerから各情報ゲット
        if let wordbookData = WordbookDataManager.sharedInstance.nextWord() {
            let filteredShuffledWordbookDataArray = WordbookDataManager.sharedInstance.filteredShuffledWordbookDataArray
            let otherArray = WordbookDataManager.sharedInstance.otherArray
            
            
            // 値受け渡し
            testPageViewController.wordbookData = wordbookData
            //                testViewController.shuffledWordbookDataArray = shuffledWordbookDataArray
            testPageViewController.filteredShuffledWordbookDataArray = filteredShuffledWordbookDataArray
            testPageViewController.otherArray = otherArray
            
            //画面遷移
            self.present(testPageViewController,animated:true, completion: nil)
            
        } else {
            //Alert画面を表示
            let alertController = UIAlertController(title: "エラー", message: "該当する単語が存在しません。\n「設定」より正答率を変更してください。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // リスト
        if segue.identifier == "goWordbook" {
            // CSV読み込み
            WordbookDataManager.sharedInstance.loadWordbook()
            
            guard let navigationViewController = segue.destination as? UINavigationController else {
                return
            }
            
            // 値受け渡し
            let vc = navigationViewController.topViewController as! WordbookViewController
            let wordbookDataArray = WordbookDataManager.sharedInstance.wordbookDataArray
            vc.wordbookDataArray = wordbookDataArray
            
        } else {
            // セッティング画面
        }
        
    }
    
    
    
    @IBAction func gotoTitle(_ segue: UIStoryboardSegue) {
    }
    
    
}

