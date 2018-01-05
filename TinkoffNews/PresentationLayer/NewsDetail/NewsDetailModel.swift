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
    func setup(data: NewsDetailDisplayModel)
    func show(error message: String)
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
        cacheService.getNewDetail(newId: newId) { (newDetail: TinkoffNewsDetailCacheModel?, errorMessage) in
            if let newDetail = newDetail {
                let data = NewsDetailDisplayModel(content: newDetail.content)
                self.delegate?.setup(data: data)
            } else {
                self.delegate?.show(error: errorMessage ?? "Error")
            }
        }
    }
    
    func fetchNewDetailFromApi() {
        tinkoffNewsService.loadNewDetail(newId: newId) { (newDetail: TinkoffNewsDetailApiModel?, errorMessage) in
            if let newDetail = newDetail {
                //self.cacheService.saveNews(news: news)
                self.cacheService.saveNewDetail(newDetail: newDetail, for: self.newId)
                let data = NewsDetailDisplayModel(content: newDetail.content)
                self.delegate?.setup(data: data)
            } else {
                self.delegate?.show(error: errorMessage ?? "Error")
            }
        }
    }
    
}
