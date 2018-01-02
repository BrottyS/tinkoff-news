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
}

protocol INewsListModelDelegate: class {
    func setup(dataSource: [NewsListCellDisplayModel])
    func show(error message: String)
}

class NewsListModel: INewsListModel {
    
    var delegate: INewsListModelDelegate?
    
    private let tinkoffNewsService: ITinkoffNewsService
    private let cacheService: ICacheService
    
    init(tinkoffNewsService: ITinkoffNewsService, cacheService: ICacheService) {
        self.tinkoffNewsService = tinkoffNewsService
        self.cacheService = cacheService
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
        tinkoffNewsService.loadNews { (news: [TinkoffNewsListApiModel]?, errorMessage) in
            if let news = news {
                self.cacheService.saveNews(news: news)
                let cells = news.map({ NewsListCellDisplayModel(id: $0.id,
                                                                date: $0.date,
                                                                text: $0.text,
                                                                seenCount: 0) })
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: errorMessage ?? "Error")
            }
        }
    }
    
}
