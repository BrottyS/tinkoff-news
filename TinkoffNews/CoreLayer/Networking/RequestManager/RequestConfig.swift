//
//  RequestConfig.swift
//  TinkoffNews
//
//  Created by BrottyS on 29.12.2017.
//  Copyright © 2017 BrottyS. All rights reserved.
//

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}
