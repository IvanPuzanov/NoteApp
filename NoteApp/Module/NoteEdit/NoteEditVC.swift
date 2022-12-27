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
    private let scrollView          = UIScrollView()
    private let contentView         = UIView()
    private let noteTextView        = UITextView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToPresenter()
        
        configureRootView()
        configureDateTitle()
        configureNoteTitleTextField()
        configureScrollView()
        configureContentView()
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
    
    func configureScrollView() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: noteTitleTextField.bottomAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureContentView() {
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func configureNoteTextView() {
        self.contentView.addSubview(noteTextView)
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        noteTextView.font                           = UIFont.systemFont(ofSize: 17, weight: .regular)
        noteTextView.text                           = note?.body
        noteTextView.textColor                      = .label.withAlphaComponent(0.85)
        noteTextView.dataDetectorTypes              = .link
        noteTextView.showsVerticalScrollIndicator   = false
        
        noteTextView.configureToolbar()
        
        NSLayoutConstraint.activate([
            noteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            noteTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noteTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
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
