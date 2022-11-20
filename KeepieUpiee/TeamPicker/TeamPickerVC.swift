//
//  TeamPickerVC.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 19/11/2022.
//

import UIKit

class TeamPickerVC: UIViewController {
    
    enum Team: Int, CaseIterable {
        case argentina, brazil, england, france, germany, spain, portugal, qatar
        
        var image: UIImage {
            switch self {
            case .argentina: return UIImage(named: "argentina") ?? UIImage()
            case .brazil: return UIImage(named: "brazil") ?? UIImage()
            case .england: return UIImage(named: "england") ?? UIImage()
            case .france: return UIImage(named: "france") ?? UIImage()
            case .germany: return UIImage(named: "germany") ?? UIImage()
            case .spain: return UIImage(named: "spain") ?? UIImage()
            case .portugal: return UIImage(named: "portugal") ?? UIImage()
            case .qatar: return UIImage(named: "qatar") ?? UIImage()
            }
        }
        
        var label: String {
            switch self {
            case .argentina: return "Argentina"
            case .brazil: return "Brazil"
            case .england: return "England"
            case .france: return "France"
            case .germany: return "Germany"
            case .spain: return "Spain"
            case .portugal: return "Portugal"
            case .qatar: return "Qatar"
            }
        }
        
        var boot: String {
            switch self {
            case .argentina: return "argentina_boot"
            case .brazil: return "brazil_boot"
            case .england: return "england_boot"
            case .france: return "france_boot"
            case .germany: return "germany_boot"
            case .spain: return "spain_boot"
            case .portugal: return "portugal_boot"
            case .qatar: return "qatar_boot"
            }
        }
    }
    
    var collectionView: UICollectionView!
    var selectedTeam: Team?
    
    var layout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addGradient()
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = .clear
        self.collectionView.register(UINib(nibName: TeamPickerCell.Identifier, bundle: nil),
                                     forCellWithReuseIdentifier: TeamPickerCell.Identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelView: UIView = {
            let label = UILabel()
            label.text = "Pick your team"
            label.textColor = UIColor(named: "qatar_black")!
            label.font = UIFont(name: "Qatar2022Arabic-Bold", size: 24)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let view: UIView = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            return DynamicView(view: view, height: 1)
        }()
        
        
        let buttonView: UIView = {
            let button: UIButton = UIButton()
            button.backgroundColor = UIColor(named: "qatar_white")!
            button.layer.cornerRadius = 14
            let title = NSAttributedString(
                string: "Start",
                attributes: [
                    .font: UIFont(name: "Qatar2022Arabic-Bold", size: 24)!,
                    .foregroundColor: UIColor(named: "qatar_red")!
                ]
            )
            button.setAttributedTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(onStartPressed), for: .touchUpInside)
            button.layer.shadowRadius = 4
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.45
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            
            let view: UIView = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
                button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
                button.heightAnchor.constraint(equalToConstant: 65)
            ])
            
            return DynamicView(view: view, height: 1)
        }()
        
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.axis = .vertical
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(labelView)
        stackView.addArrangedSubview(DynamicView(view: self.collectionView, height: 5))
        stackView.addArrangedSubview(buttonView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    @objc func onStartPressed() {
        if let team = selectedTeam {
            let defaults = UserDefaults.standard
            defaults.set(team.rawValue, forKey: "selected_team")
            defaults.set(0, forKey: "highscore")
            defaults.set(0, forKey: "current_score")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController")
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

extension TeamPickerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Team.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TeamPickerCell.Identifier,
            for: indexPath
        ) as? TeamPickerCell else { return UICollectionViewCell() }
        
        let selected = self.selectedTeam == nil ? nil : self.selectedTeam == Team.allCases[indexPath.row]
        cell.configure(for: Team.allCases[indexPath.row], selected: selected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedTeam == Team.allCases[indexPath.row] {
            self.selectedTeam = nil; collectionView.reloadData(); return
        }
        self.selectedTeam = Team.allCases[indexPath.row]
        collectionView.reloadData()
    }
}
