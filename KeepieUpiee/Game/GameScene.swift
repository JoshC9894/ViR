//
//  GameScene.swift
//  KeepieUpiee
//
//  Created by Joshua Colley on 19/11/2022.
//

import SpriteKit
import GameplayKit
import ARKit

class GameScene: SKScene {
    enum Category: UInt32 {
        case ball, boot, side, floor, all
        
        var rawValue: RawValue {
            switch self {
            case .ball: return 0b1
            case .boot: return 0b10
            case .floor: return 0b100
            case .side: return 0b1000
            case .all: return UInt32.max
            }
        }
    }
    
    var gameDelegate: GameSceneDelegate?
    var trackingOffset: Int = 50
    
    private var ball: SKSpriteNode?
    private var boot: SKSpriteNode?
    private var floor: SKSpriteNode?
    
    private let ballSize: CGSize = CGSize(width: 150, height: 150)
    private let bootSize: CGSize = CGSize(width: 150, height: 65)
    private let floorSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 10)
    private let railSize: CGSize = CGSize(width: 4, height: UIScreen.main.bounds.height * 4)
    private let topRailSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 4, height: 4)
    
    private var ballPosition: CGPoint { return CGPoint(x: 0, y: 0) }
    private var bootPosition: CGPoint { return CGPoint(x: 0, y: -UIScreen.main.bounds.height + 250) }
    private var floorPosition: CGPoint { return CGPoint(x: 0, y: -UIScreen.main.bounds.height + 50) }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.setupWorld()
    }
    
    private func setupWorld() {
        self.trackingOffset = 50
        let defaults = UserDefaults.standard
        let teamId: Int = defaults.integer(forKey: "selected_team")
        let team: TeamPickerVC.Team = TeamPickerVC.Team(rawValue: teamId)!
        
        let background = SKSpriteNode(imageNamed: "field.png")
        background.size = UIScreen.main.bounds.size
        background.setScale(1.6)
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)
        
        // Ball
        self.ball = SKSpriteNode(imageNamed: "football")
        self.ball?.size = ballSize
        self.ball?.physicsBody = SKPhysicsBody(circleOfRadius: 150/2)
        self.ball?.position = self.ballPosition
        
        self.ball?.physicsBody?.restitution = 2.2
        self.ball?.physicsBody?.linearDamping = 1
        self.ball?.physicsBody?.allowsRotation = true
        self.ball?.physicsBody?.mass = 5
        
        self.ball?.physicsBody?.categoryBitMask = Category.ball.rawValue
        self.ball?.physicsBody?.collisionBitMask = Category.all.rawValue
        self.ball?.physicsBody?.contactTestBitMask = Category.all.rawValue
        
        if let ball = self.ball { addChild(ball) }
        
        // Boot
        self.boot = SKSpriteNode(imageNamed: team.boot)
        self.boot?.size = self.bootSize
        self.boot?.position = self.bootPosition
        self.boot?.physicsBody = SKPhysicsBody(circleOfRadius: self.bootSize.height)
        self.boot?.physicsBody?.affectedByGravity = false
        self.boot?.physicsBody?.isDynamic = false
        
        self.ball?.physicsBody?.mass = 50
        
        self.boot?.physicsBody?.categoryBitMask = Category.boot.rawValue
        self.boot?.physicsBody?.collisionBitMask = Category.ball.rawValue
        self.boot?.physicsBody?.contactTestBitMask = Category.ball.rawValue
        
        if let boot = self.boot { addChild(boot) }
        
        // Floor
        let floor = SKSpriteNode(color: .clear, size: self.floorSize)
        floor.physicsBody = SKPhysicsBody(rectangleOf: self.floorSize)
        floor.physicsBody?.isDynamic = false
        
        self.floor?.physicsBody?.categoryBitMask = Category.floor.rawValue
        self.floor?.physicsBody?.collisionBitMask = Category.ball.rawValue
        self.floor?.physicsBody?.contactTestBitMask = Category.ball.rawValue
        
        floor.position = self.floorPosition
        addChild(floor)
        
        // Bumpers
        let leftBumper: SKNode = createBumper()
        leftBumper.position = CGPoint(x: UIScreen.main.bounds.width - 90, y: 0)
        addChild(leftBumper)
        
        let rightBumper: SKNode = createBumper()
        rightBumper.position = CGPoint(x: -UIScreen.main.bounds.width + 90, y: 0)
        addChild(rightBumper)
        
        let topBumper: SKNode = {
            let node = SKSpriteNode(color: .clear, size: topRailSize)
            
            node.physicsBody = SKPhysicsBody(rectangleOf: topRailSize)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = Category.side.rawValue
            node.physicsBody?.contactTestBitMask = Category.ball.rawValue
            node.physicsBody?.collisionBitMask = Category.ball.rawValue
            
            return node
        }()
        topBumper.position = CGPoint(x: 0, y: UIScreen.main.bounds.height - 150)
        addChild(topBumper)
    }
    
    
    private func createBumper() -> SKSpriteNode {
        let node = SKSpriteNode(color: .clear, size: railSize)
        
        node.physicsBody = SKPhysicsBody(rectangleOf: railSize)
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = Category.side.rawValue
        node.physicsBody?.contactTestBitMask = Category.ball.rawValue
        node.physicsBody?.collisionBitMask = Category.ball.rawValue
        
        return node
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case Category.ball.rawValue | Category.boot.rawValue:
            self.ball?.physicsBody?.applyForce(CGVector(dx: 40, dy: 40))
            self.ball?.physicsBody?.applyTorque(40)
            self.gameDelegate?.didScore()
            
        case Category.ball.rawValue | Category.side.rawValue:
            let dx = self.ball?.physicsBody?.velocity.dx ?? 0.0
            let dy = self.ball?.physicsBody?.velocity.dy ?? 0.0
            self.ball?.physicsBody?.velocity = CGVector(dx: dx*0.5, dy: dy)
            self.ball?.physicsBody?.applyImpulse(CGVector(dx: dx > 0 ? -100 : 100, dy: 0))
            
        case Category.all.rawValue: self.gameDelegate?.didLose()
        default: return
        }
    }
}

extension GameScene: EyeTrackerDelegate {
    func gazeDidMove(_ face: ARFaceAnchor) {
        let deltaX = face.lookAtPoint.x
        let offset: Int = Int(50 * abs(deltaX))
        
        let vector = CGVector(dx: deltaX > 0 ? (-offset) : offset, dy: 0)
        let action = SKAction.move(by: vector, duration: 0.01)
        self.boot?.run(action)
    }
}
