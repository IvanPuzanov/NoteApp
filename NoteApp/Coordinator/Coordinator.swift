//
//  Coordinator.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 24.12.2022.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
