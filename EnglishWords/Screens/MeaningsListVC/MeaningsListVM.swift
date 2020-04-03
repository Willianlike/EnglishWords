//
//  MeaningsListVM.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

protocol MeaningsListVMDelegate: AnyObject {
    func openMeaningDetail(meaningId: Int)
}

class MeaningsListVM: MeaningsListVMProtocol {
    
    var cells = [MeaningCellVM]()
    weak var delegate: MeaningsListVMDelegate?
    
    private let word: WordModel
    
    init(word: WordModel) {
        self.word = word
        cells = word.meanings.map(getMeaningDetailVM(for:))
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard word.meanings.count > indexPath.row && indexPath.row >= 0 else { return }
        let meaningId = word.meanings[indexPath.row].id
        delegate?.openMeaningDetail(meaningId: meaningId)
    }
    
}

// MARK: - Privates
private extension MeaningsListVM {
    
    func getMeaningDetailVM(for model: MeaningModel) -> MeaningCellVM {
        return MeaningCellVM(word: word.text,
                             transcription: model.transcription,
                             meaning: model.translation.text,
                             meaningNote: model.translation.note,
                             meaningImage: model.previewUrl)
    }
    
}
