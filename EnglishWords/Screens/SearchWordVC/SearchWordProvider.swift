//
//  SearchWordProvider.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

class SearchWordProvider: BaseNetworkProvider, SearchWordProviderProtocol {
    
    func search(query: String?,
                page: Int,
                pageSize: Int,
                completion: @escaping SearchWordCompletion) -> URLSessionTask? {
        let path = "/api/public/v1/words/search"
        let params: [String : String?] = [
            "search": query,
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
        return makeGetTask(path: path, parameters: params) { [weak self] (data, response, error) in
            guard let self = self else { return }
            completion(self.parse(data: data, response: response, error: error))
        }
    }
    
}
