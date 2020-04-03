//
//  MeaningsListVCFactoryProtocol.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningsListVCFactoryProtocol {
    func makeVC(word: WordModel) -> UIViewController
}
