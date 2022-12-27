//
//  AppCoordinator.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 24.12.2022.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Start coordinator
    func start() {
        let viewController = NoteListVC()
        viewController.appCoordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Define NoteEditVC with note parameter
    /// - Parameter note: Note object
    func showNoteEditVC(for note: Note?) {
        let viewController = NoteEditVC()
        viewController.note = note
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Checking for app first launch
    func checkFirstLaunch() {
        let userDefaults    = UserDefaults.standard
        let isFirstLaunch   = userDefaults.object(forKey: UserDefaultsKeys.firstLaunch.rawValue) as? Bool
        
        switch isFirstLaunch {
        case .none:
            userDefaults.set(false, forKey: UserDefaultsKeys.firstLaunch.rawValue)
            let noteService = NoteService()
            noteService.saveNote(title: Title.DefaultNote.title, body: Title.DefaultNote.body)
        default:
            return
        }
    }
}
