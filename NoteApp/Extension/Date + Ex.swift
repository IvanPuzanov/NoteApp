//
//  Date + Ex.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 24.12.2022.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "d MMMM yyyy"
        
        return dateFromatter.string(from: self)
    }
    
}
