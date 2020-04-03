//
//  MeaningWithSimilarTranslationModel.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct MeaningWithSimilarTranslationModel: Decodable {
    
    var meaningId: Int
    var frequencyPercent: Double?
    var partOfSpeechAbbreviation: String?
    var translation: TranslationModel
    
    private enum CodingKeys: String, CodingKey {
        case meaningId
        case frequencyPercent
        case partOfSpeechAbbreviation
        case translation
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        meaningId = try values.decode(forKey: .meaningId)
        if let frequencyPercentString = try values.decodeIfPresent(String.self, forKey: .frequencyPercent) {
            self.frequencyPercent = Double(frequencyPercentString)
        }
        partOfSpeechAbbreviation = try values.decode(forKey: .partOfSpeechAbbreviation)
        translation = try values.decode(forKey: .translation)
    }
    
}
