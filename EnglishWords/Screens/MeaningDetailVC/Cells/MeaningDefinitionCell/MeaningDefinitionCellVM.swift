//
//  MeaningDefinitionCellVM.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

struct MeaningDefinitionCellVM: MeaningDefinitionCellVMProtocol {
    var word: String
    var prefix: String?
    var definition: String
    var translation: String
    var translationNote: String?
    var transcription: String?
}
