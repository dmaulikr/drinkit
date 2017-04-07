//
//  JoinViewController.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class JoinViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let matchingClient = MatchingClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupMatchingClient()
        
        backButton.di_applyDefaultButtonStyle()
        titleLabel.di_applyDefaultTitleLabelStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        matchingClient.startBrowsing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        matchingClient.stopBrowsing()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func setupMatchingClient() {
        matchingClient.delegate = self
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playViewController = segue.destination as? PlayViewController {
            playViewController.matchingClient = matchingClient
        }
    }
}

extension JoinViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let peerID = matchingClient.foundHosts[indexPath.row]
        matchingClient.invitePeer(peerID: peerID)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        let peerID = matchingClient.foundHosts[indexPath.row]

        cell.textLabel?.text = peerID.displayName
        cell.textLabel?.di_applyDefaultTitleLabelStyle()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingClient.foundHosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension JoinViewController : MatchingClientDelegate {
    func matchingClient(client:MatchingClient,
                        hostsDidChange hosts:[MCPeerID]) {
        tableView.reloadData()
    }
    func matchingClient(client:MatchingClient, didGetCard card:String) {
    }
    func matchingClientShouldStartGame(client:MatchingClient) {
        performSegue(withIdentifier: "Play", sender: nil)
    }
    func matchingClientShouldEndGame(client:MatchingClient) {
        
    }
}
