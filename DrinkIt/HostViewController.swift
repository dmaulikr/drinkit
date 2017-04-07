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
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    let matchingServer = MatchingServer()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupMatchingServer()
        
        titleLabel.di_applyDefaultTitleLabelStyle()
        startButton.di_applyDefaultButtonStyle()
        backButton.di_applyDefaultButtonStyle()
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
        
        performSegue(withIdentifier: "Play", sender: nil)
    }
    
    func setupMatchingServer() {
        matchingServer.delegate = self
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let playViewController = segue.destination as? PlayViewController {
            playViewController.matchingServer = matchingServer
        }
    }

}

extension HostViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        let peerID = matchingServer.connectedClients[indexPath.row]
        
        cell.textLabel?.text = "\(peerID.displayName)"
        cell.textLabel?.di_applyDefaultTitleLabelStyle()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingServer.connectedClients.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension HostViewController : MatchingServerDelegate {
    func matchingServer(server: MatchingServer, clientsDidChange clients: [MCPeerID]) {
        self.tableView.reloadData()
    }
}
