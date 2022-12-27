//
//  Error.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 24.12.2022.
//

import Foundation

enum DataError: String, Error {
    case fetchFailed = "Data fetching error"
    case saveFailed
}
