//
//  MeaningCell.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningCellVMProtocol {
    var word: String? { get }
    var transcription: String? { get }
    var meaning: String? { get }
    var meaningNote: String? { get }
    var meaningImage: String? { get }
}

class MeaningCell: UITableViewCell, Stringable {

    @IBOutlet private weak var word: UILabel!
    @IBOutlet private weak var meaning: UILabel!
    @IBOutlet private weak var meaningImage: UIImageView!
    
    var viewModel: MeaningCellVMProtocol? {
        didSet {
            setupVM(viewModel: viewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        meaningImage.clipsToBounds = true
        meaningImage.layer.cornerRadius = 8
    }
    
}

private extension MeaningCell {
    
    func setupVM(viewModel: MeaningCellVMProtocol?) {
        guard let vm = viewModel else { return }
        word.attributedText = getAttributedStringFor(word: vm.word, transcription: vm.transcription)
        meaning.attributedText = getAttributedStringFor(meaning: vm.meaning, meaningNote: vm.meaningNote)
        meaningImage.loadImage(fromURL: vm.meaningImage, with: #imageLiteral(resourceName: "imagePlaceholder.png"))
    }
    
    func getAttributedStringFor(word: String?, transcription: String?) -> NSAttributedString {
        let string = NSMutableAttributedString()
        let wordAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        let transcriptionAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        let braceAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.darkGray
        ]
        if let word = word, !word.isEmpty {
            string.append(NSAttributedString(string: word, attributes: wordAttributes))
        }
        if let transcription = transcription, !transcription.isEmpty {
            string.append(NSAttributedString(string: " [", attributes: braceAttributes))
            string.append(NSAttributedString(string: transcription, attributes: transcriptionAttributes))
            string.append(NSAttributedString(string: "]", attributes: braceAttributes))
        }
        return string
    }
    
    func getAttributedStringFor(meaning: String?, meaningNote: String?) -> NSAttributedString {
        let string = NSMutableAttributedString()
        let meaningAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.darkText
        ]
        let meaningNoteAttributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.darkGray
        ]
        if let meaning = meaning, !meaning.isEmpty {
            string.append(NSAttributedString(string: meaning, attributes: meaningAttributes))
        }
        if let meaningNote = meaningNote, !meaningNote.isEmpty {
            string.append(NSAttributedString(string: " (\(meaningNote))", attributes: meaningNoteAttributes))
        }
        return string
    }
    
}
