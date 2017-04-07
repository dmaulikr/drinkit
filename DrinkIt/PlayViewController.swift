//
//  PlayViewController.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class PlayViewController: UIViewController {

    @IBOutlet weak var dealingButton: UIButton!
    @IBOutlet weak var countDonwLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!

    var deck = Deck()
    var card:String?
    
    var matchingServer:MatchingServer? {
        didSet {
            if let matchingServer = matchingServer {
                matchingServer.delegate = self
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
        countDonwLabel.font = UIFont.di_actionManFont(size: 72)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
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

extension PlayViewController : MatchingServerDelegate {
    func matchingServer(server: MatchingServer, clientsDidChange clients: [MCPeerID]) {
    }
}

extension PlayViewController : MatchingClientDelegate {
    func matchingClient(client:MatchingClient,
                        hostsDidChange hosts:[MCPeerID]) {
    }
    func matchingClient(client:MatchingClient, didGetCard card:String) {
        self.card = card
        startCountDown()
    }
    func matchingClientShouldStartGame(client:MatchingClient) {
    }
    func matchingClientShouldEndGame(client:MatchingClient) {
    }
}
