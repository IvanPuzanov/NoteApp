//
//  NoteListPresenter.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 23.12.2022.
//

import UIKit

protocol NoteListPresenterDelegate: AnyObject {
    func update(with notes: [Note])
    func errorOccured(with message: String)
}

final class NoteListPresenter {
    private var service = NoteService()
    private weak var view: NoteListPresenterDelegate?
    public var notes: [Note]            = []
    public var filteredNotes: [Note]    = []
    public var isSearching              = false
}

extension NoteListPresenter {
    /// Setting presenter delegate (view)
    /// - Parameter delegate: view conformed NoteListPresenterDelegate protocol
    func setDelegate(_ delegate: NoteListPresenterDelegate) {
        self.view = delegate
    }
    
    /// Fetch all notes from data base
    func fetchNotes() {
        service.fetchNotes { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notes):
                self.notes = notes
                self.view?.update(with: notes)
            case .failure(let error):
                guard let error = error as? DataError else { return }
                self.view?.errorOccured(with: error.localizedDescription)
            }
        }
    }
    
    /// Create delete action for specific cell
    /// - Parameter indexPath: Cell's index
    /// - Returns: Delete action for cell
    func getDeleteAction(for indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            let noteToRemove = self.notes[indexPath.row]
            self.service.delete(note: noteToRemove)
            self.fetchNotes()
        }
        
        
        return action
    }
    
    func updateWithFilteredNotes(searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            view?.update(with: notes)
            return
        }
        self.isSearching = true
        filteredNotes = notes.filter {
            guard let title = $0.title?.lowercased(),
                  let body = $0.body?.lowercased() else { return false }
            return title.contains(filter.lowercased()) || body.contains(filter.lowercased())
        }
        view?.update(with: filteredNotes)
    }
    
    func getSnapshot(for notes: [Note]) -> NSDiffableDataSourceSnapshot<NoteListVC.Section, Note> {
        var snapshot = NSDiffableDataSourceSnapshot<NoteListVC.Section,Note>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(notes, toSection: .main)
        
        return snapshot
    }
}
