//
//  GameViewController.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 19/11/2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    private var score: Int = 0 {
        didSet {
            self.scoreLabel.text = "\(score)"
        }
    }
    private var tracker: EyeTracker = EyeTracker()
    private var scoreLabel: UILabel = UILabel(frame: .zero)
    private var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scoreLabel.text = "0"
        
        let defaults = UserDefaults.standard
        let teamId: Int = defaults.integer(forKey: "selected_team")
        let team: TeamPickerVC.Team = TeamPickerVC.Team(rawValue: teamId)!
            
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                scene.gameDelegate = self
                tracker.delegate = scene
                self.scene = scene
            }
            
            view.addSubview(tracker.view)
            tracker.view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        }
        
        let headerView: UIView = {
            let banner: UIView = UIView(frame: .zero)
            banner.translatesAutoresizingMaskIntoConstraints = false
            banner.backgroundColor = UIColor(named: "qatar_white")
            
            self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
            self.scoreLabel.textColor = UIColor(named: "qatar_black")!
            self.scoreLabel.font = UIFont(name: "Qatar2022Arabic-Bold", size: 32)
            
            banner.addSubview(self.scoreLabel)
            
            let imageView: UIImageView = UIImageView(image: team.image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.frame.size = CGSize(width: 100, height: 100)
            imageView.layer.cornerRadius = 50
            imageView.layer.shadowRadius = 4
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOpacity = 0.45
            imageView.layer.shadowOffset = CGSize(width: 2, height: 2)
            
            let view: UIView = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(banner)
            view.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32),
                banner.leftAnchor.constraint(equalTo: view.leftAnchor),
                banner.rightAnchor.constraint(equalTo: view.rightAnchor),
                banner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                banner.heightAnchor.constraint(equalToConstant: 65),
                scoreLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
                scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
            
            return view
        }()
        
        self.view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        self.tracker.trackEyes()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GameSceneDelegate {
    func didScore() {
        self.score+=1;
        self.scene.trackingOffset += 5
    }
    
    func didLose() {
        let defaults = UserDefaults.standard
        defaults.set(self.score, forKey: "current_score")
        
        let highscore = defaults.integer(forKey: "highscore")
        if highscore < self.score {
            defaults.set(self.score, forKey: "highscore")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScoreVC")
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
