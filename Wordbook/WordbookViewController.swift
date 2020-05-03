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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ソートする
        wordbookDataArray = wordbookDataArray.sorted(by: {$0.word < $1.word})
        // 単語を抜き出す
        for counter in 0..<wordbookDataArray.count {
            wordList.append(wordbookDataArray[counter].word)
        }
        
        print(wordList)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        
        
        let wordTitle = wordList[indexPath.row]
        print(wordTitle)
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
