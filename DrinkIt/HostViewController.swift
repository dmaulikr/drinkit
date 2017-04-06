//
//  HostViewController.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class HostViewController: UIViewController {
    
    let matchingServer = MatchingServer()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        matchingServer.startAdvertising()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        matchingServer.stopAdvertising()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionStart(_ sender: Any) {
        matchingServer.startGame()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

