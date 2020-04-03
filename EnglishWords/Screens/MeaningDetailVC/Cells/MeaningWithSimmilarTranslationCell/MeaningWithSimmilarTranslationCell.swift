//
//  MeaningWithSimmilarTranslationCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningWithSimmilarTranslationCellVMProtocol {
    var frequency: MeaningSimmilarTranslationFrequency { get }
    var partOfSpeechAbbreviation: String? { get }
    var translation: String { get }
    var translationNote: String? { get }
}

class MeaningWithSimmilarTranslationCell: UITableViewCell, Stringable {
    
    @IBOutlet private weak var translation: UILabel!
    @IBOutlet private var stars: [UIImageView]!
    
    var viewModel: MeaningWithSimmilarTranslationCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
}

private extension MeaningWithSimmilarTranslationCell {
    
    func setupVM(viewModel: MeaningWithSimmilarTranslationCellVMProtocol?) {
        guard let vm = viewModel else { return }
        
        let starImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        let starsColor: UIColor
        switch vm.frequency {
        case .none:
            starsColor = .systemGray
            stars[0].image = starImage
            stars[1].image = starImage
            stars[2].image = starImage
        case .low:
            starsColor = .systemGreen
            stars[0].image = starFillImage
            stars[1].image = starImage
            stars[2].image = starImage
        case .medium:
            starsColor = .systemOrange
            stars[0].image = starFillImage
            stars[1].image = starFillImage
            stars[2].image = starImage
        case .high:
            starsColor = .systemRed
            stars[0].image = starFillImage
            stars[1].image = starFillImage
            stars[2].image = starFillImage
        }
        for star in stars {
            star.tintColor = starsColor
        }
        
        let string = NSMutableAttributedString()
        let partOfSpeechAbbreviationAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkText
        ]
        let translationAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.darkText
        ]
        let translationNoteAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        if let partOfSpeechAbbreviation = vm.partOfSpeechAbbreviation {
            string.append(NSAttributedString(string: "[\(partOfSpeechAbbreviation)] ",
                                             attributes: partOfSpeechAbbreviationAttributes))
        }
        string.append(NSAttributedString(string: vm.translation, attributes: translationAttributes))
        if let note = vm.translationNote, !note.isEmpty {
            string.append(NSAttributedString(string: " (\(note))", attributes: translationNoteAttributes))
        }
        
        translation.attributedText = string
    }
    
}
