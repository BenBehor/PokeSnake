//  GameManager.swift
//  BenSnake
//
//  Created by Ben on 12/12/2018.
//  Copyright © 2018 BehorDev. All rights reserved.

import SpriteKit
import FirebaseDatabase


class GameManager {
    
    var scene: GameScene!
    var nextTime: Double?
    var timeExtension: Double = 0.2
    var playerDirection: Int = 1
    var currentScore: Int = 0
    var randomPokemon: SKTexture = SKTexture(imageNamed: "p1")
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var dispachGroup = DispatchGroup()
    
    
    init(scene: GameScene) {
        self.scene = scene
        scene.view?.clipsToBounds = true
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else {
            if time >= nextTime! {
                nextTime = time + timeExtension
                updatePlayerPosition()
                checkForScore()
                checkForDeath()
                finishAnimation()
            }
        }
        
    }
    
    private func finishAnimation() {
        if playerDirection == 0 && scene.playerPositions.count > 0 {
            var hasFinished = true
            let headOfSnake = scene.playerPositions[0]
            for position in scene.playerPositions {
                if headOfSnake != position {
                    hasFinished = false
                }
            }
            if hasFinished {
                uploadScoreToLeaderboard()
                updateScore()
                playerDirection = 4
                //animation has completed
                scene.scorePos = nil
                scene.playerPositions.removeAll()
                renderChange()
                
                //return to menu
                scene.currentScore.run(SKAction.scale(by: 0, duration: 0.4)){
                    self.scene.currentScore.isHidden = true
                }
                scene.restartButton.run(SKAction.scale(by: 0, duration: 0.4)){
                    self.scene.restartButton.isHidden = true
                }
                scene.pauseButton.run(SKAction.scale(by: 0, duration: 0.4)){
                    self.scene.pauseButton.isHidden = true
                }
                scene.gameBG.run(SKAction.scale(to: 0, duration: 0.4)) {
                    self.scene.gameBG.isHidden = true
                    self.scene.gameLogo.isHidden = false
                    self.scene.gameLogo.run(SKAction.move(to: CGPoint(x: 0, y: (self.scene.frame.size.height / 2) - 200), duration: 0.5)) {
                        self.scene.playButton.isHidden = false
                        self.scene.playButton.run(SKAction.scale(to: 1, duration: 0.3))
                        self.scene.bestScore.run(SKAction.move(to: CGPoint(x: 0, y: self.scene.gameLogo.position.y - 50), duration: 0.3))
                    }
                }
            }
        }
    }
    
