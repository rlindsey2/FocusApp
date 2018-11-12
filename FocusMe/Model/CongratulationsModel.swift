//
//  CongratulationsModel.swift
//  FocusMe
//
//  Created by ryan lindsey on 02/08/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

struct CongratulationsModel {
    let image: String
    let unlockedLevel: String
    let text: String
}

class CongratulationsText {
    static let shared = CongratulationsText()
    
    let levelStudent = CongratulationsModel(
        image: "icon_master_green",
        unlockedLevel: "MASTER UNLOCKED",
        text: "Congratulations, you're advancing! Expect each level to get more difficult as you progress, giving you more and more out of each session!")
    let levelMaster = CongratulationsModel(
        image: "icon_guru_green",
        unlockedLevel: "GURU UNLOCKED",
        text: "Great job! As well as the sessions getting longer, the beacons are also becoming harder to hear.")
    let levelGuru = CongratulationsModel(
        image: "icon_guru_green",
        unlockedLevel: "APP COMPLETED!",
        text: "Congratulations, you're one of the first people to complete primr! Please give us feedback below about how we can continue to keep improving the app experience.")
}
