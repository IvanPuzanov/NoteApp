//
//  NoteListVC.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 23.12.2022.
//

import UIKit

final class NoteListVC: UITableViewController {
    // MARK: - Parameters
    enum Section { case main }
    private lazy var presenter = NoteListPresenter()
    public var appCoordinator: AppCoordinator?
    private var dataSource: UITableViewDiffableDataSource<Section, Note>!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToPresenter()
        configureNavigationBar()
        configureTableView()
        configureDataSource()
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchNotes()
        
        guard let selectedRow = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedRow, animated: true)
    }
}

// MARK: - Event methods
private extension NoteListVC {
    /// Updating table view with new snapshot
    /// - Parameter notes: List of notes to update
    func reloadTableView(with notes: [Note]) {
        let snapshot = presenter.getSnapshot(for: notes)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5) {
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    /// Tells presenter to fetch notes
    func fetchNotes() {
        self.presenter.fetchNotes()
    }
    
    /// Handle tap new note button
    @objc
    func newNoteButtonTapped() {
        appCoordinator?.showNoteEditVC(for: nil)
    }
}

// MARK: - Configuring methods
private extension NoteListVC {
    func bindToPresenter() {
        self.presenter.setDelegate(self)
    }
    
    func configureNavigationBar() {
        self.title = Title.notes
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let newNoteButton = UIBarButtonItem(image: .init(systemName: Image.squareAndPencil),
                                            style: .plain, target: self, action: nil)
        newNoteButton.action = #selector(newNoteButtonTapped)
        self.navigationItem.setRightBarButton(newNoteButton, animated: true)
    }
    
    func configureTableView() {
        self.tableView.register(NoteTVCell.self, forCellReuseIdentifier: NoteTVCell.id)
    }
    
    func configureDataSource() {
        typealias TableDataSource = UITableViewDiffableDataSource<Section, Note>
        dataSource = TableDataSource(tableView: self.tableView, cellProvider: { tableView, indexPath, note in
            let cell = tableView.dequeueReusableCell(withIdentifier: NoteTVCell.id, for: indexPath) as? NoteTVCell
            cell?.set(with: note)
            cell?.accessoryType = .disclosureIndicator
            return cell
        })
        
        dataSource.defaultRowAnimation = .fade
    }
    
    func configureSearchController() {
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.placeholder  = Title.Placeholder.search
        searchController.searchBar.delegate     = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}

// MARK: - Conforming to NoteListPresenterDelegate
extension NoteListVC: NoteListPresenterDelegate {
    /// Delegate's method for updating table view
    /// - Parameter notes: List of notes to update
    func update(with notes: [Note]) {
        self.reloadTableView(with: notes)
    }
    
    /// Delegate's method for showing error message
    /// - Parameter message: Error message
    func errorOccured(with message: String) {
        let alertController = UIAlertController(title: Title.Error.somethingWrong, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)
    }
}

extension NoteListVC {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = dataSource.itemIdentifier(for: indexPath)
        appCoordinator?.showNoteEditVC(for: note)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = presenter.getDeleteAction(for: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension NoteListVC: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.updateWithFilteredNotes(searchController: searchController)
    }
}
