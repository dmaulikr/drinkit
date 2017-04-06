//
//  MatchingServer.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MatchingHandler: NSObject {
    let serviceType = "drinkit-service"
    let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    var session:MCSession

    override init() {
        session = MCSession(peer: localPeerID,
                            securityIdentity: nil,
                            encryptionPreference: .none)

        super.init()
        session.delegate = self
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

extension MatchingHandler: MCSessionDelegate {
    
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
