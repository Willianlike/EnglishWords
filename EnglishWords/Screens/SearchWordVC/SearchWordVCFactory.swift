//
//  SearchWordVCFactory.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

struct SearchWordVCFactory: VCFactory {
    func makeVC() -> UIViewController {
        let provider = SearchWordProvider(session: URLSession.shared)
        let vm = SearchWordVM(provider: provider)
        let listFactory = MeaningsListVCFactory()
        let detailFactory = MeaningDetailVCFactory()
        let vc = SearchWordVC(viewModel: vm,
                              meaningsListVCFactory: listFactory,
                              meaningDetailVCFactory: detailFactory)
        return vc
    }
}
