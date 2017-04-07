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
        session.sendMessage(message: MatchingMessage.startGame.rawValue, peers: connectedClients)
    }
    
    func endGame() {
        session.sendMessage(message: MatchingMessage.endGame.rawValue, peers: connectedClients)
    }
    
    func startDealing(deck:Deck) {
        
        connectedClients.forEach { (peerID) in
            let card = deck.randomDraw()
            
            let message = "\(MatchingMessage.startDealing.rawValue):\(card.toString())"
            
            session.sendMessage(message: message, peers: [peerID])
        }
    }

    override func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        DispatchQueue.main.async {
            if state == .connected {
                self.connectedClients.append(peerID)
                self.delegate?.matchingServer(server: self, clientsDidChange: self.connectedClients)
            } else if (state == .notConnected) {
                guard let index = self.connectedClients.index(of: peerID) else { return }
                self.connectedClients.remove(at: index)
                self.delegate?.matchingServer(server: self, clientsDidChange: self.connectedClients)
            }
        }
    }
}

extension MatchingServer: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didNotStartAdvertisingPeer error: Error) {
    }
}
