//
//  MatchingClient.swift
//  DrinkIt
//
//  Created by CBLUE on 4/6/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit
import MultipeerConnectivity

@objc protocol MatchingClientDelegate: class {
    @objc optional func matchingClient(client:MatchingClient,
                        hostsDidChange hosts:[MCPeerID])
    @objc optional func matchingClient(client:MatchingClient, didGetCard card:String)
    @objc optional func matchingClientShouldStartGame(client:MatchingClient)
    @objc optional func matchingClientShouldEndGame(client:MatchingClient)
    @objc optional func matchingClient(client:MatchingClient, didChangeState state:MCSessionState)
}

class MatchingClient: MatchingHandler {
    var browser:MCNearbyServiceBrowser!
    var foundHosts = [MCPeerID]()
    var delegate:MatchingClientDelegate?

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

    override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        guard let message = String(data: data, encoding: .utf8) else {
            return
        }
        print("client did receive message \(message)")
        
        DispatchQueue.main.async {
            
            if (message == MatchingMessage.startGame.rawValue) {
                self.delegate?.matchingClientShouldStartGame?(client: self)
            } else if (message.contains(MatchingMessage.startDealing.rawValue)) {
                guard let card = message.components(separatedBy: ":").last else {
                    return
                }
                print("card \(card)")
                self.delegate?.matchingClient?(client: self, didGetCard: card)
            } else if (message == MatchingMessage.endGame.rawValue) {
                self.delegate?.matchingClientShouldEndGame?(client: self)
            }
        }
    }
    
    override func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            self.delegate?.matchingClient?(client: self, didChangeState: state)
        }
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
                self.delegate?.matchingClient?(client: self, hostsDidChange: self.foundHosts)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        print("lost peer \(peerID)")
    }
}
