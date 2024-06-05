//
//  ReportViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 24/04/24.
//

import Foundation
import UIKit

import Foundation
import UIKit

class ReportViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Resultados"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var reportMessages: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Relatórios"
        view.backgroundColor = .systemBackground
        tableView.separatorColor = .systemGreen
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        setupLayout()
        setupTableView()
        fetchAndDisplayReport()
    }

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reportCell")
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
                self.reportMessages = reportMessages
                self.tableView.reloadData()
            }
        }
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportMessages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        cell.textLabel?.text = reportMessages[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return cell
    }
}
