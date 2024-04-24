//
//  FeedViewController.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import UIKit




class FeedViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
    }
    
    
    private func configureNavBar() {
        navigationItem.title = "Checklists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    @objc func addItem() {
        let addChecklistVC = AddChecklistViewController()
        navigationController?.pushViewController(addChecklistVC, animated: true)
        
        
    }
}
