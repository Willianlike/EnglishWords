//
//  TextWithSoundModel.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct TextWithSoundModel: Decodable {
    
    var text: String
    var soundUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case text
        case soundUrl
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decode(forKey: .text)
        soundUrl = try values.decodeUrl(forKey: .soundUrl)
    }
    
}
