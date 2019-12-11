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

struct Points{
    var score = 0
    
    // below lays a way to score mutiple points for not hitting other objects
    func hitStreakMutitiplier(hits: Int) -> Double{
        // if they get 3 in a row with out missing they get times and a half points
        // they get 10  points per mole they hit
        // max mutipler they get is 5 once they hit more then 10 in a row
        switch hits {
        case 2...4:
            return 1.5
        case 5...8:
            return 2
        case 5...8:
            return 3.5
        default:
            return 1
        }
    }
    mutating func changeScoreMutltiplier(hitStreak:Int){
        self.score += (Int)(hitStreakMutitiplier(hits: hitStreak)*10)
    }
    
    func getMultiplier(hits: Int)-> Double{
        return hitStreakMutitiplier(hits: hits)
    }
}

