//
//  NoteService.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 23.12.2022.
//

import CoreData
import UIKit

protocol NoteSerivceProtocol {
    func fetchNotes(completion: @escaping (Result<[Note], Error>) -> Void)
    func saveNote(title: String?, body: String?)
    func delete(note: Note)
    func update(note: Note, title: String?, body: String?)
}

final class NoteService {
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

extension NoteService: NoteSerivceProtocol {
    /// Save context
    private func saveContext() {
        do {
            try self.context.save()
        } catch {}
    }
    
    /// Fetching notes from storage
    /// - Parameter completion: Completion handler
    func fetchNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        do {
            let request = Note.fetchRequest() as NSFetchRequest<Note>
            let sort    = NSSortDescriptor(key: "updatedDate", ascending: false)
            request.sortDescriptors = [sort]
            let notes = try context.fetch(request)
            completion(.success(notes))
        } catch {
            completion(.failure(DataError.fetchFailed))
        }
    }
    
    /// Save new note
    /// - Parameters:
    ///   - title: Note's title
    ///   - body: Note's body
    func saveNote(title: String?, body: String?) {
        let newNote = Note(context: self.context)
        newNote.title       = title
        newNote.body        = body
        newNote.createdDate = Date()
        newNote.updatedDate = Date()
        
        saveContext()
    }
    
    /// Delete note
    /// - Parameter note: Note to delete
    func delete(note: Note) {
        self.context.delete(note)
        saveContext()
    }
    
    /// Update exist note
    /// - Parameters:
    ///   - note: Note to update
    ///   - title: Note's title
    ///   - body: Note's body
    func update(note: Note, title: String?, body: String?) {
        let note            = note
        note.title          = title
        note.body           = body
        note.updatedDate    = Date()
        
        saveContext()
    }
}
