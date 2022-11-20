//
//  TeamPickerCell.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 19/11/2022.
//

import UIKit

class TeamPickerCell: UICollectionViewCell {
    
    static let Identifier: String = "TeamPickerCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(for team: TeamPickerVC.Team, selected: Bool? = nil) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        let imageView = UIImageView(image: team.image)
        if let selected {
            imageView.alpha = selected ? 1.0 : 0.35
            imageView.layer.borderColor = selected ? UIColor(named: "qatar_white")?.cgColor : UIColor.clear.cgColor
            imageView.layer.borderWidth = 4
            imageView.layer.cornerRadius = imageView.frame.height / 2
        } else {
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
