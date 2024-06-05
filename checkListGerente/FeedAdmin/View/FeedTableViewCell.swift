//
//  FeedTableViewCell.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 28/03/24.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = "FeedTableViewCell"
    
    var checklistItem: ChecklistItem? {
        didSet {
            titleLabel.text = checklistItem?.title
            if let assignedUser = checklistItem?.assignedUser {
                assignedUserLabel.text = assignedUser.name
            } else {
                assignedUserLabel.text = "Nenhum usuário atribuído"
            }
            if let isComplete = checklistItem?.isComplete, isComplete {
                isCompleteLabel.text = "Realizado"
                isCompleteLabel.textColor = .systemGreen
                borderView.layer.borderColor = UIColor.systemGreen.cgColor
            } else {
                isCompleteLabel.text = "Não Realizado"
                isCompleteLabel.textColor = .systemRed
                borderView.layer.borderColor = UIColor.systemRed.cgColor
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let isCompleteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let assignedLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.text = "Usuário atribuído:"
        return label
    }()
    
    private let assignedUserLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // Mudei para cor transparente para evitar sobreposição
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemGreen.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(isCompleteLabel)
        containerView.addSubview(assignedLabel)
        containerView.addSubview(assignedUserLabel)
        containerView.addSubview(borderView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        isCompleteLabel.translatesAutoresizingMaskIntoConstraints = false
        assignedLabel.translatesAutoresizingMaskIntoConstraints = false
        assignedUserLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            isCompleteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            isCompleteLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            isCompleteLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            assignedLabel.topAnchor.constraint(equalTo: isCompleteLabel.bottomAnchor, constant: 8),
            assignedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            assignedUserLabel.topAnchor.constraint(equalTo: assignedLabel.bottomAnchor, constant: 4),
            assignedUserLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            assignedUserLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        

        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            borderView.widthAnchor.constraint(equalToConstant: 4) // Define a largura da borda
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


