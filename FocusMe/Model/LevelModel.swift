//
//  LevelModel.swift
//  FocusMe
//
//  Created by ryan lindsey on 09/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import Foundation

struct Level {
    let levelsToUnlock: Int
    let percentageComplete: Double
    let name: String
    let subHeader: String
    let duration: Int
    let image: String
    let backgroundSound: String
    let dingSound: String?
    let randomUpperNumberDifficulty: UInt32
    let randomLowerNumberDifficulty: UInt32
}


struct SessionResult {
    let date: Date
    let name: String
    let bellCountGuess: Int
    let bellCountActual: Int
    let score: Int
}
