//
//  NoteEditVC.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 23.12.2022.
//

import UIKit

final class NoteEditVC: UIViewController {
    // MARK: - Parameters
    var note: Note?
    private lazy var presenter  = NoteEditPresenter()
    
    // MARK: - Views
    private let dateTitleLabel      = UILabel()
    private let noteTitleTextField  = UITextField()
    private let noteTextView        = UITextView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToPresenter()
        registerKeyboardNotifications()
        
        configureRootView()
        configureDateTitle()
        configureNoteTitleTextField()
        configureNoteTextView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        switch note {
        case .none:
            saveNote()
        case .some:
            updateNote()
        }
    }
}

// MARK: - Event methods
private extension NoteEditVC {
    func saveNote() {
        guard let title = noteTitleTextField.text,
              let body = noteTextView.text, !title.isEmpty || !body.isEmpty
        else { return }
        self.presenter.saveNote(title: noteTitleTextField.text, body: noteTextView.text)
    }
    
    func updateNote() {
        self.presenter.update(note: note, title: noteTitleTextField.text, body: noteTextView.text)
    }
}

// MARK: -
private extension NoteEditVC {
    func bindToPresenter() {
        self.presenter.setDelegate(self)
        self.presenter.note = note
    }
    
    func configureRootView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureDateTitle() {
        self.view.addSubview(dateTitleLabel)
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateTitleLabel.configure(fontSize: 14, fontWeight: .regular)
        dateTitleLabel.set(textColor: .secondaryLabel)
        dateTitleLabel.text = presenter.getReadableDate()
        
        NSLayoutConstraint.activate([
            dateTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func configureNoteTitleTextField() {
        self.view.addSubview(noteTitleTextField)
        noteTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        noteTitleTextField.configureWith(fontSize: 25, fontWeight: .bold)
        noteTitleTextField.configureToolbar()
        noteTitleTextField.text         = note?.title
        noteTitleTextField.delegate     = self
        noteTitleTextField.placeholder  = Title.Placeholder.noteTitle
        
        NSLayoutConstraint.activate([
            noteTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTitleTextField.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
            noteTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTitleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureNoteTextView() {
        self.view.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        noteTextView.font                           = UIFont.systemFont(ofSize: 17, weight: .regular)
        noteTextView.text                           = note?.body
        noteTextView.textColor                      = .label.withAlphaComponent(0.85)
        noteTextView.dataDetectorTypes              = .link
        noteTextView.showsVerticalScrollIndicator   = false
        noteTextView.delegate                       = self
        noteTextView.configureToolbar()
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTextView.topAnchor.constraint(equalTo: noteTitleTextField.bottomAnchor, constant: 20),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: -
extension NoteEditVC: NoteEditPresenterProtocol {
    
}

extension NoteEditVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextView.becomeFirstResponder()
        textField.resignFirstResponder()
        return true
    }
}

extension NoteEditVC: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        print(noteTextView)
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIControl.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIControl.keyboardWillHideNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        noteTextView.scrollIndicatorInsets = noteTextView.contentInset

        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    
}
