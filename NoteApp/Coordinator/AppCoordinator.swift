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
    
    func start() {
        let viewController = NoteListVC()
        viewController.appCoordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showNoteEditVC(for note: Note?) {
        let viewController = NoteEditVC()
        viewController.note = note
        navigationController.pushViewController(viewController, animated: true)
    }
}
