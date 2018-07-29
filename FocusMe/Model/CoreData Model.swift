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
    
    
    func countLevels() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")

        request.returnsObjectsAsFaults = false
        var count = 0
        do {
            let result = try context.fetch(request)
            count = result.count
        } catch {
            print(error)
        }
        print("thy score is \(count)")
        return count
    }
//
//    func lastLevel() -> String {
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")
//
//        var listOfCompletedLevels: [String] = []
//        request.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(request)
//
//            for data in result as! [NSManagedObject] {
//
//                listOfCompletedLevels.append(data.value(forKey: "level") as! String)
//            }
//
//        } catch {
//            print("Failed")
//        }
//
//        guard let unwrappedLevel = listOfCompletedLevels.last else { return "none" }
//
//        return unwrappedLevel
//    }
    
//    func countOfLevels(name:String) -> Int {
//
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")
//
//            var count = 0
//            request.returnsObjectsAsFaults = false
//            do {
//                let result = try context.fetch(request)
//
//                for data in result as! [NSManagedObject] {
//                    let sessionName = name
//                    count += (data.value(forKey: "level") as! String) == sessionName ? 1 : 0
//                }
//
//            } catch {
//                print("Failed")
//            }
//        return count
//    }
}
