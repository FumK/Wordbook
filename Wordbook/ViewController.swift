//
//  ViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//
// 正答率フィルタをかけている際、問題がなくなってしまうと受けわたすデータがなくなってしまい、エラーとなる。。

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // テスト開始が押された場合
        if segue.identifier == "goTest" {
            // CSV読み込み
            WordbookDataManager.sharedInstance.loadWordbook()
            // 遷移先情報ゲット
            guard let testViewController = segue.destination as? TestViewController else {
                return
            }
        
        // 次に表示する単語の準備
            guard let wordbookData = WordbookDataManager.sharedInstance.nextWord() else {
                return
            }
            
        //　単語帳自体を吸い出し
//            let shuffledWordbookDataArray = WordbookDataManager.sharedInstance.shuffledWordbookDataArray
            let filteredShuffledWordbookDataArray = WordbookDataManager.sharedInstance.filteredShuffledWordbookDataArray
            let otherArray = WordbookDataManager.sharedInstance.otherArray

            
        // 値受け渡し
            testViewController.wordbookData = wordbookData
//            testViewController.shuffledWordbookDataArray = shuffledWordbookDataArray
            testViewController.filteredShuffledWordbookDataArray = filteredShuffledWordbookDataArray
            testViewController.otherArray = otherArray
            
        } else if segue.identifier == "goWordbook" {
            // CSV読み込み
            WordbookDataManager.sharedInstance.loadWordbook()
            
            guard let navigationViewController = segue.destination as? UINavigationController else {
                return
            }
            
            // 遷移
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

