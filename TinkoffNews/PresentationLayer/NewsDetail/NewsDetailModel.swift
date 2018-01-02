//
//  NewsDetailModel.swift
//  TinkoffNews
//
//  Created by BrottyS on 02.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

protocol INewsDetailModel: class {
    weak var delegate: INewsDetailModelDelegate? { get set }
    func fetchNewDetailFromCache()
    func fetchNewDetailFromApi()
}

protocol INewsDetailModelDelegate: class {
    
}

class NewsDetailModel: INewsDetailModel {
    
    private let tinkoffNewsService: ITinkoffNewsService
    private let cacheService: ICacheService
    private let newId: String
    
    var delegate: INewsDetailModelDelegate?
    
    init(tinkoffNewsService: ITinkoffNewsService, cacheService: ICacheService, newId: String) {
        self.tinkoffNewsService = tinkoffNewsService
        self.cacheService = cacheService
        self.newId = newId
    }
    
    // MARK: - INewsDetailModel
    
    func fetchNewDetailFromCache() {
        
    }
    
    func fetchNewDetailFromApi() {
        
    }
    
}
