//
//  MeaningDetailVM.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 02/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

typealias MeaningDetailCompletion = (Result<MeaningDetailResponse, Error>) -> Void

protocol MeaningDetailProviderProtocol {
    func getFullMeanings(ids: [Int],
                         completion: @escaping MeaningDetailCompletion) -> URLSessionTask?
}

protocol MeaningDetailVMDelegate: AnyObject {
    func showError(_ text: String)
    func spinner(show: Bool)
    func openMeaningDetail(meaningId: Int)
    func reloadTable()
}

class MeaningDetailVM: MeaningDetailVMProtocol {
    
    var cells: [[MeaningDetailCellType]] {
        [commonCellsSection,
         difficultyCellsSectionTitle,
         difficultyCellsSection,
         exampleCellsSectionTitle,
         exampleCellsSection,
         meaningsWithSimilarTranslationCellsSectionTitle,
         meaningsWithSimilarTranslationCellsSection]
    }
    weak var delegate: MeaningDetailVMDelegate?
    
    private let meaningId: Int
    private var fullMeaning: FullMeaningModel?
    private let provider: MeaningDetailProviderProtocol
    
    private var getMeaningsTask: URLSessionTask?
    
    private var commonCellsSection = [MeaningDetailCellType]()
    private var difficultyCellsSectionTitle = [MeaningDetailCellType]()
    private var difficultyCellsSection = [MeaningDetailCellType]()
    private var exampleCellsSectionTitle = [MeaningDetailCellType]()
    private var exampleCellsSection = [MeaningDetailCellType]()
    private var meaningsWithSimilarTranslationCellsSectionTitle = [MeaningDetailCellType]()
    private var meaningsWithSimilarTranslationCellsSection = [MeaningDetailCellType]()
    
    init(meaningId: Int, provider: MeaningDetailProviderProtocol) {
        self.meaningId = meaningId
        self.provider = provider
        requestMeaning()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.section == 6,
            let meaning = fullMeaning,
            meaning.meaningsWithSimilarTranslation.count > indexPath.row && indexPath.row >= 0
            else { return }
        let meaningId = meaning.meaningsWithSimilarTranslation[indexPath.row].meaningId
        delegate?.openMeaningDetail(meaningId: meaningId)
    }
    
}

// MARK: - Privates
private extension MeaningDetailVM {
    
    func requestMeaning() {
        delegate?.spinner(show: true)
        getMeaningsTask?.cancel()
        getMeaningsTask = provider.getFullMeanings(ids: [meaningId])
        { [weak self] (result) in
            guard let self = self else { return }
            self.delegate?.spinner(show: false)
            switch result {
            case .success(let response):
                self.handleSuccess(response: response)
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    func handleSuccess(response: MeaningDetailResponse) {
        guard let meaning = response.first else {
            handleError(error: APIError.invalidResponse)
            return
        }
        fullMeaning = meaning
        
        let definition = MeaningDefinitionCellVM(
            word: meaning.text,
            prefix: meaning.prefix,
            definition: meaning.definition.text,
            translation: meaning.translation.text,
            translationNote: meaning.translation.note,
            transcription: meaning.transcription
        )
        commonCellsSection.append(.definition(definition))
        let images = meaning.images.map { (model) in
            return MeaningDetailCellType.image(MeaningImageVM(url: model.url))
        }
        commonCellsSection.append(contentsOf: images)
        
        
        if let stars = meaning.difficultyLevel {
            difficultyCellsSectionTitle = [
                .title(SectionTitleCellVM(title: NSLocalizedString("Difficulty:", comment: "")))
            ]
            difficultyCellsSection = [
                .difficulty(MeaningDifficultyCellVM(stars: stars))
            ]
        }
        
        
        if !meaning.examples.isEmpty {
            exampleCellsSectionTitle = [
                .title(SectionTitleCellVM(title: NSLocalizedString("Examples:", comment: "")))
            ]
            exampleCellsSection = meaning.examples.map({ (model) in
                let vm = MeaningExampleCellVM(text: model.text)
                return MeaningDetailCellType.example(vm)
            })
        }
        
        let meaningsToShow = meaning.meaningsWithSimilarTranslation.filter({ $0.meaningId != meaningId })
        if !meaningsToShow.isEmpty {
            let title = NSLocalizedString("Meanings with similar translation:", comment: "")
            meaningsWithSimilarTranslationCellsSectionTitle = [
                .title(SectionTitleCellVM(title: title))
            ]
            meaningsWithSimilarTranslationCellsSection = meaningsToShow
                .map({ (model) in
                    let frequency = MeaningSimmilarTranslationFrequency(percent: model.frequencyPercent)
                    let vm = MeaningWithSimmilarTranslationCellVM(
                        frequency: frequency,
                        partOfSpeechAbbreviation: model.partOfSpeechAbbreviation,
                        translation: model.translation.text,
                        translationNote: model.translation.note
                    )
                    return MeaningDetailCellType.simmilars(vm)
                })
        }
        
        delegate?.reloadTable()
    }
    
    func handleError(error: Error) {
        switch error {
        case is APIError:
            delegate?.showError(error.localizedDescription)
        default:
            break
        }
    }
    
}
