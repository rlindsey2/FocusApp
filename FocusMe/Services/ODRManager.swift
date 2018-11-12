//
//  ODRManager.swift
//  primr
//
//  Created by ryan lindsey on 12/10/2018.
//  Copyright © 2018 primr. All rights reserved.
//

import Foundation


class ODRManager {
    
    let resourceNames = [
        "level 1": "Relaxation"
    ]
    
    // MARK: - Properties
    static let shared = ODRManager()
    var currentRequest: NSBundleResourceRequest?
    
    func requestSceneWith(tag: String,
                          onSuccess: @escaping () -> Void,
                          onFailure: @escaping (NSError) -> Void) {
        
        currentRequest = NSBundleResourceRequest(tags: [tag])
        
        guard let request = currentRequest else { return }
        
        request.beginAccessingResources { (error: Error?) in
            
            if let error = error {
                onFailure(error as NSError)
                return
            }
            
            onSuccess()
        }
    }
}
