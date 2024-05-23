//
//  FeedTableViewCell.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 28/03/24.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = "FeedTableViewCell"
    
    var checklistItem : ChecklistItem? {
        didSet {
            titleLabel.text = checklistItem?.title
            if let isComplete = checklistItem?.isComplete, isComplete{
                isCompleteLabel.text = "Realizado"
                isCompleteLabel.textColor = .green
            }else{
                isCompleteLabel.text = "Não Realizado"
                isCompleteLabel.textColor = .red
            }
        
        }
    }
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .label
        label.text = "Title"
        return label
    }()
    private let isCompleteLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.text = "Não realizado"
        return label
    }()
    private let assignedUserLabel : UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .label
        label.text = "Usuarios atribuidos"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemOrange
        addSubview(titleLabel)
        addSubview(isCompleteLabel)
        addSubview(assignedUserLabel)
        titleLabel.anchor(top: topAnchor,left: leftAnchor, paddingTop: 4,paddingLeft: 8)
        isCompleteLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
        assignedUserLabel.anchor(top: topAnchor,right: rightAnchor, paddingTop: 4,paddingRight: 8)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


