//
//  ViewController.swift
//  Flash Chat
//
//  Created by Shikhar Kumar on 1/19/20.
//  Copyright © 2020 Shikhar Kumar. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        var i = 0.0
        for char in K.appName {
            i += 1
            Timer.scheduledTimer(withTimeInterval: 0.1 * i, repeats: false) { (timer) in
                self.titleLabel.text?.append(char)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

