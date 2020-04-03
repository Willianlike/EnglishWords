//
//  SectionTitleCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol SectionTitleCellVMProtocol {
    var title: String { get }
}

class SectionTitleCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var title: UILabel!
    
    var viewModel: SectionTitleCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
}

private extension SectionTitleCell {
    
    func setupVM(viewModel: SectionTitleCellVMProtocol?) {
        guard let vm = viewModel else { return }
        title.text = vm.title
    }
    
}
