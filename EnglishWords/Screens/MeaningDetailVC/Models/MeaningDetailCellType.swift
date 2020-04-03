//
//  MeaningDetailCellType.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

enum MeaningDetailCellType {
    case difficulty(MeaningDifficultyCellVM)
    case title(SectionTitleCellVM)
    case example(MeaningExampleCellVM)
    case image(MeaningImageVM)
    case definition(MeaningDefinitionCellVM)
    case simmilars(MeaningWithSimmilarTranslationCellVM)
}
