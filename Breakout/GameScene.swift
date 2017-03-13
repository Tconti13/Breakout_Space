//
//  GameScene.swift
//  Breakout
//
//  Created by Tconti on 3/13/17.
//  Copyright © 2017 Conti Inc. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var ball = SKShapeNode()
    
    override func didMove(to view: SKView) {
        createBackground()
        makeBall()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x:0, y: starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x:frame.midX, y: frame.midY)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.yellow
        ball.name = "ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10) //Physics shape matches ball image
        ball.physicsBody?.isDynamic = false //
        ball.physicsBody?.usesPreciseCollisionDetection = true //Ignores all forces and impulses
        ball.physicsBody?.friction = 0 //Use precise collision detection
        ball.physicsBody?.affectedByGravity = false //No loss of energy from friction
        ball.physicsBody?.restitution = 1 //Gravity is not a factor
        ball.physicsBody?.linearDamping = 0 //Bounces fully off of other objects
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)! //Does not slow down over time
        addChild(ball) //Add ball objext to the view
    }
}
