//
//  MeaningDetailVC.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningDetailVMProtocol: AnyObject {
    var cells: [[MeaningDetailCellType]] { get }
    var delegate: MeaningDetailVMDelegate? { get set }
    func didSelectRow(at indexPath: IndexPath)
}

class MeaningDetailVC: UIViewController, Stringable {
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: MeaningDetailVMProtocol
    private let meaningDetailVCFactory: MeaningDetailVCFactoryProtocol
    
    init(viewModel: MeaningDetailVMProtocol,
         meaningDetailVCFactory: MeaningDetailVCFactoryProtocol) {
        self.viewModel = viewModel
        self.meaningDetailVCFactory = meaningDetailVCFactory
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
    
}

// MARK: - Privates
private extension MeaningDetailVC {
    
    func setupNavBar() {
        title = NSLocalizedString("Meaning", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTable() {
        tableView.register(UINib(nibName: MeaningWithSimmilarTranslationCell.string, bundle: nil),
                           forCellReuseIdentifier: MeaningWithSimmilarTranslationCell.string)
        tableView.register(UINib(nibName: MeaningDefinitionCell.string, bundle: nil),
                           forCellReuseIdentifier: MeaningDefinitionCell.string)
        tableView.register(UINib(nibName: MeaningImageCell.string, bundle: nil),
                           forCellReuseIdentifier: MeaningImageCell.string)
        tableView.register(UINib(nibName: MeaningExampleCell.string, bundle: nil),
                           forCellReuseIdentifier: MeaningExampleCell.string)
        tableView.register(UINib(nibName: SectionTitleCell.string, bundle: nil),
                           forCellReuseIdentifier: SectionTitleCell.string)
        tableView.register(UINib(nibName: MeaningDifficultyCell.string, bundle: nil),
                           forCellReuseIdentifier: MeaningDifficultyCell.string)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

// MARK: - MeaningDetailVMDelegate
extension MeaningDetailVC: MeaningDetailVMDelegate {
    
    func openMeaningDetail(meaningId: Int) {
        let vc = meaningDetailVCFactory.makeVC(meaningId: meaningId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(_ text: String) {
        print(text)
    }
    
    func spinner(show: Bool) {
        DispatchQueue.main.async {
            if show {
                UIView.transition(with: self.view,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.spinner.startAnimating()
                                    self.tableView.isHidden = true
                })
            } else {
                UIView.transition(with: self.view,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.spinner.stopAnimating()
                                    self.tableView.isHidden = false
                })
            }
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension MeaningDetailVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.cells.count > section && section >= 0 else { return 0 }
        return viewModel.cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.cells.count > indexPath.section && indexPath.section >= 0,
            viewModel.cells[indexPath.section].count > indexPath.row && indexPath.row >= 0
            else {
                return UITableViewCell()
        }
        var tableCell: UITableViewCell?
        switch viewModel.cells[indexPath.section][indexPath.row] {
        case .difficulty(let vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: MeaningDifficultyCell.string,
                                                     for: indexPath) as? MeaningDifficultyCell
            cell?.viewModel = vm
            tableCell = cell
        case .title(let vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: SectionTitleCell.string,
                                                     for: indexPath) as? SectionTitleCell
            cell?.viewModel = vm
            tableCell = cell
        case .example(let vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: MeaningExampleCell.string,
                                                     for: indexPath) as? MeaningExampleCell
            cell?.viewModel = vm
            tableCell = cell
        case .image(let vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: MeaningImageCell.string,
                                                     for: indexPath) as? MeaningImageCell
            cell?.viewModel = vm
            tableCell = cell
        case .definition(let vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: MeaningDefinitionCell.string,
                                                     for: indexPath) as? MeaningDefinitionCell
            cell?.viewModel = vm
            tableCell = cell
        case .simmilars(let vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: MeaningWithSimmilarTranslationCell.string,
                                                     for: indexPath) as? MeaningWithSimmilarTranslationCell
            cell?.viewModel = vm
            tableCell = cell
        }
        return tableCell ?? UITableViewCell()
    }
    
}

// MARK: - UITableViewDelegate
extension MeaningDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
}
