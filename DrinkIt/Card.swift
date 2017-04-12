//
//  Card.swift
//  DrinkIt
//
//  Created by CBLUE on 4/7/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit

enum Suit {
    case clubs
    case diamonds
    case hearts
    case spades
    
    func toString() -> String {
        switch self {
        case .clubs:
            return "Clubs"
        case .diamonds:
            return "Diamonds"
        case .hearts:
            return "Hearts"
        case .spades:
            return "Spades"
        }
    }
    
    static func allSuits() -> [Suit] {
        return [Suit.clubs, Suit.diamonds, Suit.hearts, Suit.spades]
    }
}

class Card: NSObject {
    
    var suit:Suit
    var number:UInt
    
    init(suit:Suit, number:UInt) {
        self.suit = suit
        self.number = number
        super.init()
    }
    
    func toString() -> String {
        if (self.number == 0) {
            return "Joker"
        }
        
        return "\(suit.toString()) \(number.toCardString())"
    }
}

extension UInt{
    func toCardString() -> String {
        if (11 ... 13).contains(self) {
            if self == 11 {
                return "Jack"
            } else if self == 12 {
                return "Queen"
            } else if self == 13 {
                return "King"
            }
        }
        
        if self == 1 {
            return "Ace"
        }
        
        return String(self)
    }
}
