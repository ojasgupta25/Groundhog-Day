//
//  GameViewController.swift
//  Groundhog Day
//
//  Created by Garcia Jimenez, Alejandro J on 12/3/19.
//  Copyright © 2019 Garcia, Alejandro. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Foundation
import UserNotifications


class GameViewController: UIViewController
{
    @IBOutlet weak var mainView: SKView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var molesImage: [UIImageView]!
    
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var pauseView: UIView!
    @IBOutlet var pauseButton: UIButton!
    
    @IBOutlet var gameScreen: UIStackView!
    @IBOutlet var finalScore: UILabel!
    @IBOutlet var replayButton: UIButton!
    
    var moleArray: [Pit] = []
    
    var seconds = 60 //This is the set time they are allowed to play the game
    var difficulty: Double = 1 //Can be 1(easy), 2(medium), or 4(hard)
    var numberOfMoles: Double = 2 //Cannot be more than 15
    
    var score = Int()
    var combo = Int()
    var multiplier = Int()
    var pause = Bool()
    var redText = Double()

    var scene: HammerScene?
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.scene = HammerScene(size: CGSize(width: self.mainView.frame.size.width, height: self.mainView.frame.size.height))
        
        self.mainView.presentScene(scene)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for index in 0...14
        {
            molesImage[index].isHidden = true
            moleArray.append(Pit.init(index, difficulty, index))
        }
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: difficulty/numberOfMoles/10.0, target: self, selector: #selector(checkTimeRemaining), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: difficulty/numberOfMoles, target: self, selector: #selector(addMole), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(setTextToRed), userInfo: nil, repeats: true)
        
        initialize()
        
        //Turn phone into landscape
        //let value = UIInterfaceOrientation.landscapeRight.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func initialize()
    {
        seconds = 60
        
        score = Int()
        combo = Int()
        multiplier = Int()
        pause = Bool()
        redText = Double()
        
        pauseView.isUserInteractionEnabled = false
        
        scoreLabel.text = "Score: 0 Pts"
        timerLabel.text = "60s"
        finalScore.isHidden = true
        replayButton.isHidden = true
        
        gameScreen.isUserInteractionEnabled = true
        gameScreen.isHidden = false
        pauseView.isUserInteractionEnabled = true
        pauseView.isHidden = false
        pauseButton.isUserInteractionEnabled = true
        pauseButton.isHidden = false
        
        for index in 0...14
        {
            molesImage[index].isHidden = true
            moleArray.append(Pit.init(index, difficulty, index))
        }
    }
    
    @IBAction func pause(_ sender: UIButton)
    {
        pause = !pause
        //switch pause button image here
        
        if pause
        {
            pauseView.alpha = 0.3
        }
            
        else
        {
            pauseView.alpha = 0
        }
    }
    
    @IBAction func hit(_ sender: UIButton)
    {
        if !pause
        {
            if let scene = self.scene
            {
                scene.runHit(x: (buttons[sender.tag].bounds.maxX + buttons[sender.tag].bounds.minX) / 2 , y: (buttons[sender.tag].bounds.maxY + buttons[sender.tag].bounds.minY) / 2)
            }
            
            if !moleArray[sender.tag].hasHog
            {
                penalize(5)
                combo = 0
                multiplier = 0
                redText = 0.5
            }
                
            else
            {
                moleArray[sender.tag].hasHog = false
                checkMoles()
                
                combo += 1
                
                if combo % 3 == 0
                {
                    multiplier = 5 * (combo / 3)
                }
                
                score += 20 + multiplier
                scoreLabel.text = "Score: \(score) Pts"
            }
        }
    }
    
    func checkMoles()
    {
        if !pause
        {
            for index in 0...14
            {
                if moleArray[index].hasHog
                {
                    molesImage[index].isHidden = false
                }
                    
                else
                {
                    molesImage[index].isHidden = true
                }
            }
        }
    }
    
    func penalize(_ penalty: Int)
    {
        if !pause
        {
            seconds -= penalty //Five second penalty for a wrong hit
            timerLabel.text = "\(seconds)s"
        }
        
        if seconds <= 0
        {
            countDown()
        }
    }
    
    class Pit //Info on pits
    {
        var hasHog: Bool //If a hog is visibile in a pit
        var timeRemaining: Double //Time for the mole to be on the screen
        var number: Int
        
        init(_ ind: Int, _ diff: Double, _ num: Int)
        {
            hasHog = false
            timeRemaining = 2.0/diff
            number = num
        }
    }
    
    @objc func setTextToRed()
    {
        if redText > 0
        {
            timerLabel.textColor = .red
            redText -= 0.1
        }
            
        else
        {
            timerLabel.textColor = .black
        }
    }
    
    @objc func checkTimeRemaining()
    {
        var failSafe: Int
        var leastIndex: Int
        var leastLife: Double
        
        repeat
        {
            failSafe = Int() //How many moles are on the screen
            leastIndex = Int() //Mole with the lowest time left
            leastLife = 1/difficulty //Index of the mole with the lowest time left
            
            for index in 0...14
            {
                if moleArray[index].hasHog
                {
                    failSafe += 1
                    
                    if moleArray[index].timeRemaining <= leastLife
                    {
                        leastLife = moleArray[index].timeRemaining
                        leastIndex = index
                    }
                }
            }
            
            if failSafe > Int(numberOfMoles)
            {
                moleArray[leastIndex].hasHog = false
                moleArray[leastIndex].timeRemaining = 1/difficulty
                checkMoles()
            }
        } while failSafe > Int(numberOfMoles)
        
        if !pause
        {
            for mole in moleArray
            {
                if mole.hasHog
                {
                    mole.timeRemaining -= difficulty/numberOfMoles/10.0
                    
                    if mole.timeRemaining <= 0
                    {
                        mole.hasHog = false
                        molesImage[mole.number].isHidden = true
                        mole.timeRemaining = 1/difficulty
                        combo = 0
                        multiplier = 0
                    }
                }
            }
        }
    }
    
    @objc func countDown()
    {
        if seconds <= 0
        {
            gameScreen.isUserInteractionEnabled = false
            gameScreen.isHidden = true
            pauseView.isUserInteractionEnabled = false
            pauseView.isHidden = true
            pauseButton.isUserInteractionEnabled = false
            pauseButton.isHidden = true
            
            replayButton.isHidden = false
            finalScore.isHidden = false
            finalScore.text = "Final Score: \(score) Pts"
        }
        
        if !pause
        {
            seconds -= 1
            timerLabel.text = "\(seconds)s"
        }
    }
    
    @objc func addMole()
    {
        if !pause
        {
            var rand: Int
            
            repeat
            {
                rand = Int(arc4random_uniform(15))
            } while moleArray[rand].hasHog
            
            moleArray[rand].hasHog = true
            moleArray[rand].timeRemaining = 1/difficulty
            checkMoles()
        }
    }
    
    @IBAction func replay(_ sender: Any)
    {
        initialize()
    }
}
