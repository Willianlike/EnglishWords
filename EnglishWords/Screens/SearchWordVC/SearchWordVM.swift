//
//  SearchWordVM.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import Foundation

typealias SearchWordCompletion = (Result<SearchWordResponse, Error>) -> Void

protocol SearchWordProviderProtocol {
    func search(query: String?,
                page: Int,
                pageSize: Int,
                completion: @escaping SearchWordCompletion) -> URLSessionTask?
}

protocol SearchWordVMDelegate: AnyObject {
    func showError(_ text: String)
    func bottomSpinner(show: Bool)
    func topSpinner(show: Bool)
    func reloadTable()
    func addRows(_ indexPaths: [IndexPath])
    func openMeaningsListVC(word: WordModel)
    func openMeaningDetailVC(meaningId: Int)
}

class SearchWordVM {
    
    var delegate: SearchWordVMDelegate?
    var cells = [WordRepresentationCellVM]()
    
    private let provider: SearchWordProviderProtocol
    private var searchTask: URLSessionTask?
    private var words = [WordModel]()
    private var searchText: String?
    private let pageSize = 20
    private var page = 1
    private var canLoadNewPage = true
    private var isLoadingNewPage = false
    
    init(provider: SearchWordProviderProtocol) {
        self.provider = provider
    }
    
}

// MARK: - Privates
private extension SearchWordVM {
    
    func requestNextPage() {
        guard canLoadNewPage && !isLoadingNewPage else { return }
        
        delegate?.bottomSpinner(show: true)
        
        isLoadingNewPage = true
        page += 1
        searchTask?.cancel()
        
        searchTask = provider.search(query: searchText, page: page, pageSize: pageSize)
        { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.handleSuccessForNextPage(words: response)
            case .failure(let error):
                self.handleError(error: error)
            }
            self.isLoadingNewPage = false
            self.delegate?.bottomSpinner(show: false)
        }
    }
    
    func requestSearch() {
        delegate?.topSpinner(show: true)
        page = 1
        searchTask?.cancel()
        searchTask = provider.search(query: searchText, page: page, pageSize: pageSize)
        { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.delegate?.topSpinner(show: false)
                self.handleSuccessForSearch(words: response)
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    func handleError(error: Error) {
        guard (error as NSError).code != NSURLErrorCancelled else { return }
        delegate?.topSpinner(show: false)
        delegate?.showError(error.localizedDescription)
    }
    
    func getCells(for response: SearchWordResponse) -> [WordRepresentationCellVM] {
        return response.map({ WordRepresentationCellVM(word: $0.text,
                                                       translation: $0.meaningsString) })
    }
    
    func getIndexPaths(range: Range<Int>) -> [IndexPath] {
        return range.map({ IndexPath(row: $0, section: 0) })
    }
    
    func handleSuccessForNextPage(words: [WordModel]) {
        let newCells = getCells(for: words)
        canLoadNewPage = newCells.count >= pageSize
        let startBound = cells.count
        cells += newCells
        self.words += words
        delegate?.addRows(getIndexPaths(range: startBound..<cells.count))
    }
    
    func handleSuccessForSearch(words: [WordModel]) {
        let newCells = getCells(for: words)
        canLoadNewPage = newCells.count >= pageSize
        cells = newCells
        self.words = words
        delegate?.reloadTable()
    }
    
}

// MARK: - SearchWordVMProtocol
extension SearchWordVM: SearchWordVMProtocol {
    
    func tableDidScrollToBottom() {
        requestNextPage()
    }
    
    func searchTextTyped(_ text: String?) {
        guard text != nil,
            !text!.isEmpty,
            text != searchText else { return }
        searchText = text
        requestSearch()
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard words.count > indexPath.row && indexPath.row >= 0 else { return }
        let word = words[indexPath.row]
        if word.meanings.count == 1 {
            delegate?.openMeaningDetailVC(meaningId: word.meanings.first!.id)
        } else {
            delegate?.openMeaningsListVC(word: word)
        }
    }
    
}
