//
//  GameScene.swift
//  BenSnake
//
//  Created by Ben on 12/12/2018.
//  Copyright © 2018 BehorDev. All rights reserved.
//
import SpriteKit
import GameplayKit


class GameScene: SKScene {
    var gameLogo: SKLabelNode!
    var bestScore: SKLabelNode!
    var playButton: SKShapeNode!
    var game: GameManager!
    var currentScore: SKLabelNode!
    var playerPositions: [(Int, Int)] = []
    var gameBG: SKShapeNode!
    var restartButton: SKShapeNode!
    var pauseButton: SKShapeNode!
    var gameArray: [(node: SKShapeNode, x: Int, y: Int)] = []
    var scorePos: CGPoint?
    var gameNumRows = 22
    var gameNumCols = 14
    var gameCellWidth: CGFloat = 48

    var background = SKSpriteNode(imageNamed: "mainbkg1")

    @objc func swipeR() {
        game.swipe(ID: 3)
    }
    @objc func swipeL() {
        game.swipe(ID: 1)
    }
    @objc func swipeU() {
        game.swipe(ID: 2)
    }
    @objc func swipeD() {
        game.swipe(ID: 4)
    }
    
    override func didMove(to view: SKView) {
        
        initializeMenu()
        game = GameManager(scene: self)
        game.getLeaderboard()
        initializeGameView()
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeL))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeU))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeD))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    private func initializeGameView() {
        if UserDefaults.standard.array(forKey: "pokemonsCaught") == nil {
        let array = ["nowNotNil"]
        UserDefaults.standard.set(array, forKey: "pokemonsCaught")
        }
        if UserDefaults.standard.string(forKey: "savedBackground") == nil {
        UserDefaults.standard.set("pb1", forKey: "savedBackground")
        }
        currentScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        currentScore.zPosition = 1
        currentScore.position = CGPoint(x: (self.frame.size.width / -2) + 150, y: (self.frame.size.height / 2 - frame.size.height / 100 * 6))
        currentScore.fontSize = 40
        currentScore.isHidden = true
        currentScore.text = "Score: 0"
        currentScore.fontColor = SKColor.white
        
        self.addChild(currentScore)
        let width = self.frame.size.width / 100 * 90
        let height = self.frame.size.height / 100 * 80
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        
        gameBG = SKShapeNode(rect: rect, cornerRadius: 0.02)
        gameBG.fillColor = SKColor.lightGray

        if !UserDefaults.standard.bool(forKey: "graphics") {
        let gameBGimg: SKTexture = SKTexture(imageNamed: "gameBackground")
        gameBG.fillTexture = gameBGimg
        }
        
        gameBG.zPosition = 2
        gameBG.isHidden = true
        self.addChild(gameBG)
        createGameBoard(width: Int(width), height: Int(height))
    }
    //create a game board, initialize array of cells
    private func createGameBoard(width: Int, height: Int) {
        let savedData = checkForSavedData()
        if savedData == true{
            game.timeExtension = UserDefaults.standard.double(forKey: "timeExtension")
            gameNumRows = UserDefaults.standard.integer(forKey: "gameNumRows")
            gameNumCols = UserDefaults.standard.integer(forKey: "gameNumCols")
            gameCellWidth = CGFloat(UserDefaults.standard.integer(forKey: "gameCellWidth"))
        }
        var x = CGFloat(width / -2) + (gameCellWidth / 2)
        var y = CGFloat(height / 2) - (gameCellWidth / 2)
        //loop through rows and columns, create cells
        for i in 0...gameNumRows - 1 {
            for j in 0...gameNumCols - 1 {
                let cellNode = SKShapeNode(rectOf: CGSize(width: gameCellWidth, height: gameCellWidth))
                cellNode.strokeColor = SKColor.clear
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: x, y: y)
                //add to array of cells -- then add to game board
                gameArray.append((node: cellNode, x: i, y: j))
                gameBG.addChild(cellNode)
                //iterate x
                x += gameCellWidth
            }
            //reset x, iterate y
            x = CGFloat(width / -2) + (gameCellWidth / 2)
            y -= gameCellWidth
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //call before each frame rendered
        game.update(time: currentTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "play_button" {
                    startGame()
                }
                if node.name == "restart_match" {
                    //finish the game
                    game.playerDirection = 0
                }
                if node.name == "pause_button" {
                    //pause button :O
                    self.isPaused.toggle()
                }
            }
        }
    }
    
    private func checkForSavedData()->Bool{
        let savedMapSize = UserDefaults.standard.integer(forKey: "gameNumRows")
        guard savedMapSize != 0 else {
            return false
        }
        return true
    }
    
    private func startGame() {
        initializeGameView()
        gameLogo.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)) {
            self.gameLogo.isHidden = true
        }
        playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        let restartButtonPosition = CGPoint(x: (frame.size.width / 2) - 100, y: (frame.size.height / 2) - 80)
        restartButton.run(SKAction.move(to: restartButtonPosition, duration: 0.4))
        restartButton.isHidden = false
        restartButton.run(SKAction.move(to: restartButtonPosition, duration: 0.4)) {
            self.restartButton.setScale(0)
            self.restartButton.isHidden = false
            self.restartButton.run(SKAction.scale(to: 1, duration: 0.4))
        }
        let pauseButtonPosition = CGPoint(x: (frame.size.width / 2) - 200, y: (frame.size.height / 2) - 80)
        pauseButton.isHidden = false
        pauseButton.run(SKAction.move(to: pauseButtonPosition, duration: 0.4)) {
            self.pauseButton.setScale(0)
            self.pauseButton.isHidden = false
            self.pauseButton.run(SKAction.scale(to: 1, duration: 0.4))
        }
        
        let topLeftCorner = CGPoint(x: (frame.size.width / -2) + 150, y: (frame.size.height / 2) - frame.size.height / 100 * 3)
        bestScore.run(SKAction.move(to: topLeftCorner, duration: 0.4))
        bestScore.run(SKAction.move(to: topLeftCorner, duration: 0.4)) {
            self.gameBG.setScale(0)
            self.currentScore.setScale(0)
            self.gameBG.isHidden = false
            self.currentScore.isHidden = false
            self.gameBG.run(SKAction.scale(to: 1, duration: 0.4))
            self.currentScore.run(SKAction.scale(to: 1, duration: 0.4))
            self.game.initGame()
        }
    }
    
    private func initializeMenu() {
        background.position = CGPoint(x:0, y: 0)
        addChild(background)
        //Create game title
        gameLogo = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        gameLogo.zPosition = 1
        gameLogo.position = CGPoint(x: 0, y: (frame.size.height / 2) - 200)
        gameLogo.fontSize = 60
        gameLogo.text = "PokeSnake"
        gameLogo.fontColor = SKColor(displayP3Red: 0.9, green: 0.9, blue: 0.4, alpha: 1)
        self.addChild(gameLogo)
        //Create best score label
        bestScore = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        bestScore.zPosition = 1
        bestScore.position = CGPoint(x: 0, y: gameLogo.position.y - 50)
        bestScore.fontSize = 40
        bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
        bestScore.fontColor = SKColor.white
        self.addChild(bestScore)
        //Create play button
        playButton = SKShapeNode()
        playButton.name = "play_button"
        playButton.zPosition = 1
        playButton.position = CGPoint(x: 0, y: (frame.size.height / -2 + frame.size.height / 100 * 20))
        playButton.fillColor = SKColor(displayP3Red: 0.9, green: 0.9, blue: 0.4, alpha: 1)
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middle = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLine(to: topCorner)
        path.addLines(between: [topCorner, bottomCorner, middle])
        playButton.path = path
        self.addChild(playButton)
        //Create restartMatch button
        restartButton = SKShapeNode()
        restartButton.name = "restart_match"
        restartButton.zPosition = 1
        restartButton.position = CGPoint(x: (frame.size.width / 2) - 100, y: (frame.size.height / 2) - 80)
        restartButton.fillColor = SKColor.white
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: 0.0, y: 0.0))
        path1.addLine(to: CGPoint(x: 40, y: 0))
        path1.addLine(to: CGPoint(x: 40, y: 40))
        path1.addLine(to: CGPoint(x: 0, y: 40))
        path1.addLine(to: CGPoint(x: 0, y: 0))
        restartButton.path = path1
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.isHidden = true
        //Create pause button
        pauseButton = SKShapeNode()
        pauseButton.name = "pause_button"
        pauseButton.zPosition = 1
        pauseButton.position = CGPoint(x: (frame.size.width / 2) - 200, y: (frame.size.height / 2) - 80)
        pauseButton.fillColor = SKColor.white
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 0.0, y: 0.0))
        path2.addLine(to: CGPoint(x: 16, y: 0))
        path2.addLine(to: CGPoint(x: 16, y: 40))
        path2.addLine(to: CGPoint(x: 0, y: 40))
        path2.addLine(to: CGPoint(x: 0, y: 0))
        path2.addLine(to: CGPoint(x: -10, y: 0))
        path2.addLine(to: CGPoint(x: -26, y: 0))
        path2.addLine(to: CGPoint(x: -26, y: 40))
        path2.addLine(to: CGPoint(x: -10, y: 40))
        path2.addLine(to: CGPoint(x: -10, y: 0))
        pauseButton.path = path2
        pauseButton.setScale(0)
        self.addChild(pauseButton)
        pauseButton.isHidden = true
    }
    
}
