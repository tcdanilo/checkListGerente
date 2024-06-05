//
//  CustomHeaderView.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/05/24.
//

import UIKit

class CustomHeaderView: UIView {

    let collectionView: UICollectionView
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

        override init(frame: CGRect) {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 50, height: 50)
            layout.minimumLineSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            // Configure o layout da coleção aqui

            collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            super.init(frame: frame)
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.layer.borderColor = UIColor.systemGray4.cgColor
            collectionView.layer.borderWidth = 1.0
            collectionView.layer.cornerRadius = 8.0
            collectionView.addSubview(dateLabel)
            // Configurações adicionais da collectionView
            // Adicione subviews, defina delegates e datasources, etc.
            addSubview(collectionView)
            NSLayoutConstraint.activate([
                        dateLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                        dateLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
                    ])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    override func layoutSubviews() {
            super.layoutSubviews()
            collectionView.frame = bounds
        }
    func configure(with date: Date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM"
            dateLabel.text = dateFormatter.string(from: date)
        }

}
