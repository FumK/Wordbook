//
//  TestPageViewController.swift
//  Wordbook
//
//  Created by Fumiaki on 2020/05/04.
//  Copyright © 2020 Fumiaki Kobayashi. All rights reserved.
//

import UIKit

class TestPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    //問題
    var wordbookData: WordbookData!
    var filteredShuffledWordbookDataArray = [WordbookData]()
    var otherArray = [WordbookData]()
    //問題数カウント用
    var testNumberCount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 最初の画面へ値渡し
        let testViewController = storyboard!.instantiateViewController(withIdentifier: "test") as! TestViewController
        testViewController.wordbookData = wordbookData
        testViewController.filteredShuffledWordbookDataArray = filteredShuffledWordbookDataArray
        testViewController.otherArray = otherArray
        testViewController.testNumberCount = testNumberCount
        
        // 最初の遷移画面を決める
        self.setViewControllers([testViewController], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: DetailInTestViewController.self) {
            let testViewController = storyboard!.instantiateViewController(withIdentifier: "test") as! TestViewController
            testViewController.wordbookData = wordbookData
            return testViewController
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: TestViewController.self) {
            let detailIntestViewController = storyboard!.instantiateViewController(withIdentifier: "detailInTest") as! DetailInTestViewController
            detailIntestViewController.wordbookData = wordbookData
            return detailIntestViewController
        } else {
        return nil
        }
    }

}
