//
//  TinkoffNewsListParser.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

import Foundation

class TinkoffNewsListParser: IParser {
    
    typealias Model = [TinkoffNewsListApiModel]
    
    func parse(data: Data) -> [TinkoffNewsListApiModel]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let payload = json["payload"] as? [[String : Any]] else {
                return nil
            }
            
            var news: [TinkoffNewsListApiModel] = []
            
            for new in payload {
                guard let id = new["id"] as? String,
                    let text = new["text"] as? String,
                    let publicationDate = new["publicationDate"] as? [String: Int],
                    let milliseconds = publicationDate["milliseconds"]
                    else { continue }

                let date = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
                
                news.append(TinkoffNewsListApiModel(id: id,
                                                    date: date,
                                                    text: text))
            }
            
            return news
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
    
}
