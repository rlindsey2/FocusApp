//
//  LevelModel.swift
//  FocusMe
//
//  Created by ryan lindsey on 09/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import Foundation

enum LevelDifficulty {
    case Beginner
    case Intermediate
    case Advanced
}

class level {
    var level: LevelDifficulty
    var BackgroundSong: String
    var BellSound: String
    var randomUpperNumberDifficulty: Int
    var randomLowerNumberDifficulty: Int
    
    init?(level: LevelDifficulty, BackgroundSong: String, BellSound: String, randomUpperNumberDifficulty: Int, randomLowerNumberDifficulty: Int) {
        self.level = level
        self.BackgroundSong = BackgroundSong
        self.BellSound = BellSound
        self.randomUpperNumberDifficulty = randomUpperNumberDifficulty
        self.randomLowerNumberDifficulty = randomLowerNumberDifficulty
    }
}

//Defines what is associated with every saved result
struct SessionResult {
    let date: Date
    let level: LevelDifficulty
    let bellCountGuess: Int
    let bellCountActual: Int
    let score: Int
}
