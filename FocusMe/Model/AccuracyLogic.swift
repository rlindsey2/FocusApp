//
//  AccuracyLogic.swift
//  FocusMe
//
//  Created by ryan lindsey on 09/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

//This calculates the difference between the two numbers and returns it as number out of 100. If guess - bellcount is negative, do bellcount - guess.
func AccuracyLogic(guess: Int, actual: Int) -> Int {
    var score = 0
    
    if Int(actual) == 0 {
        return 0
    }
    
    if Int(guess) <= actual && Int(guess) > 0 {
        
        let accuracyLower = Double(guess) / Double(actual) * 100
        score = Int(accuracyLower)
    }
    if Int(guess) > actual && Int(guess) > 0 {
        let difference = Double(guess) - Double(actual)
        let accuracyHigher = ((Double(actual) - difference) / Double(actual)) * 100
        score = Int(accuracyHigher)
    }
    if Int(guess) > (actual * 2) {
        score = 0
    }
    return score
}
