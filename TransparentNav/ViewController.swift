//
//  ViewController.swift
//  TransparentNav
//
//  Created by Maple on 2018/12/7.
//  Copyright © 2018 Jarmom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func action(_ sender: Any) {
        present(UINavigationController(rootViewController: TransparentViewController()), animated: true, completion: nil)
    }
    
}

