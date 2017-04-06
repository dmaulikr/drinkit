//
//  MatchingServer.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MatchingServerDelegate {
    func matchingServer(server:MatchingServer,
                        clientsDidChange clients:[MCPeerID])
}

class MatchingServer: MatchingHandler {

    var advertiser:MCNearbyServiceAdvertiser!
    var connectedClients = [MCPeerID]()
    var delegate:MatchingServerDelegate?

    override init() {
        super.init()

        advertiser = MCNearbyServiceAdvertiser(peer: localPeerID,
                                               discoveryInfo: nil,
                                               serviceType: serviceType)
        
        advertiser.delegate = self
    }

    func startAdvertising() {
        advertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }
    
    func startGame() {
        session.sendMessage(message: "Start Game", peers: connectedClients)
    }
}

extension MatchingServer: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true, session)
        
        connectedClients.append(peerID)
        
        DispatchQueue.main.async {
            self.delegate?.matchingServer(server: self, clientsDidChange: self.connectedClients)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
    }
}
