//
//  MeaningWithSimmilarTranslationCellVM.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct MeaningWithSimmilarTranslationCellVM: MeaningWithSimmilarTranslationCellVMProtocol {
    var frequency: MeaningSimmilarTranslationFrequency
    var partOfSpeechAbbreviation: String?
    var translation: String
    var translationNote: String?
}
