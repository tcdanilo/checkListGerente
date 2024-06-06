//
//  FeedUserViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import UIKit
import FirebaseAuth

class FeedUserViewController: UIViewController {
    
    var viewModel: FeedUserViewModel?
    var groupedChecklistItems = [String: [ChecklistItem]]() {
        didSet {
            homeFeedUserTable.reloadData()
        }
    }
    var sortedDates: [String] {
        return groupedChecklistItems.keys.sorted()
    }
    
    private let refreshControl = UIRefreshControl()
    
    private let homeFeedUserTable: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.systemBackground
        tv.register(FeedUserTableViewCell.self, forCellReuseIdentifier: FeedUserTableViewCell.identifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedUserViewModel()
        viewModel?.coordinator = FeedUserCoordinator(navigationController: navigationController!)
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedUserTable)
        homeFeedUserTable.dataSource = self
        homeFeedUserTable.delegate = self
        homeFeedUserTable.separatorColor = .systemGreen
        homeFeedUserTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        homeFeedUserTable.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        fetchItems()
    }
    
    public func fetchItems() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let user = AppUser(name: currentUser.displayName ?? "", email: currentUser.email ?? "")
        
        PostService.shared.fetchAllItems(for: user) { allItems in
            DispatchQueue.main.async {
                self.groupedChecklistItems = Dictionary(grouping: allItems) { item in
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "pt_BR")
                    dateFormatter.dateFormat = "MMMM, dd" // Agrupando por mês e dia
                    return dateFormatter.string(from: item.date)
                }
                self.homeFeedUserTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedUserTable.frame = view.bounds
    }
    
    @objc private func refreshData() {
        fetchItems()
    }
    
    private func showCompletionAlert(for item: ChecklistItem, at indexPath: IndexPath) {
        if item.isComplete {
            // O item já está completo, não permitir alterações
            let alertController = UIAlertController(title: "Item já realizado", message: "Este item já foi realizado e não pode ser alterado.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Realizar Checklist", message: "Adicione um comentário:", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "escreva seu comentário"
            }
            let completeAction = UIAlertAction(title: "Sim", style: .default) { [weak self] _ in
                guard let self = self else { return }
                let comment = alertController.textFields?.first?.text ?? ""
                self.updateChecklistItem(item, at: indexPath, with: true, comment: comment)
            }
            let cancelAction = UIAlertAction(title: "Não", style: .cancel, handler: nil)
            
            alertController.addAction(completeAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateChecklistItem(_ item: ChecklistItem, at indexPath: IndexPath, with isComplete: Bool, comment: String) {
        PostService.shared.updateChecklistItemCompletionStatus(checklistID: item.id, isComplete: isComplete, comment: comment) { [weak self] error, ref in
            guard let self = self else { return }
            if error == nil {
                let dateKey = self.sortedDates[indexPath.section]
                if var items = self.groupedChecklistItems[dateKey] {
                    items[indexPath.row].isComplete = isComplete
                    items[indexPath.row].comment = comment
                    self.groupedChecklistItems[dateKey] = items
                    
                    DispatchQueue.main.async {
                        self.homeFeedUserTable.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            } else {
                print("Erro ao atualizar status: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

extension FeedUserViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = sortedDates[section]
        return groupedChecklistItems[dateKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDates[section].capitalized // Para capitalizar o mês
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateKey = sortedDates[indexPath.section]
        if let checklistItem = groupedChecklistItems[dateKey]?[indexPath.row] {
            showCompletionAlert(for: checklistItem, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedUserTableViewCell.identifier, for: indexPath) as! FeedUserTableViewCell
        let dateKey = sortedDates[indexPath.section]
        if let checklistItem = groupedChecklistItems[dateKey]?[indexPath.row] {
            cell.checklistItem = checklistItem
        }
        return cell
    }
}





    




