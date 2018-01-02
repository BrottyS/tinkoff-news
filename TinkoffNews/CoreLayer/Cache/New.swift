//
//  New.swift
//  TinkoffNews
//
//  Created by BrottyS on 30.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import CoreData

extension New {
    
    static func findOrInsertNew(with id: String, in context: NSManagedObjectContext) -> New? {
        if let new = fetchNew(with: id, in: context) {
            return new
        } else {
            return insertNew(with: id, in: context)
        }
    }
    
    static func fetchNew(with id: String, in context: NSManagedObjectContext) -> New? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        
        guard let fetchRequest = New.fetchRequestNew(with: id, model: model) else { return nil }
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch New with id: \(id) \(error)")
            return nil
        }
    }
    
    static func fetchRequestNew(with id: String, model: NSManagedObjectModel) -> NSFetchRequest<New>? {
        let templateName = "NewWithId"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["newId": id]) as? NSFetchRequest<New> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest
    }
    
    static func insertNew(with id: String, in context: NSManagedObjectContext) -> New? {
        if let new = NSEntityDescription.insertNewObject(forEntityName: "New", into: context) as? New {
            new.id = id
            return new
        }
        
        return nil
    }
    
    static func fetchRequestNews(in context: NSManagedObjectContext) -> NSFetchRequest<New> {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            preconditionFailure("Model is not available in context")
        }
        let templateName = "AllNews"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: [:]) as? NSFetchRequest<New> else {
            preconditionFailure("No template with \(templateName) name")
        }
        return fetchRequest
    }
    
}
