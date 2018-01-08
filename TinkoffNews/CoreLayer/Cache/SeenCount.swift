//
//  SeenCount.swift
//  TinkoffNews
//
//  Created by BrottyS on 08.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

import CoreData

extension SeenCount {
    
    static func insertSeenCount(in context: NSManagedObjectContext) -> SeenCount? {
        if let seenCount = NSEntityDescription.insertNewObject(forEntityName: "SeenCount", into: context) as? SeenCount {
            return seenCount
        }
        
        return nil
    }
    
}
