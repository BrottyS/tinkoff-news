//
//  NewsListModel.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import CoreData

protocol INewsListModel: class {
    weak var delegate: INewsListModelDelegate? { get set }
    func fetchNewsFromCache()
    func fetchNewsFromApi()
    func incrementSeenCount(for newId: String)
}

protocol INewsListModelDelegate: class {
    func setup(dataSource: [NewsListCellDisplayModel])
    func show(error message: String)
    func updateSeenCount(for newId: String, with newValue: Int)
    func updateDataSource(with: [NewsListCellDisplayModel])
}

class NewsListModel: INewsListModel, ICacheServiceDelegate {
    
    var delegate: INewsListModelDelegate?
    
    private let tinkoffNewsService: ITinkoffNewsService
    private let cacheService: ICacheService
    
    private let kPageSize = 20
    private var first = 0
    private var last = 0
    
    init(tinkoffNewsService: ITinkoffNewsService, cacheService: ICacheService) {
        self.tinkoffNewsService = tinkoffNewsService
        self.cacheService = cacheService
        first = 0
        last = first + kPageSize
    }
    
    // MARK: - INewsListModel
    
    func fetchNewsFromCache() {
        cacheService.getNews() { (news: [TinkoffNewsListCacheModel]?, errorMessage) in
            if let news = news {
                let cells = news.map({ NewsListCellDisplayModel(id: $0.id,
                                                                date: $0.date,
                                                                text: $0.text,
                                                                seenCount: $0.seenCount) })
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: errorMessage ?? "Error")
            }
        }
    }
    
    func fetchNewsFromApi() {
        tinkoffNewsService.loadNews(first: first, last: last) { (news: [TinkoffNewsListApiModel]?, errorMessage) in
            if let news = news {
                self.cacheService.saveNews(news: news)
                
                let newsIds = news.map { $0.id }
                self.cacheService.getSeenCounts(for: newsIds) { seenCounts in
                    let cells = news.map({ NewsListCellDisplayModel(id: $0.id,
                                                                    date: $0.date,
                                                                    text: $0.text,
                                                                    seenCount: seenCounts[$0.id] ?? 0) })
                    //self.delegate?.setup(dataSource: cells)
                    self.delegate?.updateDataSource(with: cells)
                    
                    self.first += self.kPageSize
                    self.last += self.kPageSize
                }
            } else {
                self.delegate?.show(error: errorMessage ?? "Error")
            }
        }
    }
    
    func incrementSeenCount(for newId: String) {
        cacheService.incrementSeenCount(for: newId)
    }
    
    // MARK: - ICacheServiceDelegate
    
    func didIncrementSeenCount(for newId: String, newValue: Int) {
        delegate?.updateSeenCount(for: newId, with: newValue)
    }
    
}
