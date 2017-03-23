//
//  GameScene.swift
//  Breakout
//
//  Created by roycetanjiashing on 14/10/16.
//  Copyright © 2016 examplecompany. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    var ball:SKSpriteNode!
    var paddle:SKSpriteNode!
    var brick:SKSpriteNode!
    var loseZone:SKSpriteNode!
    var button = SKSpriteNode(imageNamed: "start")
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
    didSet {
    scoreLabel.text = "Score: \(score)"
        } }
    var livesLabel:SKLabelNode!
    var lives:Int = 3 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }
    
    override func didMove(to view: SKView) {
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
        scoreLabel = self.childNode(withName: "Score") as! SKLabelNode
        livesLabel = self.childNode(withName: "Lives") as! SKLabelNode
        
       button.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
       self.addChild(button)
        
        let border = SKPhysicsBody(edgeLoopFrom: (view.scene?.frame)!)
        border.friction = 0
        self.physicsBody = border
        
        self.physicsWorld.contactDelegate = self
        
        setUp()
        
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y: starsBackground.size.height * CGFloat(i))
            starsBackground.size = CGSize(width: frame.width, height: frame.height + 10000)
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 200)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
            if (button.contains(location)  && (lives == 0 || score == 12) ){
                button.alpha = 0
                resetGame()
                ball.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 100))
                button.isUserInteractionEnabled = false
            }
            else if (button.contains(location)) {
                button.alpha = 0
                ball.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 100))
                 button.isUserInteractionEnabled = false
            }
            }
            
        }


    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            paddle.position.x = touchLocation.x
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyAName = contact.bodyA.node?.name
        let bodyBName = contact.bodyB.node?.name
        
        if  (ball.position.y < (paddle.position.y + 20)) {
            lives -= 1
            ball.removeFromParent()
            ball.position = CGPoint(x:frame.midX, y: frame.midY - 400)
            addChild(ball)
            ball.physicsBody?.applyImpulse(CGVector(dx: 100, dy: 100))
        }
        
        if bodyAName == "Ball" && bodyBName == "Brick" || bodyAName == "Brick" && bodyBName == "Ball"{
            if bodyAName == "Brick" {
                contact.bodyA.node?.removeFromParent()
                score += 1
            } else if bodyBName == "Brick" {
                contact.bodyB.node?.removeFromParent()
                score += 1
            }
            
            
            }
}
    
    func resetGame() {
         button.isUserInteractionEnabled = false
        ball.removeFromParent()
        ball.position = CGPoint(x:frame.midX, y: frame.midY - 400)
        addChild(ball)
        score = 0
        lives = 3
        scoreLabel.text = "Score: 0"
        livesLabel.text = "Lives: 3"
        setUp()
        self.view?.isPaused = false
    }
    
    func setUp() {
        makeBrick(ex: -292.937, why: 615.237)
        makeBrick(ex: -94.221, why: 615.237)
        makeBrick(ex: 100.768, why: 615.237)
        makeBrick(ex: 292.938, why: 615.237)
        makeBrick(ex: -292.937, why: 530.975)
        makeBrick(ex: -94.221, why: 530.975)
        makeBrick(ex: 100.768, why: 530.975)
        makeBrick(ex: 292.938, why: 530.975)
        makeBrick(ex: -292.937, why: 443.016)
        makeBrick(ex: -94.221, why: 443.016)
        makeBrick(ex: 100.768, why: 443.016)
        makeBrick(ex: 292.938, why: 443.016)
    }
    
    func makeBrick(ex: Float, why: Float) {
        brick = SKSpriteNode(color: getRandomColor(), size: CGSize(width: frame.width/5, height: frame.height/25))
        brick.position = CGPoint(x: Int(ex), y: Int(why))
        brick.name = "Brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func getRandomColor() -> UIColor{
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (score == 12) {
             button.isUserInteractionEnabled = true
            scoreLabel.text = "YOU WIN"
            self.view?.isPaused = true
            button = SKSpriteNode(imageNamed: "Next")
            self.addChild(button)
        }
        
        if (lives == 0) {
             button.isUserInteractionEnabled = true
            livesLabel.text = "YOU LOSE"
            self.view?.isPaused = true
            button = SKSpriteNode(imageNamed: "reset")
            self.addChild(button)
        }
        
        
    }
    

    
}

