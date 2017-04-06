//
//  MatchingServer.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MatchingHelper: NSObject {
    
    let serviceType = "drinkit-service"
    
    let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    var advertiser:MCNearbyServiceAdvertiser
    var browser:MCNearbyServiceBrowser
    
    var foundHosts = [MCPeerID]()
    var connectedClients = [MCPeerID]()
    
    var foundHostsDidChange:(()->())?
    
    var session:MCSession
    
    override init() {
        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID,
                                               discoveryInfo: nil,
                                               serviceType: serviceType)

        browser = MCNearbyServiceBrowser(peer: localPeerID,
                                             serviceType: serviceType)
        
        session = MCSession(peer: localPeerID,
                            securityIdentity: nil,
                            encryptionPreference: .none)

        super.init()
        
        advertiser.delegate = self
        browser.delegate = self
        session.delegate = self
    }
    
    func startAdvertising() {
        advertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
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
    
    func startGame() {
        session.sendMessage(message: "Start Game", peers: connectedClients)
    }
}

extension MatchingHelper: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true, session)
        
        connectedClients.append(peerID)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
    }
}

extension MatchingHelper : MCNearbyServiceBrowserDelegate {
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

extension MCSession {
    func sendMessage(message:String, peers:[MCPeerID]) {
        if let data = message.data(using: .utf8) {
            do {
                try self.send(data, toPeers: peers, with: .reliable)
            } catch {
                print("[Error] \(error)")
            }
        }
    }
}

extension MatchingHelper: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("didChange state \(state)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message = String(data: data, encoding: .utf8)
        
        print("didReceive \(message) from \(peerID)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
}
