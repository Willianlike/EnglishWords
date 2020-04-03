//
//  MeaningImageCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningImageCellVMProtocol {
    var url: String { get }
}

class MeaningImageCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var meaningImage: UIImageView!
    
    var viewModel: MeaningImageCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
}

private extension MeaningImageCell {
    
    func setupVM(viewModel: MeaningImageCellVMProtocol?) {
        guard let vm = viewModel else { return }
        meaningImage.loadImage(fromURL: vm.url, with: #imageLiteral(resourceName: "imagePlaceholder.png"))
    }
    
}
