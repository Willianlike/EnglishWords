//
//  MeaningExampleCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningExampleCellVMProtocol {
    var text: String { get }
}

class MeaningExampleCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var example: UILabel!
    
    private let bracketsSearcher = BracketsSearcher()
    
    var viewModel: MeaningExampleCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
}

private extension MeaningExampleCell {
    
    func setupVM(viewModel: MeaningExampleCellVMProtocol?) {
        guard let vm = viewModel else { return }
        let simpleAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        let string = NSMutableAttributedString(string: vm.text, attributes: simpleAttributes)
        let bracketsAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let bracketsRanges = bracketsSearcher.getBracketRanges(for: vm.text)
        for range in bracketsRanges {
            string.addAttributes(bracketsAttributes, range: range)
        }
        example.attributedText = string
    }
    
}
