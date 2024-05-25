

import UIKit
import Firebase


class FeedViewController: UIViewController {
    
    var viewModel : FeedViewModel?
    var checklistItems = [ChecklistItem]() {
        didSet{
            print("todo items was set")
            homeFeedTable.reloadData()
        }
    }
    private let refreshControl = UIRefreshControl()
   
  
    private let homeFeedTable : UITableView = { // criação da tabela
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.systemBackground
        tv.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier) // registrou a classe que vai ter dentro das celulas , UItableviewcell
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
        homeFeedTable.separatorColor = .systemGreen
        homeFeedTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        homeFeedTable.addSubview(refreshControl)
        fetchItems()
      
        
 }
    
    
    private func configureNavBar() {
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationController?.navigationBar.prefersLargeTitles = false
        
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
extension FeedViewController : UITableViewDataSource, UITableViewDelegate{ // implementando o protocolo e suas funçoes obrigatorias
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
        cell.checklistItem = checklistItems[indexPath.row]
        return cell
        
    }
    
}


