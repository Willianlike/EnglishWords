//
//  WordModel.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct WordModel: Decodable {
    
    var id: Int
    var text: String
    var meanings: [MeaningModel]
    
    var meaningsString: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case meanings
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(forKey: .id)
        text = try values.decode(forKey: .text)
        meanings = try values.decode(forKey: .meanings)
        
        meaningsString = meanings.map({ $0.translation.text }).joined(separator: ", ")
    }
    
}
