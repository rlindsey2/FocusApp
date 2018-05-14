//
//  ProfileDataStore.swift
//  FocusMe
//
//  Created by ryan lindsey on 08/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//
import HealthKit

class ProfileDataStore {
    
    class func saveMindfulSession(startDate: Date, endDate: Date) {
        
        //1.  Make sure the mindfulSessino exists
        guard let mindfulType = HKCategoryType.categoryType(forIdentifier: .mindfulSession) else {
            fatalError("Body Mass Index Type is no longer available in HealthKit")
        }

        
        //2.  Use the Count HKUnit to create a body mass quantity
        let mindfulSample = HKCategorySample(type: mindfulType,
                                             value: 0,
                                             start: startDate,
                                             end: endDate)
        
        
        //3.  Save the sample to HealthKit
        HKHealthStore().save(mindfulSample) { (success, error) in
            
            if let error = error {
                print("Error Saving mindful minute sample: \(error.localizedDescription)")
            } else {
                print("Successfully saved mindful session sample")
            }
        }
    }
}
