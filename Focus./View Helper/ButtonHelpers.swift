//
//  ButtonHelpers.swift
//  Focus.
//
//  Created by James on 23/2/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    func setupMainButton() {
        // create gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = mainButton.bounds
        gradientLayer.colors = [buttonGradient[0].cgColor, buttonGradient[1].cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        mainButton.layer.insertSublayer(gradientLayer, at: 0)
        
        // create round rect
        mainButton.layer.cornerRadius = mainButton.frame.height/5
        mainButton.clipsToBounds = true
    }
}
