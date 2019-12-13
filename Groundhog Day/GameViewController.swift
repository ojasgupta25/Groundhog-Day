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
    @IBOutlet var mainView: SKView!
    @IBOutlet var buttonArray: [UIButton]!
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var moleImageArray: [UIImageView]!
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    var scene: HammerScene?
    
    var moleArray: [Pit] = []
    
    var seconds = 60 //This is the set time they are allowed to play the game
    var difficulty: Double = 1 //Can be 1(easy), 2(medium), or 4(hard)
    var numberOfMoles: Double = 2 //Cannot be more than 15
    
    var score = Int()
    var combo = Int()
    var multiplier = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for (index, mole) in moleImageArray.enumerated()
        {
            mole.isHidden = true
            moleArray.append(Pit.init(index, difficulty))
        }
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: difficulty/numberOfMoles/10.0, target: self, selector: #selector(checkTimeRemaining), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: difficulty/numberOfMoles, target: self, selector: #selector(addMole), userInfo: nil, repeats: true)
        
        //Turn phone into landscape
        //let value = UIInterfaceOrientation.landscapeRight.rawValue
        //UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.scene = HammerScene(size: CGSize(width: self.mainView.frame.size.width, height: self.mainView.frame.size.height))
        self.mainView.presentScene(scene)
    }
    
    @IBAction func Hit(_ sender: UIButton)
    {
        if let scene = self.scene
        {
            scene.runHit(x: (buttonArray[8].bounds.maxX + buttonArray[0].bounds.minX)/2 , y: (buttonArray[8].bounds.maxY + buttonArray[0].bounds.minY)/2)
        }
        
        if !moleArray[sender.tag].hasHog
        {
            penalize(5)
            combo = 0
            multiplier = 0
        }
        
        else
        {
            //remove mole here
            
            combo += 1
            
            if combo % 3 == 0
            {
                multiplier = 5 * (combo / 3)
            }
            
            score += 20 + multiplier
            scoreLabel.text = "\(score) Pts"
        }
    }
    
    func checkMoles()
    {
        for (index, mole) in moleArray.enumerated()
        {
            if mole.hasHog
            {
                moleImageArray[index].isHidden = false
            }
            
            else
            {
                moleImageArray[index].isHidden = true
            }
        }
    }
    
    func penalize(_ penalty: Int)
    {
        seconds -= penalty //Five second penalty for a wrong hit
        timerLabel.text = "Time Left: \(seconds)s"
    }
    
    class Pit //Info on pits
    {
        var hasHog: Bool //If a hog is visibile in a pit
        var timeRemaining: Double //Time for the mole to be on the screen
        
        init(_ ind: Int, _ diff: Double)
        {
            hasHog = false
            timeRemaining = 2.0/diff
        }
    }
    
    @objc func checkTimeRemaining()
    {
        var failSafe = Int() //How many moles are on the screen
        var leastIndex = Int() //Mole with the lowest time left
        var leastLife: Double = 1/difficulty //Index of the mole with the lowest time left
        
        for (index, mole) in moleArray.enumerated()
        {
            if mole.hasHog
            {
                failSafe += 1
                
                if mole.timeRemaining <= leastLife
                {
                    leastLife = mole.timeRemaining
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
        
        for mole in moleArray
        {
            if mole.hasHog
            {
                mole.timeRemaining -= difficulty/numberOfMoles/10.0
                
                if mole.timeRemaining <= 0
                {
                    mole.hasHog = false
                    mole.timeRemaining = 1/difficulty
                    checkMoles()
                }
            }
        }
    }
    
    @objc func countDown()
    {
        seconds -= 1
        timerLabel.text = "\(seconds)s"
    }
    
    @objc func addMole()
    {
        var rand: Int
        
        repeat
        {
            rand = Int(arc4random_uniform(15))
        } while moleArray[rand].hasHog
        
        moleArray[rand].hasHog = true
        checkMoles()
    }
}




