

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    var viewModel: FeedViewModel?
    var groupedChecklistItems = [String: [ChecklistItem]]() {
        didSet {
            homeFeedTable.reloadData()
        }
    }
    var sortedDates: [String] {
        return groupedChecklistItems.keys.sorted()
    }
    
    private let refreshControl = UIRefreshControl()
   
    private let homeFeedTable: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.systemBackground
        tv.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        viewModel = FeedViewModel()
        viewModel?.coordinator = FeedCoordinator(navigationController: navigationController!)
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
   
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self

        homeFeedTable.separatorColor = .systemOrange
        homeFeedTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        homeFeedTable.addSubview(refreshControl)
        fetchItems()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        // Botão para ativar o modo de edição
      //  let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditMode))
        
        // Botão para deletar todos os checklists
        let deleteAllButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllItems))
        
        navigationItem.leftBarButtonItems = [ deleteAllButton]
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func handleChecklistItemUpdate() {
        fetchItems()
    }
    
    @objc func addItem(_ sender: UIButton) {
        viewModel?.goToAddChecklist()
    }
    
    @objc private func refreshData() {
        fetchItems()
    }
    
//    @objc private func toggleEditMode() {
//        homeFeedTable.setEditing(!homeFeedTable.isEditing, animated: true)
//        homeFeedTable.reloadData()
//    }
    
    @objc private func deleteAllItems() {
        let alertController = UIAlertController(title: "Delete All", message: "Tem certeza que quer apagar todos os checklists?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Apagar", style: .destructive) { _ in
            self.deleteAllChecklists()
        }
        let cancelAction = UIAlertAction(title: "Não", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func deleteAllChecklists() {
        PostService.shared.db_reference.child("items").removeValue { error, _ in
            if let error = error {
                print("Error deleting all checklists: \(error)")
                return
            }
            self.groupedChecklistItems.removeAll()
            self.homeFeedTable.reloadData()
        }
    }
    
    public func fetchItems(for date: Date? = nil) {
        PostService.shared.fetchAllItemsAdmin() { allItems in
            DispatchQueue.main.async {
                self.groupedChecklistItems = Dictionary(grouping: allItems) { item in
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "pt_BR")
                    dateFormatter.dateFormat = "MMMM, dd" // Agrupando por mês e dia
                    return dateFormatter.string(from: item.date)
                }
                self.homeFeedTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds // tableView na tela toda
    }
    
    private func showCommentDetails(for item: ChecklistItem) {
        let alertController = UIAlertController(title: item.title, message: item.comment ?? "Sem comentários", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
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
            showCommentDetails(for: checklistItem)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        let dateKey = sortedDates[indexPath.section]
        if let checklistItem = groupedChecklistItems[dateKey]?[indexPath.row] {
            cell.checklistItem = checklistItem
        }

        // Adiciona o deslocamento para a direita quando estiver no modo de edição
        let editModePadding: CGFloat = homeFeedTable.isEditing ? 40 : 0
        cell.contentView.frame = cell.contentView.frame.offsetBy(dx: editModePadding, dy: 0)
        
        return cell
    }
    
    // Suporte para deletar checklists individualmente
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dateKey = sortedDates[indexPath.section]
            if let itemToDelete = groupedChecklistItems[dateKey]?[indexPath.row] {
                PostService.shared.db_reference.child("items").child(itemToDelete.id).removeValue { error, _ in
                    if let error = error {
                        print("Error deleting checklist item: \(error)")
                        return
                    }
                    self.fetchItems()
                }
            }
        }
    }
}




