//
//  NoteEditPresenter.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 23.12.2022.
//

import Foundation

protocol NoteEditPresenterProtocol: AnyObject {
    
}

final class NoteEditPresenter {
    private let service = NoteService()
    private weak var view: NoteEditPresenterProtocol?
    public var note: Note?
}

extension NoteEditPresenter {
    func setDelegate(_ delegate: NoteEditPresenterProtocol) {
        self.view = delegate
    }
    
    func saveNote(title: String?, body: String?) {
        service.saveNote(title: title, body: body)
    }
    
    func update(note: Note?, title: String?, body: String?) {
        guard let note, note.title != title || note.body != body else { return }
        service.update(note: note, title: title, body: body)
    }
    
    func getReadableDate() -> String? {
        switch note {
        case .some(let note):
            return note.createdDate?.convertToMonthYearFormat()
        case .none:
            return Date().convertToMonthYearFormat()
        }
    }
}
