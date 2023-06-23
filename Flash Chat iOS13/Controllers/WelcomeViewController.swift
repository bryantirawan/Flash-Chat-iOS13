//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    //gets rid of navigation bar at welcome screen
    override func viewWillAppear(_ animated: Bool) {
        //whenever overriding these UIview functions always call super. We do so with viewWillDisappear as well as viewDidLoad
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    //retrieves navigation bar once we pass welcome screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// Replacedd with CLTypingLabel library
//        titleLabel.text = ""
//        var charIndex = 0
//        let titleText = "⚡️FlashChat"
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(charIndex), repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            charIndex += 1
//        }
        
        titleLabel.text = K.appName
        
        
    }
}
