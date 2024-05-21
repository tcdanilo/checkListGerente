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
                assignUserLabel.text = "Atribuidos : Admin"
                assignUserLabel.textColor = .green
            }else{
                assignUserLabel.text = "Atribuidos : ngm"
                assignUserLabel.textColor = .red
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
    private let assignUserLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.text = "Atribuidos : Adelson"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemOrange
        addSubview(titleLabel)
        addSubview(assignUserLabel)
        titleLabel.anchor(top: topAnchor,left: leftAnchor, paddingTop: 4,paddingLeft: 8)
        assignUserLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


