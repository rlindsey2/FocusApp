//
//  CoreData Model.swift
//  FocusMe
//
//  Created by ryan lindsey on 04/07/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData

class CoreDataModel {
    static let sharedInstance = CoreDataModel()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    
    func countOfCompletedLevels() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")

        request.returnsObjectsAsFaults = false
        var count = 0
        do {
            let result = try context.fetch(request)
            count = result.count
        } catch {
            print(error)
        }
        return count
    }
}
