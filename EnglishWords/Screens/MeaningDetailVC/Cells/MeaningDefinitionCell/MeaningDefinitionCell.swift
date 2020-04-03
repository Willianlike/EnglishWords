//
//  MeaningDefinitionCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningDefinitionCellVMProtocol {
    var word: String { get }
    var prefix: String? { get }
    var definition: String { get }
    var translation: String { get }
    var translationNote: String? { get }
    var transcription: String? { get }
}

class MeaningDefinitionCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var definition: UILabel!
    
    var viewModel: MeaningDefinitionCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
}

private extension MeaningDefinitionCell {
    
    func setupVM(viewModel: MeaningDefinitionCellVMProtocol?) {
        guard let vm = viewModel else { return }
        
        let primaryFontSize = CGFloat(18)
        let secondaryFontSize = CGFloat(16)
        let string = NSMutableAttributedString()
        
        let prefixAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: secondaryFontSize),
            .foregroundColor: UIColor.darkGray
        ]
        let wordAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: primaryFontSize, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let transcriptionAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: secondaryFontSize),
            .foregroundColor: UIColor.darkGray
        ]
        let transcriptionBracesAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: secondaryFontSize, weight: .semibold),
            .foregroundColor: UIColor.darkGray
        ]
        let translationAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: primaryFontSize, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let translationNoteAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: secondaryFontSize),
            .foregroundColor: UIColor.darkGray
        ]
        let definitionTitleAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: primaryFontSize, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let definitionAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: primaryFontSize),
            .foregroundColor: UIColor.darkText
        ]
        let separatorAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 8)
        ]
        if let prefix = vm.prefix {
            string.append(NSAttributedString(string: "(\(prefix)) ", attributes: prefixAttributes))
        }
        string.append(NSAttributedString(string: vm.word, attributes: wordAttributes))
        if let transcription = vm.transcription {
            string.append(NSAttributedString(string: " [", attributes: transcriptionBracesAttributes))
            string.append(NSAttributedString(string: transcription, attributes: transcriptionAttributes))
            string.append(NSAttributedString(string: "]", attributes: transcriptionBracesAttributes))
        }
        string.append(NSAttributedString(string: "\n\n", attributes: separatorAttributes))
        string.append(NSAttributedString(string: "\(vm.translation)", attributes: translationAttributes))
        if let note = vm.translationNote, !note.isEmpty {
            string.append(NSAttributedString(string: " (\(note))", attributes: translationNoteAttributes))
        }
        string.append(NSAttributedString(string: "\n\n", attributes: separatorAttributes))
        string.append(NSAttributedString(string: NSLocalizedString("Description: ", comment: ""),
                                         attributes: definitionTitleAttributes))
        string.append(NSAttributedString(string: "\(vm.definition)", attributes: definitionAttributes))
        
        definition.attributedText = string
    }
    
}
