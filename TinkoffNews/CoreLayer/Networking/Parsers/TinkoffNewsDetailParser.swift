//
//  TinkoffNewsDetailParser.swift
//  TinkoffNews
//
//  Created by BrottyS on 03.01.2018.
//  Copyright © 2018 BrottyS. All rights reserved.
//

import Foundation

class TinkoffNewsDetailParser: IParser {
    
    typealias Model = TinkoffNewsDetailApiModel
    
    func parse(data: Data) -> TinkoffNewsDetailApiModel? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let payload = json["payload"] as? [String: Any],
                let content = payload["content"] as? String else {
                return nil
            }
            
            return TinkoffNewsDetailApiModel(content: content)
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
    
}