    private func updateScore() {
        if currentScore > UserDefaults.standard.integer(forKey: "bestScore") {
            UserDefaults.standard.set(currentScore, forKey: "bestScore")
        }
        currentScore = 0
        scene.currentScore.text = "Score: 0"
        scene.bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
    
    private func checkForDeath() {
        if scene.playerPositions.count > 0 {
            var arrayOfPositions = scene.playerPositions
            let headOfSnake = arrayOfPositions[0]
            arrayOfPositions.remove(at: 0)
            if contains(a: arrayOfPositions, v: headOfSnake) {
                playerDirection = 0
            }
        }
    }
    
    func getLeaderboard(){
        
        let refs = Database.database().reference(withPath: "leaderboardd")
        refs.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            leaderboardList = snapshot.value as! [String]
        })
    
    }
    
    func uploadScoreToLeaderboard(){
        
        getLeaderboard()

        
        self.ref = Database.database().reference()
        
        let savedBackground = UserDefaults.standard.string(forKey: "savedBackground") ?? "pb1"
        let nickName = UserDefaults.standard.string(forKey: "nickName") ?? "Guest"
        let score = self.currentScore
        
        for (leaderPos, user) in leaderboardList.enumerated() {
            let index = user.index(of: ",")!
            let currentLeaderScore = Int(user.prefix(upTo: index))!
            if currentLeaderScore < self.currentScore{
                leaderboardList.insert("\(score),\(nickName).\(String(describing: savedBackground))", at: leaderPos)
                leaderboardList.popLast() // swift is mistken, it does remove the last position from the array.
                self.ref?.child("leaderboardd").setValue(leaderboardList)
                return
            }
            
        }
    }
    
    private func checkForScore() {
        if scene.scorePos != nil {
            let x = scene.playerPositions[0].0
            let y = scene.playerPositions[0].1
            if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                if pokeList.contains(scene.name!){
                    if !pokeCaught.contains(scene.name!){
                        pokeCaught.append(scene.name!)
                    }
                }
                switch timeExtension {
                case 0.5,0.25,0.15:
                    currentScore += 1
                case 0.05:
                    currentScore += 2
                default:
                    currentScore += 1
                }
                scene.currentScore.text = "Score: \(currentScore)"
                generateNewPoint()
                scene.playerPositions.append(scene.playerPositions.last!)
            }
        }
    }
    
    private func updatePlayerPosition() {
        var xChange = -1
        var yChange = 0
        
        switch playerDirection {
        case 1:
            //left
            xChange = -1
            yChange = 0
            break
        case 2:
            //up
            xChange = 0
            yChange = -1
            break
        case 3:
            //right
            xChange = 1
            yChange = 0
            break
        case 4:
            //down
            xChange = 0
            yChange = 1
            break
        case 0:
            //dead
            xChange = 0
            yChange = 0
            break
        default:
            break
        }
        
        if scene.playerPositions.count > 0 {
            var start = scene.playerPositions.count - 1
            while start > 0 {
                scene.playerPositions[start] = scene.playerPositions[start - 1]
                start -= 1
            }
            scene.playerPositions[0] = (scene.playerPositions[0].0 + yChange, scene.playerPositions[0].1 + xChange)
        }
        
        if scene.playerPositions.count > 0 {
            let x = scene.playerPositions[0].1
            let y = scene.playerPositions[0].0
            if y > scene.gameNumRows {
                scene.playerPositions[0].0 = 0
            } else if y < 0 {
                scene.playerPositions[0].0 = scene.gameNumRows - 1
            } else if x > scene.gameNumCols {
                scene.playerPositions[0].1 = 0
            } else if x < 0 {
                scene.playerPositions[0].1 = scene.gameNumCols - 1
            }
        }
        renderChange()
    }
    
    func initGame() {
        
        
        //starting player position
        scene.playerPositions.append((10, 10))
        scene.playerPositions.append((10, 11))
        scene.playerPositions.append((10, 12))
        renderChange()
        generateNewPoint()
    }
    
    
    private func generateNewPoint() {
        randomPokemon = randomImage()
        var randomX = CGFloat(arc4random_uniform(UInt32(scene.gameNumCols - 1)))
        var randomY = CGFloat(arc4random_uniform(UInt32(scene.gameNumRows - 1)))
        while contains(a: scene.playerPositions, v: (Int(randomX), Int(randomY))) {
            randomX = CGFloat(arc4random_uniform(UInt32(scene.gameNumCols - 1)))
            randomY = CGFloat(arc4random_uniform(UInt32(scene.gameNumRows - 1)))
        }
        scene.scorePos = CGPoint(x: randomX, y: randomY)
        scene.name = randomPokemon.getImageName()
    }
    
    func renderChange() {
        for (node, x, y) in scene.gameArray {
            if contains(a: scene.playerPositions, v: (x,y)) {
                node.fillColor = SKColor.white
                let trumpTexture = SKTexture(imageNamed: "pokeball")
                node.fillTexture = trumpTexture
            } else {
                node.fillColor = SKColor.clear
            }
            if scene.scorePos != nil {
                if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                    node.fillColor = SKColor.white
                    node.fillTexture = randomPokemon
                }
            }
        }
    }
    
    func randomImage()->SKTexture{
        let randNum = arc4random_uniform(151)
        let randPic = "p\(randNum)"
        let pokeTexture = SKTexture(imageNamed: randPic)
        return pokeTexture
    }
    
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    func swipe(ID: Int) {
        if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) {
            if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1) {
                if playerDirection != 0 {
                    playerDirection = ID
                }
            }
        }
    }
}

extension SKTexture{
    func getImageName() -> String {
        let name = self.description
        let lines = name.components(separatedBy: "\'")
        return lines[1]
    }
    
    
}
