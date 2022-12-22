//
//  ViewController.swift
//  Freight Frenzy App
//
//  Created by Macbook on 24/11/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // TEST
        logoImageView.setValue(UIImage(named: "logo.png"), forKey: "image")
      
    }
    


}


