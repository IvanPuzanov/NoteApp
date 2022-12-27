//
//  Reusable.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 23.12.2022.
//

import UIKit

protocol Reusable {
    static var id: String { get }
}

extension Reusable {
    static var id: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {  }
