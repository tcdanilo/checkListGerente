//
//  FeedUserViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 15/05/24.
//

import UIKit

class FeedUserViewController: UIViewController {
   
    var viewModel : FeedUserViewModel?
    let sections = ["Checklist 1", "Checklist 2", "Checklist 3" ]
    
    
    private let homeFeedUserTable : UITableView = { // criação da tabela
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.backgroundColor = UIColor.systemBackground
        tv.register(FeedUserTableViewCell.self, forCellReuseIdentifier: FeedUserTableViewCell.identifier) // registrou a classe que vai ter dentro das celulas , UItableviewcell
        return tv
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedUserTable)
        
 }
    
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedUserTable.frame = view.bounds // tableView na tela toda
    }
    
   


}
extension FeedUserViewController : UITableViewDataSource, UITableViewDelegate{ // implementando o protocolo e suas funçoes obrigatorias
   // numero de sessões
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    // numero de linhas na seção
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //altura da linha
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {    // altura das sessoes
        return 40.0
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {      // titulo da header da collectionView
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.bounds.width, height: 40))
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.text = sections[section].uppercased()
        
        view.addSubview(label)
        return view
    }
    
    //qual a celula para a linha especifica
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as! FeedTableViewCell
        
        return cell
        
    }
    
}

    




