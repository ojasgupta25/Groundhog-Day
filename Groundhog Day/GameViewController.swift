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
    @IBOutlet weak var sceneView: SKView!
    
    @IBOutlet var mainView: SKView!
    @IBOutlet var buttonArray: [UIButton]!
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var moleImageArray: [UIImageView]!
    
    @IBOutlet var timerLabel: UILabel!
    var scene: HammerScene?
    
    
    var moleObj: [Pit] = []
    
    var seconds = 60 //This is the set time they are allowed to play the game
    var difficulty: Double = 1 //Can be 1(easy), 2(medium), or 4(hard)
    var numberOfMoles: Double = 2 //Cannot be more than 15
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sceneView.alpha = 0.1
        
        for (index, mole) in moleImageArray.enumerated()
        {
            mole.isHidden = true
            moleObj.append(Pit.init(index, difficulty))
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
        
        self.scene = HammerScene(size: CGSize(width: self.sceneView.frame.size.width, height: self.sceneView.frame.size.height))
        self.sceneView.presentScene(scene)
    }
    
    @IBAction func Hit(_ sender: UIButton)
    {
        if let scene = self.scene {
            scene.runHit(x: (buttonArray[8].bounds.maxX + buttonArray[0].bounds.minX)/2 , y: (buttonArray[8].bounds.maxY + buttonArray[0].bounds.minY)/2)
        }
    } 
    
    @objc func checkTimeRemaining()
    {
        var failSafe = Int() //How many moles are on the screen
        var leastIndex = Int() //Mole with the lowest time left
        var leastLife: Double = 1/difficulty //Index of the mole with the lowest time left
        
        for (index, obj) in moleObj.enumerated()
        {
            if obj.hasHog
            {
                failSafe += 1
                
                if obj.timeRemaining <= leastLife
                {
                    leastLife = obj.timeRemaining
                    leastIndex = index
                }
            }
        }
        
        if failSafe > Int(numberOfMoles)
        {
            moleObj[leastIndex].hasHog = false
            moleObj[leastIndex].timeRemaining = 1/difficulty
            checkMoles()
        }
        
        for obj in moleObj
        {
            if obj.hasHog
            {
                obj.timeRemaining -= difficulty/numberOfMoles/10.0
                
                if obj.timeRemaining <= 0
                {
                    obj.hasHog = false
                    obj.timeRemaining = 1/difficulty
                    checkMoles()
                }
            }
        }
    }
    
    func checkMoles()
    {
        for (index, obj) in moleObj.enumerated()
        {
            if obj.hasHog
            {
                moleImageArray[index].isHidden = false
            }
            
            else
            {
                moleImageArray[index].isHidden = true
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
        } while moleObj[rand].hasHog
        
        moleObj[rand].hasHog = true
        checkMoles()
    }
    
    func penalize(penalty: Int)
    {
        seconds -= penalty
        timerLabel.text = "\(seconds)s"
    }
    
    @IBAction func tapPit(_ sender: UIButton) //If the player taps the pit
    {
        
    }
    
    class Pit
    {
        var index: Int //Index of buttonArray, viewArray, moleImageArray
        var hasHog: Bool //If a hog is visibile in a pit
        var timeRemaining: Double //Time for the mole to be on the screen
        
        init(_ ind: Int, _ diff: Double)
        {
            index = ind
            hasHog = false
            timeRemaining = 2.0/diff
        }
    }
}




