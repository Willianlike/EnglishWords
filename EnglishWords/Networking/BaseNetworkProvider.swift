//
//  BaseNetworkProvider.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

class BaseNetworkProvider {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    var baseUrl: String { "https://dictionary.skyeng.ru" }
    
}

extension BaseNetworkProvider {
    
    func parse<T: Decodable>(data: Data?,
                             response: URLResponse?,
                             error: Error?) -> Result<T, Error> {
        if let data = data {
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedResponse)
            } catch {
                return .failure(error)
            }
        } else if let error = error {
            return .failure(error)
        } else {
            return .failure(APIError.invalidResponse)
        }
    }
    
    func makeGetTask(path: String?,
                     parameters: [String: String?]? = nil,
                     completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionTask? {
        guard let urlRequest = makeUrlRequest(method: .get,
                                              path: path,
                                              parameters: parameters) else { return nil }
        let task = session.dataTask(with: urlRequest, completionHandler: completion)
        task.resume()
        return task
    }
    
    func makePostTask(path: String?,
                      body: Data? = nil,
                      completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) -> URLSessionTask? {
        guard let urlRequest = makeUrlRequest(method: .post,
                                              path: path,
                                              body: body) else { return nil }
        let task = session.dataTask(with: urlRequest, completionHandler: completion)
        task.resume()
        return task
    }
    
    private func makeUrlRequest(method: HTTPMethod,
                                path: String?,
                                parameters: [String: String?]? = nil,
                                body: Data? = nil) -> URLRequest? {
        
        guard var url = URL(string: baseUrl) else { return nil }
        if let path = path {
            url.appendPathComponent(path)
        }
        guard var urlComponets = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        if let params = parameters {
            var queryItems = [URLQueryItem]()
            for (key, value) in params {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponets.queryItems = queryItems
        }
        guard let resultUrl = urlComponets.url else { return nil }
        var urlRequest = URLRequest(url: resultUrl)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        return urlRequest
    }
    
}
