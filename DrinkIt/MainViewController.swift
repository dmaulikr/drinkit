//
//  ViewController.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var hostGameButton: UIButton!
    @IBOutlet weak var joinGameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupButtons()
    }
    
    func setupButtons() {
        hostGameButton.di_applyDefaultButtonStyle()
        joinGameButton.di_applyDefaultButtonStyle()
    }

}

