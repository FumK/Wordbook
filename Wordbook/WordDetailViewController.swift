//
//  WordDetailViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/19.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class WordDetailViewController: UIViewController {
    
    //データ受け取り
    var selectedNumber: Int!
    var wordbookDataArray = [WordbookData]()
    
    //ラベル情報
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaning1Label: UILabel!
    @IBOutlet weak var meaning2Label: UILabel!
    @IBOutlet weak var meaning3Label: UILabel!
    @IBOutlet weak var exampleSentenceLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var correctRatioLabel: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //単語帳のデータを取得
        let wordbookData = wordbookDataArray[selectedNumber]
        
        //各ラベルに反映
        wordLabel.text = wordbookData.word
        meaning1Label.text = wordbookData.meaning1
        meaning2Label.text = wordbookData.meaning2
        meaning3Label.text = wordbookData.meaning3
        exampleSentenceLabel.text = wordbookData.exampleSentence
        numberLabel.text = String(wordbookData.numberOfCorrect) + "/" + String(wordbookData.numberOfAppearance)
        if wordbookData.numberOfAppearance == 0 {
            correctRatioLabel.text = "未実施"
        } else {
            correctRatioLabel.text = String(format: "%.1f ",Float(wordbookData.numberOfCorrect) / Float(wordbookData.numberOfAppearance) * 100) + " %"
        }
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
