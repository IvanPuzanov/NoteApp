//
//  UILabel + Ex.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 24.12.2022.
//

import UIKit

extension UILabel {
    func configure(fontSize: CGFloat, fontWeight: UIFont.Weight) {
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    func set(textColor: UIColor) {
        self.textColor = textColor
    }
}
