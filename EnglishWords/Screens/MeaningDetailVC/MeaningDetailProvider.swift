//
//  MeaningDetailProvider.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

class MeaningDetailProvider: BaseNetworkProvider, MeaningDetailProviderProtocol {
    
    func getFullMeanings(ids: [Int],
                         completion: @escaping MeaningDetailCompletion) -> URLSessionTask? {
        let path = "/api/public/v1/meanings"
        let params: [String : String?] = [
            "ids": ids.map({ String($0) }).joined(separator: ",")
        ]
        return makeGetTask(path: path, parameters: params) { [weak self] (data, response, error) in
            guard let self = self else { return }
            completion(self.parse(data: data, response: response, error: error))
        }
    }
    
}
