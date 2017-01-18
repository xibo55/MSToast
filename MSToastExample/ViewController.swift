//
//  ViewController.swift
//  MSToast
//
//  Created by Michael Shang on 1/12/17.
//  Copyright © 2017 Michael Shang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MSToast.showToast(self.view, text: "Automatically showing this toast upon launch", duration: 2.0);

    }
    
    
    
    @IBAction func showMessage(_ sender: Any) {
        MSToast.showToast(self.view, text: "Tap to show this toast for 2 seconds", duration: 2.0);
    }
    

}

