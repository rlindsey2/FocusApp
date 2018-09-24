//
//  ListOfLevels.swift
//  FocusMe
//
//  Created by ryan lindsey on 10/06/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

class ListOfLevels {
    static let sharedInstance = ListOfLevels()
    
    let allLevels = [
        Level(levelsToUnlock: 0, percentageComplete: 0, name: "TRAINING", subHeader: "Learn how to use primr in under 3 minutes", duration: 173, image: "icon_training", backgroundSound: "Training_session", dingSound: "1", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 5),
        
        Level(levelsToUnlock: 1, percentageComplete: 1, name: "ANCHOR", subHeader: "Get started with your first session", duration: 300, image: "icon_anchor", backgroundSound: "Underwater_main_audio_Big_Blue", dingSound: "Underwater_beacon", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 7),
        
        Level(levelsToUnlock: 2, percentageComplete: 0.5, name: "HELM", subHeader: "Get started with your second session", duration: 600, image: "icon_helm", backgroundSound: "Underwater_main_audio_Big_Blue", dingSound: "Underwater_beacon", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 9),
        Level(levelsToUnlock: 3, percentageComplete: 1, name: "HELM", subHeader: "Get started with your third session", duration: 600, image: "icon_helm", backgroundSound: "Underwater_main_audio_Big_Blue", dingSound: "Underwater_beacon", randomUpperNumberDifficulty: 25, randomLowerNumberDifficulty: 11),
        
        Level(levelsToUnlock: 4, percentageComplete: 0.33, name: "SUBMARINE", subHeader: "Get started with your forth session", duration: 900, image: "icon_submarine", backgroundSound: "Underwater_main_audio_Big_Blue", dingSound: "Underwater_beacon", randomUpperNumberDifficulty: 30, randomLowerNumberDifficulty: 13),
        Level(levelsToUnlock: 5, percentageComplete: 0.66, name: "SUBMARINE", subHeader: "Get started with your fifth session", duration: 900, image: "icon_submarine", backgroundSound: "Underwater_main_audio_Big_Blue", dingSound: "Underwater_beacon", randomUpperNumberDifficulty: 30, randomLowerNumberDifficulty: 15),
        Level(levelsToUnlock: 6, percentageComplete: 1, name: "SUBMARINE", subHeader: "Get started with your sixth session", duration: 1200, image: "icon_submarine", backgroundSound: "Underwater_main_audio_Big_Blue", dingSound: "Underwater_beacon", randomUpperNumberDifficulty: 30, randomLowerNumberDifficulty: 17)
    ]
}

