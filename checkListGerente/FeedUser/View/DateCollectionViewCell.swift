//
//  DateCollectionViewCell.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/05/24.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    static let identifier = "DateCell"

        private let dateLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.addSubview(dateLabel)
            NSLayoutConstraint.activate([
                dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ])
            contentView.layer.borderColor = UIColor.systemGray4.cgColor
            contentView.layer.borderWidth = 1.0
            contentView.layer.cornerRadius = 8.0
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with date: Date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            dateLabel.text = dateFormatter.string(from: date)
        }
}
