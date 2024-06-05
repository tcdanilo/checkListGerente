

import UIKit
import Firebase


class FeedViewController: UIViewController {
    
    var viewModel : FeedViewModel?
    var checklistItems = [ChecklistItem]() {
        didSet{
            filterChecklists(for: selectedDate)
            print("todo items was set")
          //  homeFeedTable.reloadData()
        }
    }
    var filteredChecklistItems = [ChecklistItem]()
        var selectedDate: Date? {
            didSet {
                filterChecklists(for: selectedDate)
            }
        }
    private let refreshControl = UIRefreshControl()
    var collectionViewHeader: CustomHeaderView?
   
  
    private let homeFeedTable : UITableView = { // criação da tabela
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.systemBackground
        tv.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier) // registrou a classe que vai ter dentro das celulas , UItableviewcell
        return tv
    }()
    private let datesCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .systemBackground
            collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCell")
            return collectionView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        viewModel = FeedViewModel()
        viewModel?.coordinator = FeedCoordinator(navigationController: navigationController!)
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        view.addSubview(datesCollectionView)
        datesCollectionView.dataSource = self
        datesCollectionView.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        homeFeedTable.separatorColor = .systemGreen
        homeFeedTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        homeFeedTable.addSubview(refreshControl)
        fetchItems()
        setupConstraints()
        collectionViewHeader = CustomHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 150))
        homeFeedTable.tableHeaderView = collectionViewHeader
        
 }
    
    private func setupConstraints() {
            NSLayoutConstraint.activate([
                datesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                datesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                datesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                datesCollectionView.heightAnchor.constraint(equalToConstant: 100),

                homeFeedTable.topAnchor.constraint(equalTo: datesCollectionView.bottomAnchor, constant: 16),
                homeFeedTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                homeFeedTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                homeFeedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
        }
    
    private func configureNavBar() {
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationController?.navigationBar.prefersLargeTitles = false
        
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
            homeFeedTable.reloadData()
        }
    @objc private func handleChecklistItemUpdate() {
        fetchItems()
    }
    
   
    
    @objc func addItem(_ sender : UIButton) {
        viewModel?.goToAddChecklist()
    }
    @objc private func refreshData() {
            fetchItems()
        }
    
    public func fetchItems() {
        PostService.shared.fetchAllItemsAdmin() { allItems in
                DispatchQueue.main.async {
                    self.checklistItems = allItems
                    self.homeFeedTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
    }
    
    
    
    
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds // tableView na tela toda
    }
    
   


}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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


extension FeedViewController : UITableViewDataSource, UITableViewDelegate{ // implementando o protocolo e suas funçoes obrigatorias
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
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let checklistItem = checklistItems[indexPath.row]
//            let newStatus = !checklistItem.isComplete
//            
//            PostService.shared.updateChecklistItemCompletionStatus(checklistID: checklistItem.id, isComplete: newStatus) { error, ref in
//                if error == nil {
//                    self.checklistItems[indexPath.row].isComplete = newStatus
//                    DispatchQueue.main.async {
//                        self.homeFeedTable.reloadRows(at: [indexPath], with: .automatic)
//                        
//                    }
//                } else {
//                    print("Erro ao atualizar status: \(error?.localizedDescription ?? "Unknown error")")
//                }
//            }
//        }

   
    
    //qual a celula para a linha especifica
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
                cell.checklistItem = filteredChecklistItems[indexPath.row]
                return cell
            }
        
    }
    



