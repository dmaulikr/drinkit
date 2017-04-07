//
//  CardImageView.swift
//  DrinkIt
//
//  Created by CBLUE on 4/7/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit

class CardImageView: UIImageView {
    var card:Card? {
        didSet {
            if let card = card {
                image = UIImage(named: card.toString())
            } else {
                image = UIImage(named: "Back")
            }
        }
    }
}
