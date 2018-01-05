//
//  NewContent.swift
//  TinkoffNews
//
//  Created by BrottyS on 03.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

import CoreData

extension NewContent {
    
    static func fetchNewContent(with newId: String, in context: NSManagedObjectContext) -> NewContent? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        
        guard let fetchRequest = NewContent.fetchRequestNewContent(with: newId, model: model) else { return nil }
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch NewContent with newId: \(newId) \(error)")
            return nil
        }
    }
    
    static func fetchRequestNewContent(with newId: String, model: NSManagedObjectModel) -> NSFetchRequest<NewContent>? {
        let templateName = "ContentByNewId"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["newId": newId]) as? NSFetchRequest<NewContent> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        
        return fetchRequest
    }
    
    static func insertNewContent(in context: NSManagedObjectContext) -> NewContent? {
        if let newContent = NSEntityDescription.insertNewObject(forEntityName: "NewContent", into: context) as? NewContent {
            return newContent
        }
        
        return nil
    }
    
}
