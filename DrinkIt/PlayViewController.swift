//
//  PlayViewController.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import MBProgressHUD

class PlayViewController: UIViewController {

    @IBOutlet weak var dealingButton: UIButton!
    @IBOutlet weak var countDonwLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!

    var deck = Deck()
    var card:String?
    var hud:MBProgressHUD?
    var isReconnceting = false
    var isOver = false
    
    var matchingServer:MatchingServer? {
        didSet {
            if let matchingServer = matchingServer {
            
            }
        }
    }
    
    var matchingClient:MatchingClient? {
        didSet {
            if let matchingClient = matchingClient {
                matchingClient.delegate = self
            }
        }
    }

    var countDownTimer:Timer? {
        willSet {
            countDownTimer?.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dealingButton.isHidden = matchingClient != nil
        dealingButton.di_applyDefaultButtonStyle()
        backButton.di_applyDefaultButtonStyle()
        countDonwLabel.font = UIFont.di_actionManFont(size: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        countDownTimer = nil
    }
    
    deinit {
        if let matchingServer = matchingServer {
            matchingServer.endGame()
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func actionDealing(_ sender: Any) {
        if let matchingServer = matchingServer {
            card = deck.randomDraw().toString()
            matchingServer.startDealing(deck: deck)
            dealingButton.isHidden = true
            startCountDown()
        }
    }
    
    func startCountDown() {
        cardImageView.image = UIImage(named: "Back")
        countDownTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDown), userInfo: NSDate(), repeats: true)
    }
    
    func countDown(timer:Timer) {
        guard let _ = countDownTimer, let date = countDownTimer?.userInfo as? Date else {
            return
        }

        let timePassed = -date.timeIntervalSinceNow

        if timePassed > 3.5 {
            countDownTimer = nil
            countDonwLabel.isHidden = true
            
            if matchingServer != nil {
                dealingButton.isHidden = false
            }
            if let card = card {
                cardImageView.image = UIImage(named: card)
            }
        } else {
            countDonwLabel.isHidden = false
            let time = max(0, UInt( ceil( 3.0 - timePassed ) ))
            countDonwLabel.text = "\(time)"
        }
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

extension PlayViewController : MatchingClientDelegate {
    
    func matchingClient(client:MatchingClient, didGetCard card:String) {
        self.card = card
        startCountDown()
    }
    
    func matchingClientShouldEndGame(client:MatchingClient) {
        isOver = true
        showAlert(title: "Game Over", message: "Host leaves the game!") { 
            let _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func reconnect() {
        guard let client = matchingClient else {
            return
        }
        
        isReconnceting = true
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Connecting..."
        self.hud = hud
        
        client.reinviteLastPeer()
    }
    
    func matchingClient(client: MatchingClient, didChangeState state: MCSessionState) {
        
//        if isOver {
//            return
//        }
//        
//        if state == .connected && self.isReconnceting {
//            guard let hud = hud else { return }
//            hud.label.text = "Connection Success!"
//            hud.hide(animated: true, afterDelay: 0.5)
//            isReconnceting = false
//            
//        } else if state == .notConnected {
//            
//            let title = isReconnceting ? "Reconnect Fails" : "Disconnected"
//            let message = isReconnceting ? "Do you want to retry?" : "Do you want to reconnect?"
//            
//            showAlert(title: title, message: message, ok: {
//                self.reconnect()
//            }, cancel: {
//                let _ = self.navigationController?.popToRootViewController(animated: true)
//            })
//            
//        }
    }

    
}
