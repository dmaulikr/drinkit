//
//  ButtonStyle.swift
//  DrinkIt
//
//  Created by CBLUE on 4/7/17.
//  Copyright © 2017 CardinalBlue. All rights reserved.
//

import UIKit

extension UIButton {
    func di_applyDefaultButtonStyle() {
        titleLabel?.font = UIFont.di_actionManFont(size: 20)
        tintColor = UIColor.di_appTint
        let buttonImage = UIImage(named: "Button")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 0)
        setBackgroundImage(buttonImage, for: .normal)
        let pressedImage = UIImage(named: "ButtonPressed")?.stretchableImage(withLeftCapWidth: 15, topCapHeight: 0)
        setBackgroundImage(pressedImage, for: .highlighted)
    }
}

extension UILabel {
    func di_applyDefaultTitleLabelStyle() {
        font = UIFont.di_actionManFont(size: 24)
        textColor = UIColor.di_appTint
    }
}

extension UIColor {
    static let di_appTint = UIColor(red: 116.0/255.0, green: 192.0/255.0, blue: 97.0/255.0, alpha: 1)
}

extension UITableViewCell {
    func di_applyDefaultSelectionColor() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.di_appTint.withAlphaComponent(0.5)
        self.selectedBackgroundView = bgColorView
    }
}
