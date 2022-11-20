//
//  ScoreVC.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 20/11/2022.
//

import UIKit

class ScoreVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGradient()
        
        let defaults = UserDefaults.standard
        let teamId: Int = defaults.integer(forKey: "selected_team")
        let team: TeamPickerVC.Team = TeamPickerVC.Team(rawValue: teamId)!
        let score: Int = defaults.integer(forKey: "current_score")
        
        // MARK: - Title View
        let titleView: UIView = {
            let label_1 = UILabel()
            label_1.text = "Game"
            label_1.textColor = UIColor(named: "qatar_black")!
            label_1.font = UIFont(name: "Qatar2022Arabic-Bold", size: 96)
            label_1.translatesAutoresizingMaskIntoConstraints = false
            label_1.textAlignment = .center
            
            let label_2 = UILabel()
            label_2.text = "Over"
            label_2.textColor = UIColor(named: "qatar_black")!
            label_2.font = UIFont(name: "Qatar2022Arabic-Bold", size: 96)
            label_2.translatesAutoresizingMaskIntoConstraints = false
            label_2.textAlignment = .center
            
            let stack = UIStackView(frame: .zero)
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .equalCentering
            stack.alignment = .center
            stack.axis = .vertical
            stack.addArrangedSubview(label_1)
            stack.addArrangedSubview(label_2)
            
            let view_1: UIView = UIView(frame: .zero)
            view_1.translatesAutoresizingMaskIntoConstraints = false
            view_1.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.centerXAnchor.constraint(equalTo: view_1.centerXAnchor)
            ])
            
            return view_1
        }()
        
        // MARK: - Scorecard View
        let scorecard: UIView = {
            let banner: UIView = UIView(frame: .zero)
            banner.translatesAutoresizingMaskIntoConstraints = false
            banner.backgroundColor = UIColor(named: "qatar_white")
            
            let scoreLabel: UILabel = UILabel()
            scoreLabel.text = "Score: \(score)"
            scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            scoreLabel.textColor = UIColor(named: "qatar_black")!
            scoreLabel.font = UIFont(name: "Qatar2022Arabic-Bold", size: 32)
            
            banner.addSubview(scoreLabel)
            
            let imageView: UIImageView = UIImageView(image: team.image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.frame.size = CGSize(width: 100, height: 100)
            imageView.layer.cornerRadius = 50
            imageView.layer.shadowRadius = 4
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOpacity = 0.45
            imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
            
            let view_2: UIView = UIView(frame: .zero)
            view_2.translatesAutoresizingMaskIntoConstraints = false
            view_2.addSubview(banner)
            view_2.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.leftAnchor.constraint(equalTo: view_2.leftAnchor, constant: 32),
                imageView.centerYAnchor.constraint(equalTo: view_2.centerYAnchor),
                banner.leftAnchor.constraint(equalTo: view_2.leftAnchor),
                banner.rightAnchor.constraint(equalTo: view_2.rightAnchor),
                banner.heightAnchor.constraint(equalToConstant: 65),
                banner.centerYAnchor.constraint(equalTo: view_2.centerYAnchor),
                scoreLabel.rightAnchor.constraint(equalTo: banner.rightAnchor, constant: -32),
                scoreLabel.centerYAnchor.constraint(equalTo: banner.centerYAnchor),
            ])
            
            return view_2
        }()
        
        // MARK: - Button View
        let buttonView: UIView = {
            let button: UIButton = UIButton()
            button.backgroundColor = UIColor(named: "qatar_dark")!
            button.layer.cornerRadius = 14
            let title = NSAttributedString(
                string: "Change team",
                attributes: [
                    .font: UIFont(name: "Qatar2022Arabic-Bold", size: 24)!,
                    .foregroundColor: UIColor(named: "qatar_white")!
                ]
            )
            button.setAttributedTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(onChangeTeamPressed), for: .touchUpInside)
            button.layer.shadowRadius = 4
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.45
            button.layer.shadowOffset = CGSize(width: 2, height: 2)
            
            let button_2: UIButton = UIButton()
            button_2.backgroundColor = UIColor(named: "qatar_black")!
            button_2.layer.cornerRadius = 14
            let title_2 = NSAttributedString(
                string: "Replay",
                attributes: [
                    .font: UIFont(name: "Qatar2022Arabic-Bold", size: 24)!,
                    .foregroundColor: UIColor(named: "qatar_white")!
                ]
            )
            button_2.setAttributedTitle(title_2, for: .normal)
            button_2.translatesAutoresizingMaskIntoConstraints = false
            button_2.addTarget(self, action: #selector(onRestartPressed), for: .touchUpInside)
            button_2.layer.shadowRadius = 4
            button_2.layer.shadowColor = UIColor.black.cgColor
            button_2.layer.shadowOpacity = 0.45
            button_2.layer.shadowOffset = CGSize(width: 2, height: 2)
            
            let stack: UIStackView = UIStackView()
            stack.alignment = .fill
            stack.axis = .vertical
            stack.distribution = .equalSpacing
            stack.spacing = 16
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(button)
            stack.addArrangedSubview(button_2)
            
            let view_3: UIView = UIView()
            view_3.translatesAutoresizingMaskIntoConstraints = false
            view_3.addSubview(stack)
            
            NSLayoutConstraint.activate([
                stack.bottomAnchor.constraint(equalTo: view_3.bottomAnchor, constant: -16),
                stack.centerXAnchor.constraint(equalTo: view_3.centerXAnchor),
                stack.leftAnchor.constraint(equalTo: view_3.leftAnchor, constant: 32),
                stack.rightAnchor.constraint(equalTo: view_3.rightAnchor, constant: -32),
                button.heightAnchor.constraint(equalToConstant: 65),
                button_2.heightAnchor.constraint(equalToConstant: 65),
            ])
            
            return view_3
        }()
        
        // MARK: - Stack View
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleView)
        stack.addArrangedSubview(scorecard)
        stack.addArrangedSubview(buttonView)
        
        self.view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            stack.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            stack.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        self.view.bringSubviewToFront(buttonView)
    }
    
    @objc func onRestartPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func onChangeTeamPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeamPickerVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
