//
//  MeaningDifficultyCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningDifficultyCellVMProtocol {
    var stars: Int { get }
}

class MeaningDifficultyCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private var stars: [UIImageView]!
    
    var viewModel: MeaningDifficultyCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
}

private extension MeaningDifficultyCell {
    
    func setupVM(viewModel: MeaningDifficultyCellVMProtocol?) {
        guard let vm = viewModel else { return }
        for i in stars.indices {
            stars[i].image = UIImage(systemName: vm.stars > i ? "star.fill" : "star")
        }
    }
    
}
