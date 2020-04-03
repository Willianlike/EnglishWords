//
//  MeaningsListVCFactory.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

struct MeaningsListVCFactory: MeaningsListVCFactoryProtocol {
    func makeVC(word: WordModel) -> UIViewController {
        let vm = MeaningsListVM(word: word)
        let factory = MeaningDetailVCFactory()
        let vc = MeaningsListVC(viewModel: vm, meaningDetailVCFactory: factory)
        return vc
    }
}
