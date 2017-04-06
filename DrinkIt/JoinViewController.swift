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
    
    @IBOutlet weak var tableView: UITableView!
    let matchingClient = MatchingClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        matchingClient.foundHostsDidChange = {
            self.tableView.reloadData()
        }
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

    @IBAction func actionBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
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

extension JoinViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let peerID = matchingClient.foundHosts[indexPath.row]
        matchingClient.invitePeer(peerID: peerID)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let peerID = matchingClient.foundHosts[indexPath.row]

        cell.textLabel?.text = peerID.displayName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingClient.foundHosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
