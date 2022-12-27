//
//  Title.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 25.12.2022.
//

import Foundation

enum Title {
    static let notes = "Notes"
    
    enum Error {
        static let somethingWrong = "Something went wrogn"
    }
    
    enum Placeholder {
        static let noteTitle    = "Note Title"
        static let search       = "Search"
    }
    
    enum DefaultNote {
        static let title = "About me"
        static let body =
        """
        My name is Ivan Puzanov, I'm 24 years old. This app was developed as demo project.
        
        Stack:
        - Swift
        - UIKit
        - Core Data
        - MVP + Coordinator
        """
    }
}
