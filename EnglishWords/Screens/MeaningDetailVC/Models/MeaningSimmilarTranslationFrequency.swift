//
//  MeaningSimmilarTranslationFrequency.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

enum MeaningSimmilarTranslationFrequency {
    
    case none
    case low
    case medium
    case high
    
    init(percent: Double?) {
        guard let percent = percent else {
            self = .none
            return
        }
        if percent <= 0 {
            self = .none
        } else if percent < 33 {
            self = .low
        } else if percent < 66 {
            self = .medium
        } else {
            self = .high
        }
    }
    
}
