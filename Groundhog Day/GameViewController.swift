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

class GameViewController: UIViewController
{
    @IBOutlet var mainView: SKView!
    @IBOutlet var buttonArray: [UIButton]!
    @IBOutlet var viewArray: [UIView]!
    @IBOutlet var moleImageArray: [UIImageView]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}

class Pit
{
    var index = Int()
    var hasHog = Bool()
    
    @IBAction func tapPit(_ sender: UIButton)
    {
        if !hasHog
        {
            
        }
        
        else
        {
            
        }
    }
}
