//
//  ListOfLevels.swift
//  FocusMe
//
//  Created by ryan lindsey on 10/06/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import Foundation

class ListOfLevels {
    static let sharedInstance = ListOfLevels()
    
    let allLevels = [
        Level(levelsToUnlock: 0, percentageComplete: 0, name: "Training", subHeader: "Learn how to use focus trainer in 60 seconds", duration: "60 seconds", image: "icon_training", backgroundSound: "landscapeBackground", binauralBeatSound: "2", dingSound: "Ding", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5),
        
        Level(levelsToUnlock: 1, percentageComplete: 1, name: "Anchor", subHeader: "Get started with your first session", duration: "5 min", image: "icon_anchor", backgroundSound: "landscapeBackground", binauralBeatSound: "2", dingSound: "Ding", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5),
        
        Level(levelsToUnlock: 2, percentageComplete: 0.5, name: "Helm", subHeader: "Get started with your second session", duration: "10 min", image: "icon_helm", backgroundSound: "landscapeBackground", binauralBeatSound: "2", dingSound: "Ding", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5),
        Level(levelsToUnlock: 3, percentageComplete: 1, name: "Helm", subHeader: "Get started with your third session", duration: "10 min", image: "icon_helm", backgroundSound: "landscapeBackground", binauralBeatSound: "2", dingSound: "Ding", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5),
        
        Level(levelsToUnlock: 4, percentageComplete: 0.33, name: "Submarine", subHeader: "Get started with your forth session", duration: "15 min", image: "icon_submarine", backgroundSound: "landscapeBackground", binauralBeatSound: "2", dingSound: "Ding", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5),
        Level(levelsToUnlock: 5, percentageComplete: 0.66, name: "Submarine", subHeader: "Get started with your fifth session", duration: "15 min", image: "icon_submarine", backgroundSound: "landscapeBackground", binauralBeatSound: "2", dingSound: "Ding", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5),
        Level(levelsToUnlock: 6, percentageComplete: 1, name: "Submarine", subHeader: "Get started with your sixth session", duration: "20 min", image: "icon_submarine", backgroundSound: "landscapeBackground", binauralBeatSound: "2", dingSound: "Ding", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5)
    ]
}

