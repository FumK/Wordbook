//
//  WordbookViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class WordbookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //データ受け取り
    var wordbookDataArray = [WordbookData]()
    var wordList = [String]()
    //+ボタンを宣言
    var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ソートする
        wordbookDataArray = wordbookDataArray.sorted(by: {$0.word < $1.word})
        // 単語を抜き出す
        for counter in 0..<wordbookDataArray.count {
            wordList.append(wordbookDataArray[counter].word)
        }
        
        //+ボタンの初期化
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        //+ボタンを追加
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    
    //+ボタンを押した時の対応
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
//        let addViewController = storyboard!.instantiateViewController(identifier: "add") as! AddViewController
//        self.present(addViewController, animated: true, completion: nil)
        transactionToAddViewController()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        
        
        let wordTitle = wordList[indexPath.row]
//        print(wordTitle)
        cell.textLabel?.text = wordTitle
        
        
        return cell
    }
    
    //Cellをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //値渡し準備
        let selectedNumber:Int = indexPath.row
        //遷移準備
        let wordDetailViewController = storyboard?.instantiateViewController(withIdentifier: "detail") as! WordDetailViewController
        //セルの選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        //ここに遷移処理を書く
        self.navigationController?.pushViewController(wordDetailViewController, animated: true)
        wordDetailViewController.selectedNumber = selectedNumber
        wordDetailViewController.wordbookDataArray = wordbookDataArray
    }
    
    //更新用
    func transactionToAddViewController() {
        let addViewController = storyboard?.instantiateViewController(identifier: "add") as! AddViewController
        addViewController.presentationController?.delegate = self
        present(addViewController, animated: true, completion: nil)
    }
        
}

//更新用
extension WordbookViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        let vc = storyboard!.instantiateViewController(withIdentifier: "add") as! AddViewController
//        wordbookDataArray = vc.wordbookDataArray
        //CSV読み込み
        wordbookDataArray.removeAll()//以前の値を一旦消去
        wordList.removeAll()
        WordbookDataManager.sharedInstance.loadWordbook()
        wordbookDataArray = WordbookDataManager.sharedInstance.wordbookDataArray
        
        //ViewDidLoadと同じ
        //ソートする
        wordbookDataArray = wordbookDataArray.sorted(by: {$0.word < $1.word})
        // 単語を抜き出す
        for counter in 0..<wordbookDataArray.count {
            wordList.append(wordbookDataArray[counter].word)
        }
        print(wordList)
        //更新
        tableView.reloadData()
    }
}
