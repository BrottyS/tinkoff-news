//
//  CacheManager.swift
//  TinkoffNews
//
//  Created by BrottyS on 30.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import CoreData

protocol ICacheManager: class {
    func getNews(completion: @escaping ([TinkoffNewsListCacheModel]?, String?) -> ())
    func saveNews(news: [TinkoffNewsListApiModel])
}

class CacheManager: ICacheManager {
    
    private let coreDataStack: ICoreDataStack
    
    private let kFetchLimitNews = 20
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - ICacheManager
    
    func getNews(completion: @escaping ([TinkoffNewsListCacheModel]?, String?) -> ()) {
        let context = coreDataStack.mainContext
        
        let fetchRequest = New.fetchRequestNews(in: context)
        fetchRequest.fetchLimit = kFetchLimitNews
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        var entities: [NSManagedObject] = []
        do {
            entities = try context.fetch(fetchRequest)
        } catch let error {
            completion(nil, "Error while fetch news \(error)")
            return
        }
        
        var news: [TinkoffNewsListCacheModel] = []
        for entity in entities {
            guard let entity = entity as? New,
                let id = entity.id,
                let date = entity.date,
                let text = entity.text
            else { continue }
            
            let new = TinkoffNewsListCacheModel(id: id,
                                                date: date,
                                                text: text,
                                                seenCount: Int(entity.seenCount))
            news.append(new)
            
        }
        completion(news, nil)
    }
    
    func saveNews(news: [TinkoffNewsListApiModel]) {
        let context = coreDataStack.saveContext
        
        for new in news {
            if let _ = New.fetchNew(with: new.id, in: context) {
                continue
            }
            
            if let newEntity = New.insertNew(with: new.id, in: context) {
                newEntity.id = new.id
                newEntity.date = new.date
                newEntity.text = new.text
            }
        }
        
        performSave(context: context)
    }
    
    private func performSave(context: NSManagedObjectContext) {
        if context.hasChanges {
            context.perform({ [weak self] in
                do {
                    try context.save()
                    print("Save successful")
                } catch {
                    print("Context save error: \(error)")
                }
                if let parent = context.parent {
                    self?.performSave(context: parent)
                }
            })
        }
    }
    
}
