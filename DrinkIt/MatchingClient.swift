//
//  MatchingClient.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MatchingClient: MatchingHandler {
    var browser:MCNearbyServiceBrowser!
    var foundHosts = [MCPeerID]()
    var foundHostsDidChange:(()->())?

    override init() {
        super.init()

        browser = MCNearbyServiceBrowser(peer: localPeerID,
                                         serviceType: serviceType)

        browser.delegate = self
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
    }

    func invitePeer(peerID:MCPeerID) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }

}

extension MatchingClient : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        print("find peer \(peerID)")
        
        DispatchQueue.main.async {
            if (!self.foundHosts.contains(peerID)) {
                self.foundHosts.append(peerID)
                self.foundHostsDidChange?()
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        print("lost peer \(peerID)")
    }
}
