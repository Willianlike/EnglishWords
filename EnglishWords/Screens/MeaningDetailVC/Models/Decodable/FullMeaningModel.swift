//
//  FullMeaningModel.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct FullMeaningModel: Decodable {
    
    var id: String
    var wordId: Int
    var difficultyLevel: Int?
    var prefix: String?
    var text: String
    var soundUrl: String?
    var transcription: String?
    var translation: TranslationModel
    var images: [ImageUrlModel]
    var definition: TextWithSoundModel
    var examples: [TextWithSoundModel]
    var meaningsWithSimilarTranslation: [MeaningWithSimilarTranslationModel]
    
}
