//
//  CacheService.swift
//  TinkoffNews
//
//  Created by BrottyS on 30.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import CoreData

protocol ICacheService: class {
    weak var delegate: ICacheServiceDelegate? { get set }
    func getNews(completion: @escaping ([TinkoffNewsListCacheModel]?, String?) -> ())
    func saveNews(news: [TinkoffNewsListApiModel])
    func getNewDetail(newId: String, completion: @escaping (TinkoffNewsDetailCacheModel?, String?) -> ())
    func saveNewDetail(newDetail: TinkoffNewsDetailApiModel, for newId: String)
    func incrementSeenCount(for newId: String)
}

protocol ICacheServiceDelegate: class {
    func didIncrementSeenCount(for newId: String, newValue: Int)
}

class CacheService: ICacheService, ICacheManagerDelegate {
    
    var delegate: ICacheServiceDelegate?
    
    private let cacheManager: ICacheManager
    
    init(cacheManager: ICacheManager) {
        self.cacheManager = cacheManager
    }
    
    // MARK: - ICacheService
    
    func getNews(completion: @escaping ([TinkoffNewsListCacheModel]?, String?) -> ()) {
        cacheManager.getNews { (news, error) in
            completion(news, error)
        }
    }
    
    func saveNews(news: [TinkoffNewsListApiModel]) {
        cacheManager.saveNews(news: news)
    }
    
    func getNewDetail(newId: String, completion: @escaping (TinkoffNewsDetailCacheModel?, String?) -> ()) {
        cacheManager.getNewDetail(newId: newId) { (newDetail, error) in
            completion(newDetail, error)
        }
    }
    
    func saveNewDetail(newDetail: TinkoffNewsDetailApiModel, for newId: String) {
        cacheManager.saveNewDetail(detail: newDetail, for: newId)
    }
    
    func incrementSeenCount(for newId: String) {
        cacheManager.incrementSeenCount(for: newId)
    }
    
    // MARK: - ICacheManagerDelegate
    
    func didIncrementSeenCount(for newId: String, newValue: Int) {
        delegate?.didIncrementSeenCount(for: newId, newValue: newValue)
    }
    
}
