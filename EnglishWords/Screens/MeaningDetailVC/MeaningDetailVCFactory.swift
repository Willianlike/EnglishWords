//
//  MeaningDetailVCFactory.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

struct MeaningDetailVCFactory: MeaningDetailVCFactoryProtocol {
    func makeVC(meaningId: Int) -> UIViewController {
        let provider = MeaningDetailProvider(session: URLSession.shared)
        let vm = MeaningDetailVM(meaningId: meaningId, provider: provider)
        let factory = MeaningDetailVCFactory()
        let vc = MeaningDetailVC(viewModel: vm, meaningDetailVCFactory: factory)
        return vc
    }
}
