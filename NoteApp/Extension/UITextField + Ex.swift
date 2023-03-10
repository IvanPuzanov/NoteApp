//
//  UITextField + Ex.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 23.12.2022.
//

import UIKit

extension UITextField {
    func configureWith(fontSize: CGFloat, fontWeight: UIFont.Weight) {
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
    }
    
    func configureToolbar() {
        let doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace   = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done        = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(resignFirstResponder))
        done.tintColor  = Color.appAccentColor
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
