//
//  OnboardingPresenter.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 27.12.2022.
//

import Foundation

protocol OnboardingPresenterDelegate: AnyObject {
    
}

final class OnboardingPresenter {
    private weak var view: OnboardingPresenterDelegate?
}
