

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
    
    @objc func addItem(_ sender: UIButton) {
        viewModel?.goToAddChecklist()
    }
    
    @objc private func refreshData() {
        fetchItems()
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
        let alertController = UIAlertController(title: item.title, message: item.comment ?? "No comment", preferredStyle: .alert)
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
        return cell
    }
}



