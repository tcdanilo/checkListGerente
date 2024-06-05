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
            filterChecklists(for: selectedDate)
            print("todo items was set")
           // homeFeedUserTable.reloadData()
        }
    }
    
    var filteredChecklistItems = [ChecklistItem]()
    var selectedDate: Date? {
            didSet {
                filterChecklists(for: selectedDate)
            }
        }
    
    private let refreshControl = UIRefreshControl()
    
    
    private let homeFeedUserTable : UITableView = { // criação da tabela
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.systemBackground
        tv.register(FeedUserTableViewCell.self, forCellReuseIdentifier: FeedUserTableViewCell.identifier) // registrou a classe que vai ter dentro das celulas , UItableviewcell
        return tv
    }()
    
    private let datesCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .systemBackground
            collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
            return collectionView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedUserViewModel()
        viewModel?.coordinator = FeedUserCoordinator(navigationController: navigationController!)
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedUserTable)
        view.addSubview(datesCollectionView)
        datesCollectionView.dataSource = self
        datesCollectionView.delegate = self
        homeFeedUserTable.dataSource = self
        homeFeedUserTable.delegate = self
        homeFeedUserTable.separatorColor = .systemGreen
        homeFeedUserTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        homeFeedUserTable.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        fetchItems()
      
    }
    
    private func filterChecklists(for date: Date?) {
            if let date = date {
                let calendar = Calendar.current
                filteredChecklistItems = checklistItems.filter { checklist in
                    return calendar.isDate(checklist.date, inSameDayAs: date)
                }
            } else {
                filteredChecklistItems = checklistItems
            }
            homeFeedUserTable.reloadData()
        }
    
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                datesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                datesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                datesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                datesCollectionView.heightAnchor.constraint(equalToConstant: 100),

                homeFeedUserTable.topAnchor.constraint(equalTo: datesCollectionView.bottomAnchor, constant: 16),
                homeFeedUserTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                homeFeedUserTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                homeFeedUserTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
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
            return filteredChecklistItems.count
        }
        //altura da linha
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 75
        }
        
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {    // altura das sessoes
            return 40.0
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let checklistItem = filteredChecklistItems[indexPath.row]
                    let newStatus = !checklistItem.isComplete
                    
                    PostService.shared.updateChecklistItemCompletionStatus(checklistID: checklistItem.id, isComplete: newStatus) { error, ref in
                        if error == nil {
                            // Atualiza o status do item no array original
                            if let originalIndex = self.checklistItems.firstIndex(where: { $0.id == checklistItem.id }) {
                                self.checklistItems[originalIndex].isComplete = newStatus
                            }
                            
                            // Atualiza a lista filtrada e recarrega a tabela
                            self.filterChecklists(for: self.selectedDate)
                            
                            DispatchQueue.main.async {
                                // Recarrega apenas a linha atual da tabela
                                self.homeFeedUserTable.reloadRows(at: [indexPath], with: .automatic)
                            }
                        } else {
                            print("Erro ao atualizar status: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }

       
        
        //qual a celula para a linha especifica
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedUserTableViewCell.identifier, for: indexPath) as! FeedUserTableViewCell
                    cell.checklistItem = filteredChecklistItems[indexPath.row]
                    return cell
            
        }
        
    }


extension FeedUserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30 // Exibir datas para os próximos 30 dias
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCollectionViewCell
        let date = Date().addingTimeInterval(TimeInterval(86400 * indexPath.item)) // Adiciona `indexPath.item` dias à data atual
        cell.configure(with: date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = Date().addingTimeInterval(TimeInterval(86400 * indexPath.item))
        selectedDate = date
        filterChecklists(for: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) // Tamanho das células
    }
}



    




