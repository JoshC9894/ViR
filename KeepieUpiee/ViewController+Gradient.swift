//
//  ViewController+Gradient.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 19/11/2022.
//

import UIKit

extension UIViewController {
    func addGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [
            UIColor(named: "qatar_white")?.cgColor ?? UIColor.white.cgColor,
            UIColor(named: "qatar_dark")?.cgColor ?? UIColor.red.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.view.frame
        self.view.layer.insertSublayer(gradient, at: 0)
        self.view.backgroundColor = .clear
    }
}
