//
//  Deck.swift
//  DrinkIt
//
//  Created by CBLUE on 4/7/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit

class Deck: NSObject {
    
    var cards = [Card]()
    
    override init() {
        super.init()
        setupCards()
    }
    
    func setupCards() {
        
        cards.removeAll()
        
        for i:UInt in 1 ... 13 {
            for suit in Suit.allSuits() {
                let card = Card(suit: suit, number: i)
                cards.append(card)
            }
        }
        
        let joker1 = Card(suit: .spades, number: 0)
        let joker2 = Card(suit: .spades, number: 0)
        cards.append(joker1)
        cards.append(joker2)
    }
    
    func randomDraw() -> Card {
        let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
        let card = cards.remove(at: randomIndex)
        return card
    }
}
