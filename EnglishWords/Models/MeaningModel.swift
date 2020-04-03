//
//  MeaningModel.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct MeaningModel: Decodable {
    
    var id: Int
    var partOfSpeechCode: PartOfSpeechCodeModel
    var translation: TranslationModel
    var previewUrl: String?
    var imageUrl: String?
    var transcription: String
    var soundUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case partOfSpeechCode
        case translation
        case previewUrl
        case imageUrl
        case transcription
        case soundUrl
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(forKey: .id)
        let partOfSpeechCode = try values.decode(String.self, forKey: .partOfSpeechCode)
        self.partOfSpeechCode = PartOfSpeechCodeModel(rawValue: partOfSpeechCode) ?? .noun
        translation = try values.decode(forKey: .translation)
        previewUrl = try values.decodeUrl(forKey: .previewUrl)
        imageUrl = try values.decodeUrl(forKey: .imageUrl)
        transcription = try values.decode(forKey: .transcription)
        soundUrl = try values.decodeUrl(forKey: .soundUrl)
    }
    
}
