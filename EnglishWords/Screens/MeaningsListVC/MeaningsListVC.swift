//
//  MeaningsListVC.swift
//  EnglishWords
//
//  Created by Вильян Яумбаев on 01/04/2020.
//  Copyright © 2020 Вильян Яумбаев. All rights reserved.
//

import UIKit

protocol MeaningsListVMProtocol: AnyObject {
    var cells: [MeaningCellVM] { get }
    var delegate: MeaningsListVMDelegate? { get set }
    func didSelectRow(at indexPath: IndexPath)
}

class MeaningsListVC: UIViewController, Stringable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel: MeaningsListVMProtocol
    private let meaningDetailVCFactory: MeaningDetailVCFactoryProtocol
    
    init(viewModel: MeaningsListVMProtocol,
         meaningDetailVCFactory: MeaningDetailVCFactoryProtocol) {
        self.meaningDetailVCFactory = meaningDetailVCFactory
        self.viewModel = viewModel
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
private extension MeaningsListVC {
    
    func setupNavBar() {
        title = NSLocalizedString("Meanings", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupTable() {
        tableView.register(UINib(nibName: MeaningCell.string, bundle: nil),
                           forCellReuseIdentifier: MeaningCell.string)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

// MARK: - MeaningsListVMDelegate
extension MeaningsListVC: MeaningsListVMDelegate {
    
    func openMeaningDetail(meaningId: Int) {
        let vc = meaningDetailVCFactory.makeVC(meaningId: meaningId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension MeaningsListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModel.cells.count > indexPath.row && indexPath.row >= 0,
            let cell = tableView.dequeueReusableCell(withIdentifier: MeaningCell.string,
                                                     for: indexPath) as? MeaningCell
            else {
                return UITableViewCell()
        }
        cell.viewModel = viewModel.cells[indexPath.row]
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MeaningsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
}
