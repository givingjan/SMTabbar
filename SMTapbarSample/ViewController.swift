//
//  ViewController.swift
//  SMTapbarSample
//
//  Created by JaN on 2017/2/13.
//  Copyright © 2017年 Yu-Chun-Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var m_text: UILabel!

    @IBOutlet var m_topBar: SMTabbar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let list : [String] = ["News","About","Works","Blog","Link","Contact Us"]
        self.m_topBar.buttonWidth = 90
        self.m_topBar.moveDuration = 0.4
        self.m_topBar.fontSize = 16.0
        self.m_topBar.configureSMTabbar(titleList: list) { (index) -> (Void) in
            self.m_text.text = list[index]
            print(index)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

