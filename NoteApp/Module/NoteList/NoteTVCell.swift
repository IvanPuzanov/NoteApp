//
//  NoteTVCell.swift
//  NoteApp
//
//  Created by Ivan Puzanov on 24.12.2022.
//

import UIKit

final class NoteTVCell: UITableViewCell {
    // MARK: - Views
    private let noteImageView   = UIImageView()
    private let noteTitleLabel  = UILabel()
    private let noteBodyLabel   = UILabel()
    private let noteDateLabel   = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureNoteImageView()
        configureNoteTitleLabel()
        configureNoteBodyLabel()
        configureNoteDateLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure methods
extension NoteTVCell {
    func set(with note: Note) {
        if let noteTitle = note.title {
            noteTitleLabel.text = noteTitle.isEmpty ? "New Note" : noteTitle
        }
        noteBodyLabel.text  = note.body
        noteDateLabel.text  = note.updatedDate?.convertToMonthYearFormat()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.noteTitleLabel.text = nil
        self.noteBodyLabel.text = nil
        self.noteDateLabel.text = nil
    }
}

// MARK: - Configure view methods
private extension NoteTVCell {
    func configure() {
        
    }
    
    func configureNoteImageView() {
        addSubview(noteImageView)
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        noteImageView.contentMode   = .scaleAspectFit
        noteImageView.tintColor     = .secondaryLabel
        noteImageView.image         = UIImage(systemName: "square.and.pencil")
        
        NSLayoutConstraint.activate([
            noteImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            noteImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            noteImageView.heightAnchor.constraint(equalToConstant: 22),
            noteImageView.widthAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func configureNoteTitleLabel() {
        addSubview(noteTitleLabel)
        noteTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noteTitleLabel.configure(fontSize: 18, fontWeight: .semibold)
        
        NSLayoutConstraint.activate([
            noteTitleLabel.leadingAnchor.constraint(equalTo: noteImageView.trailingAnchor, constant: 10),
            noteTitleLabel.centerYAnchor.constraint(equalTo: noteImageView.centerYAnchor),
            noteTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35)
        ])
    }
    
    func configureNoteBodyLabel() {
        addSubview(noteBodyLabel)
        noteBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noteBodyLabel.configure(fontSize: 16, fontWeight: .regular)
        noteBodyLabel.set(textColor: .label.withAlphaComponent(0.85))
        noteBodyLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            noteBodyLabel.leadingAnchor.constraint(equalTo: noteImageView.trailingAnchor, constant: 10),
            noteBodyLabel.topAnchor.constraint(equalTo: noteImageView.bottomAnchor),
            noteBodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35)
        ])
    }
    
    func configureNoteDateLabel() {
        addSubview(noteDateLabel)
        noteDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        noteDateLabel.configure(fontSize: 14, fontWeight: .regular)
        noteDateLabel.set(textColor: .secondaryLabel)
        
        NSLayoutConstraint.activate([
            noteDateLabel.leadingAnchor.constraint(equalTo: noteImageView.trailingAnchor, constant: 10),
            noteDateLabel.topAnchor.constraint(equalTo: noteBodyLabel.bottomAnchor, constant: 5),
            noteDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            noteDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
