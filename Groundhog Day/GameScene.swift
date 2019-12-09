//
//  GameScene.swift
//  Groundhog Day
//
//  Created by Garcia Jimenez, Alejandro J, Andrew Vilarreal, Cole, and Ojas on 12/3/19.
//  Copyright © 2019 Garcia, Alejandro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene
{
    
}

struct Timer{
    var time = 60//This is the set time they are allowed to play the game
    //this function is the core to the count down timer loop
    //(this should be placed in a loop in view controller)
    mutating func countDown(penalty: Int){
        time = time-(penalty)
    }
}
