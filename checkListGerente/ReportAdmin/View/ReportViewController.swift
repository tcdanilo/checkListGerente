//
//  ReportViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 24/04/24.
//

import Foundation
import UIKit

class ReportViewController : UIViewController {
    
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Relatórios"
        view.backgroundColor = .systemBackground
        setupLayout()
        fetchAndDisplayReport()
    }
    
    private func setupLayout() {
        view.addSubview(reportLabel)
        NSLayoutConstraint.activate([
            reportLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reportLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            reportLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reportLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func fetchAndDisplayReport() {
        PostService.shared.fetchAllItemsAdmin { allItems in
            var userChecklists: [String: [ChecklistItem]] = [:]
            
            for item in allItems {
                guard let userEmail = item.assignedUser?.email else { continue }
                if userChecklists[userEmail] != nil {
                    userChecklists[userEmail]?.append(item)
                } else {
                    userChecklists[userEmail] = [item]
                }
            }
            
            var reportMessages: [String] = []
            
            for (userEmail, items) in userChecklists {
                let completedCount = items.filter { $0.isComplete }.count
                let totalCount = items.count
                let completionPercentage = totalCount > 0 ? (Double(completedCount) / Double(totalCount)) * 100 : 0
                if let userName = items.first?.assignedUser?.name {
                    let message = "O usuário \(userName) concluiu \(Int(completionPercentage))% dos checklists atribuídos a ele."
                    reportMessages.append(message)
                } else {
                    let message = "O usuário com email \(userEmail) concluiu \(Int(completionPercentage))% dos checklists atribuídos a ele."
                    reportMessages.append(message)
                }
            }
            
            DispatchQueue.main.async {
                self.reportLabel.text = reportMessages.joined(separator: "\n")
            }
        }
        
    }
}
