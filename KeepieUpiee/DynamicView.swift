//
//  DynamicView.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 19/11/2022.
//

import UIKit

class DynamicView: UIView {
    var height: CGFloat
    
    init(view: UIView, height: CGFloat) {
        self.height = height
        super.init(frame: .zero)
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 1.0, height: height)
    }
}
