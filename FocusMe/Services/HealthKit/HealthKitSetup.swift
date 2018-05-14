//
//  HealthKitSetup.swift
//  FocusMe
//
//  Created by ryan lindsey on 08/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import HealthKit

class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {

        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
        completion(false, HealthkitSetupError.notAvailableOnDevice)
        return
        }
        
        //2. Prepare the data types that will interact with HealthKit
        guard let mindfulMinutes = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
        
        completion(false, HealthkitSetupError.dataTypeNotAvailable)
        return
        }
        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [mindfulMinutes,
                                                        HKObjectType.categoryType(forIdentifier: .mindfulSession)!]
        
        let healthKitTypesToRead: Set<HKObjectType> = [mindfulMinutes,
                                                        HKObjectType.categoryType(forIdentifier: .mindfulSession)!]
        
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead) { (success, error) in
                                                completion(success, error)
        }
    }
}
