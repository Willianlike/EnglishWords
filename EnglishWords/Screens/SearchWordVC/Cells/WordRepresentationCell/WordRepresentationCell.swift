//
//  WordRepresentationCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol WordRepresentationCellVMProtocol {
    var word: String { get }
    var translation: String { get }
}

class WordRepresentationCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var word: UILabel!
    @IBOutlet private weak var translation: UILabel!
    
    var viewModel: WordRepresentationCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
}

private extension WordRepresentationCell {
    func setupVM(viewModel: WordRepresentationCellVMProtocol?) {
        guard let vm = viewModel else { return }
        word.text = vm.word
        translation.text = vm.translation
    }
}
