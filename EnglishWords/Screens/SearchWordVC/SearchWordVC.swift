//
//  SearchWordVC.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 31/03/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol SearchWordVMProtocol: AnyObject {
    var delegate: SearchWordVMDelegate? { get set }
    var cells: [WordRepresentationCellVM] { get }
    func searchTextTyped(_ text: String?)
    func tableDidScrollToBottom()
    func didSelectRow(at indexPath: IndexPath)
}

class SearchWordVC: UIViewController, Stringable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: SearchWordVMProtocol
    private let searchController: UISearchController
    private let meaningsListVCFactory: MeaningsListVCFactoryProtocol
    private let meaningDetailVCFactory: MeaningDetailVCFactoryProtocol
    
    init(viewModel: SearchWordVMProtocol,
         meaningsListVCFactory: MeaningsListVCFactoryProtocol,
         meaningDetailVCFactory: MeaningDetailVCFactoryProtocol) {
        self.meaningDetailVCFactory = meaningDetailVCFactory
        self.meaningsListVCFactory = meaningsListVCFactory
        self.viewModel = viewModel
        searchController = UISearchController(searchResultsController: nil)
        super.init(nibName: Self.string, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    private var isFirstPresenting = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstPresenting {
            isFirstPresenting = false
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
}

// MARK: - Privates
private extension SearchWordVC {
    
    func setupNavBar() {
        title = NSLocalizedString("Words search", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.placeholder = NSLocalizedString("Start typing symbols...", comment: "")
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func setupTable() {
        tableView.register(UINib(nibName: WordRepresentationCell.string, bundle: nil),
                           forCellReuseIdentifier: WordRepresentationCell.string)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

// MARK: - UITableViewDataSource
extension SearchWordVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.cells.count > indexPath.row && indexPath.row >= 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: WordRepresentationCell.string,
                                                     for: indexPath) as? WordRepresentationCell
            else {
                return UITableViewCell()
        }
        cell.viewModel = viewModel.cells[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SearchWordVC: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0,
            scrollView.contentSize.height - 200 < scrollView.frame.height + scrollView.contentOffset.y {
            viewModel.tableDidScrollToBottom()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
}

// MARK: - SearchWordVMDelegate
extension SearchWordVC: SearchWordVMDelegate {
    
    func addRows(_ indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
    
    func openMeaningsListVC(word: WordModel) {
        let vc = meaningsListVCFactory.makeVC(word: word)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openMeaningDetailVC(meaningId: Int) {
        let vc = meaningDetailVCFactory.makeVC(meaningId: meaningId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(_ text: String) {
        print(text)
    }
    
    func bottomSpinner(show: Bool) {
        DispatchQueue.main.async {
            if show {
                let spinner = UIActivityIndicatorView(style: .large)
                spinner.color = .black
                spinner.startAnimating()
                spinner.frame = CGRect(x: 0, y: self.tableView.bounds.height - 44,
                                       width: self.tableView.bounds.width, height: 44)
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
            } else {
                self.tableView.tableFooterView = nil
            }
        }
    }
    
    func topSpinner(show: Bool) {
        DispatchQueue.main.async {
            if show {
                let spinner = UIActivityIndicatorView(style: .large)
                spinner.color = .black
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                                       width: self.tableView.bounds.width, height: CGFloat(44))
                
                self.tableView.tableHeaderView = spinner
                self.tableView.tableHeaderView?.isHidden = false
            } else {
                self.tableView.tableHeaderView = nil
            }
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
}

// MARK: - UISearchResultsUpdating
extension SearchWordVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchTextTyped(searchController.searchBar.text)
    }
    
}
