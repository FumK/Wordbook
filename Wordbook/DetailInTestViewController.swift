//
//  DetailInTestViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/01/19.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class DetailInTestViewController: UIViewController {

    var wordbookData: WordbookData!
    
    //ラベル情報
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var meaning1Label: UILabel!
    @IBOutlet weak var meaning2Label: UILabel!
    @IBOutlet weak var meaning3Label: UILabel!
    @IBOutlet weak var exampleSentenceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wordLabel.text = wordbookData.word
        meaning1Label.text = wordbookData.meaning1
        meaning2Label.text = wordbookData.meaning2
        meaning3Label.text = wordbookData.meaning3
        exampleSentenceLabel.text = wordbookData.exampleSentence
    }
    

    @IBAction func nextTestButton(_ sender: Any) {
        //画面遷移
        let backtvc = storyboard?.instantiateViewController(identifier: "test") as! TestViewController
        present(backtvc, animated: true, completion: nil)
        
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
