//
//  MeaningDetailVCFactoryProtocol.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningDetailVCFactoryProtocol {
    func makeVC(meaningId: Int) -> UIViewController
}
