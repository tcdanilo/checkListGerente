//
//  FeedUserViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import UIKit
import FirebaseAuth

class FeedUserViewController: UIViewController {
    
    var viewModel : FeedUserViewModel?
    var checklistItems = [ChecklistItem]() {
        didSet{
            // filterChecklistItems()
            print("todo items was set")
            homeFeedUserTable.reloadData()
        }
    }
    private let refreshControl = UIRefreshControl()
    
    
    private let homeFeedUserTable : UITableView = { // criação da tabela
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.systemBackground
        tv.register(FeedUserTableViewCell.self, forCellReuseIdentifier: FeedUserTableViewCell.identifier) // registrou a classe que vai ter dentro das celulas , UItableviewcell
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
                self.checklistItems = allItems
                self.homeFeedUserTable.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedUserTable.frame = view.bounds // tableView na tela toda
    }
    
    @objc private func refreshData() {
        fetchItems()
    }
    
    
    
    
}
    extension FeedUserViewController : UITableViewDataSource, UITableViewDelegate{ // implementando o protocolo e suas funçoes obrigatorias
        // numero de sessões
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        // numero de linhas na seção
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return checklistItems.count
        }
        //altura da linha
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
        }
        
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {    // altura das sessoes
            return 40.0
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let checklistItem = checklistItems[indexPath.row]
            let newStatus = !checklistItem.isComplete
            
            PostService.shared.updateChecklistItemCompletionStatus(checklistID: checklistItem.id, isComplete: newStatus) { error, ref in
                if error == nil {
                    // Atualiza o status do item no array de dados
                    self.checklistItems[indexPath.row].isComplete = newStatus
                    
                    DispatchQueue.main.async {
                        // Recarrega apenas a última linha da tabela
                        let lastIndexPath = IndexPath(row: self.checklistItems.count - 1, section: 0)
                        self.homeFeedUserTable.reloadRows(at: [lastIndexPath], with: .automatic)
                    }
                } else {
                    print("Erro ao atualizar status: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

       
        
        //qual a celula para a linha especifica
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedUserTableViewCell.identifier, for: indexPath) as! FeedUserTableViewCell
            cell.checklistItem = checklistItems[indexPath.row]
            return cell
            
        }
        
    }



    




