//
//  TestViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    //問題
    var wordbookData: WordbookData!
//    var shuffledWordbookDataArray = [WordbookData]()
    var filteredShuffledWordbookDataArray = [WordbookData]()
    var otherArray = [WordbookData]()
    //問題数カウント用
    var testNumberCount: Int = 1
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var countNumberLabel: UILabel!
    @IBOutlet weak var percentNumberLabel: UILabel!
    @IBOutlet weak var testNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //単語表示
        wordLabel.text = wordbookData.word
        //正答率表示
        countNumberLabel.text = String(wordbookData.numberOfCorrect) + "/" +  String(wordbookData.numberOfAppearance)
        var correctPercent: Float = 0
        if wordbookData.numberOfAppearance != 0 {
            correctPercent = Float(wordbookData.numberOfCorrect) / Float(wordbookData.numberOfAppearance) * 100
        }
        percentNumberLabel.text = String(format: "%.1f ", correctPercent)
        //問題数表示
        testNumberLabel.text = String(testNumberCount) + "/" + String(WordbookDataManager.sharedInstance.filteredShuffledWordbookDataArray.count)
    }
    
    //わかったボタン押したとき
    @IBAction func understandButton(_ sender: Any) {
        //正解カウントと問題カウントをインクリメントして格納する
//        shuffledWordbookDataArray[testNumberCount-1].numberOfAppearance += 1
//        shuffledWordbookDataArray[testNumberCount-1].numberOfCorrect += 1
        filteredShuffledWordbookDataArray[testNumberCount-1].numberOfAppearance += 1
        filteredShuffledWordbookDataArray[testNumberCount-1].numberOfCorrect += 1
        //問題数インクリメント
        testNumberCount += 1
        //次の画面へ
        goNextTest()
    }
    
    //わかんなかったボタン押したとき
    @IBAction func notUnderstandButton(_ sender: Any) {
        
        //問題カウントをインクリメントして格納する
//        shuffledWordbookDataArray[testNumberCount-1].numberOfAppearance += 1
        filteredShuffledWordbookDataArray[testNumberCount-1].numberOfAppearance += 1
        //問題数インクリメント
        testNumberCount += 1
        //つぎの画面へ
        goNextTest()
    }
    
    //Doneボタンを押したとき
    @IBAction func doneButton(_ sender: Any) {
        //トップ画面に戻る
        if let topViewController = storyboard?.instantiateViewController(identifier: "top") as? ViewController {
            //遷移
            present(topViewController, animated: true, completion: nil)
        }
    }
    
    
    //次の遷移指示
    func goNextTest() {
        //次の問題あるか確認
        guard let nextTest = WordbookDataManager.sharedInstance.nextWord() else {
            //なかったら配列を保存しつつトップ画面に戻る
            //保存
            saveCSV(targetArray: filteredShuffledWordbookDataArray + otherArray)
            //トップへ遷移
            if let topViewController = storyboard?.instantiateViewController(identifier: "top") as? ViewController {
                //遷移
                present(topViewController, animated: true, completion: nil)
            }
            return
        }
        
        //あったら次の問題に行く
        if let nextTestViewController = storyboard?.instantiateViewController(identifier: "test") as? TestViewController {
            //次の問題を受け渡し
            nextTestViewController.wordbookData = nextTest
            //問題数を受け渡し
            nextTestViewController.testNumberCount = testNumberCount
            //問題集を受け渡し
//            nextTestViewController.shuffledWordbookDataArray = shuffledWordbookDataArray
            nextTestViewController.filteredShuffledWordbookDataArray = filteredShuffledWordbookDataArray
            nextTestViewController.otherArray = otherArray
            //遷移
            present(nextTestViewController, animated: false, completion: nil)
        }
    }
    
    // CSVに保存する
    func saveCSV(targetArray: [WordbookData]) {
        //初期化
        var forSaveDataSourceArrayJoined = [String]()
        var forSaveDataSource: String
        //単語帳に入ってる各単語と意味群を配列に格納し直す
        for counter in 0..<targetArray.count {
            //初期化
            var forSaveDataSourceArray = [String]()
            forSaveDataSourceArray.append(String(targetArray[counter].wordNumber))
            forSaveDataSourceArray.append(targetArray[counter].word)
            forSaveDataSourceArray.append(targetArray[counter].meaning1!)
            forSaveDataSourceArray.append(targetArray[counter].meaning2!)
            forSaveDataSourceArray.append(targetArray[counter].meaning3!)
            forSaveDataSourceArray.append(targetArray[counter].exampleSentence!)
            forSaveDataSourceArray.append(targetArray[counter].classification!)
            forSaveDataSourceArray.append(String(targetArray[counter].numberOfAppearance))
            forSaveDataSourceArray.append(String(targetArray[counter].numberOfCorrect))
            // 結合する
            forSaveDataSourceArrayJoined.append(forSaveDataSourceArray.joined(separator: ","))
        }
        // 配列を文字列にする
        forSaveDataSource = forSaveDataSourceArrayJoined.joined(separator: "\n")

        // CSVに保存
        // パスを指定
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("wordbook.csv")
        // let path = Bundle.main.path(forResource: "wordbook", ofType: "csv")!

        //ファイルを出力
//        do {
//            //ファイルを出力する。(
//            //try FileManager.default.removeItem(atPath: path)
//            try forSaveDataSource.write(toFile: path, atomically: false, encoding: String.Encoding.utf8 )
//        } catch {
//            print(error)
//            //ファイルを出力
//        }
        do {
            //ファイルを出力する。(
            //try FileManager.default.removeItem(at: documentPath)
            try forSaveDataSource.write(to: documentPath, atomically: false, encoding: String.Encoding.utf8 )
        } catch {
            print(error)
            print("Documentに保存されませんでした")
        }
        
    }
}
