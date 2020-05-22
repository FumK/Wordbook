//
//  DictionaryManager.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/18.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import Foundation

class WordbookData {
    //固有番号
    var wordNumber: Int
    //単語
    var word: String
    //意味
    var meaning1: String?
    var meaning2: String?
    var meaning3: String?
    //例文
    var exampleSentence: String?
    //分類
    var classification: String?
    //表示回数
    var numberOfAppearance: Int
    //正解回数
    var numberOfCorrect: Int
    
    //CSVデータから初期化
    init(wordbookSourceDataArray: [String]){
        wordNumber = Int(wordbookSourceDataArray[0])!
        word = wordbookSourceDataArray[1]
        meaning1 = wordbookSourceDataArray[2]
        meaning2 = wordbookSourceDataArray[3]
        meaning3 = wordbookSourceDataArray[4]
        exampleSentence = wordbookSourceDataArray[5]
        classification = wordbookSourceDataArray[6]
        if wordbookSourceDataArray[7].isEmpty { //何も入ってなかった時の処理
            numberOfAppearance = 0
        } else {
            numberOfAppearance = Int(wordbookSourceDataArray[7])!
        }
        if wordbookSourceDataArray[8].isEmpty { //何も入ってなかった時の処理
            numberOfCorrect = 0
        } else {
            numberOfCorrect = Int(wordbookSourceDataArray[8])!
        }
    }
    
}

class WordbookDataManager {
    //シングルトン
    static let sharedInstance = WordbookDataManager()
    //データを配列に格納
    var wordbookDataArray = [WordbookData]()
    //出題数カウント用
    var nowWordIndex: Int = 0
    var shuffledWordbookDataArray = [WordbookData]()
    var filteredShuffledWordbookDataArray = [WordbookData]()
    var otherArray = [WordbookData]()

    private init() {
        
    }
    
    //CSVから単語帳を読みに行く
    func loadWordbook() {
        //すべてを消去・初期化
        wordbookDataArray.removeAll()
        shuffledWordbookDataArray.removeAll()
        filteredShuffledWordbookDataArray.removeAll()
        otherArray.removeAll()
        nowWordIndex = 0
        
        var path: String = ""
        
        //CSVを読みに行く
        do {
            //ユーザーが保存したCSVファイルのパス
            let csvFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/wordbook" + ".csv"
            path = csvFilePath
//            print("1 通過・path -> \(path)")
            if (FileManager.default.fileExists(atPath: path) == false) {
                //ユーザーが保存したCSVファイルが無い場合は、初期CSVファイルから読み込む。
                path = Bundle.main.path(forResource: "wordbook", ofType: "csv")!
            }
        }
        
//        print(path)
//        guard let csvFilePath = Bundle.main.path(forResource: "wordbook", ofType: "csv") else {
//            print("csvFilePath")
//            return
//        }


        do {
            let csvStringData = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                        
            csvStringData.enumerateLines(invoking: { (line, stop) in
                let wordbookSourceDataArray = line.components(separatedBy: ",")
                let wordbookData = WordbookData(wordbookSourceDataArray: wordbookSourceDataArray)
                self.wordbookDataArray.append(wordbookData)
            })
            
        } catch let error {
            print("csvファイル読み込みにエラーが発生しました:\(error)")
            return
            
        }
        
        //シャッフルさせる
        shuffledWordbookDataArray = wordbookDataArray.shuffled()
        
        //正答率フィルタをかける
        
        
        //設定値を読み込み
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["threshold" : 1]) //初期値を定義
        let settingThreshold = userDefaults.float(forKey: "threshold")
        
        for (_,dataArray) in shuffledWordbookDataArray.enumerated() {
            var correctAnswerRatio:Float = 0
            if dataArray.numberOfAppearance != 0 {
                correctAnswerRatio = Float(dataArray.numberOfCorrect) / Float(dataArray.numberOfAppearance)
            }
            if correctAnswerRatio <= settingThreshold { // 正答率フィルタ
                filteredShuffledWordbookDataArray.append(dataArray)
            } else {
                // 正答率フィルタで除外されたもの、保存用に使いたい
                otherArray.append(dataArray)
            }
        }
        
    }
    
    //次のテスト画面のための単語準備
    func nextWord() -> WordbookData? {
        if nowWordIndex < filteredShuffledWordbookDataArray.count { //正答率フィルタありバージョン
            let nextWord = filteredShuffledWordbookDataArray[nowWordIndex]
                nowWordIndex += 1
            return nextWord
        }
        return nil
    }
    
    //CSVに保存する
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

        do {
            //ファイルを出力する。
            try forSaveDataSource.write(to: documentPath, atomically: false, encoding: String.Encoding.utf8 )
        } catch {
            print(error)
            print("Documentに保存されませんでした")
        }
    }
}
