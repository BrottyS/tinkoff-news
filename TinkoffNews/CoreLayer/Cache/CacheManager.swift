//
//  CacheManager.swift
//  TinkoffNews
//
//  Created by BrottyS on 30.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import CoreData

protocol ICacheManager: class {
    weak var delegate: ICacheManagerDelegate? { get set }
    func getNews(completion: @escaping ([TinkoffNewsListCacheModel]?, String?) -> ())
    func saveNews(news: [TinkoffNewsListApiModel])
    func getNewDetail(newId: String, completion: @escaping (TinkoffNewsDetailCacheModel?, String?) -> ())
    func saveNewDetail(detail: TinkoffNewsDetailApiModel, for newId: String)
    func incrementSeenCount(for newId: String)
}

protocol ICacheManagerDelegate: class {
    func didIncrementSeenCount(for newId: String, newValue: Int)
}

class CacheManager: ICacheManager {
    
    var delegate: ICacheManagerDelegate?
    
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
            let seenCount = entity.seenCount?.value ?? 0
            
            let new = TinkoffNewsListCacheModel(id: id,
                                                date: date,
                                                text: text,
                                                seenCount: Int(seenCount))
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
        
        _ = performSave(context: context)
    }
    
    func getNewDetail(newId: String, completion: @escaping (TinkoffNewsDetailCacheModel?, String?) -> ()) {
        let context = coreDataStack.mainContext
        
        guard let new = New.fetchNew(with: newId, in: context) else {
            completion(nil, "Not found new with newId \(newId)")
            return
        }
        
        let newDetail = TinkoffNewsDetailCacheModel(content: new.content?.content ?? "")
        completion(newDetail, nil)
    }
    
    func saveNewDetail(detail: TinkoffNewsDetailApiModel, for newId: String) {
        let context = coreDataStack.saveContext
        
        guard let new = New.fetchNew(with: newId, in: context) else {
            return
        }
        
        if let newDetailEntity = NewContent.insertNewContent(in: context) {
            newDetailEntity.content = detail.content
            new.content = newDetailEntity
        }
        
        _ = performSave(context: context)
    }
    
    func incrementSeenCount(for newId: String) {
        let context = coreDataStack.saveContext
        
        guard let new = New.fetchNew(with: newId, in: context) else {
            return
        }
        
        var newValue: Int = 0
        if let seenCount = new.seenCount {
            seenCount.value += 1
            newValue = Int(seenCount.value)
        } else {
            if let seenCount = SeenCount.insertSeenCount(in: context) {
                seenCount.value = 1
                newValue = Int(seenCount.value)
                new.seenCount = seenCount
            }
        }
        
        if performSave(context: context) {
            delegate?.didIncrementSeenCount(for: newId, newValue: newValue)
        }
    }
    
    // MARK: - Private methods
    
    private func performSave(context: NSManagedObjectContext) -> Bool {
        var saveSuccessfully = true
        if context.hasChanges {
            context.perform({ [weak self] in
                do {
                    try context.save()
                    saveSuccessfully = true
                    print("Save successful")
                } catch {
                    saveSuccessfully = false
                    print("Context save error: \(error)")
                }
                if let parent = context.parent {
                    if let unwrappedSelf = self {
                        saveSuccessfully = unwrappedSelf.performSave(context: parent)
                    }
                }
            })
        }
        
        return saveSuccessfully
    }
    
}
