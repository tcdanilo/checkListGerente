//
//  LoadingButton.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import Foundation
import UIKit

class LoadingButton : UIView {
    
    lazy var button : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let progress : UIActivityIndicatorView = {
        let p = UIActivityIndicatorView()
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    
    }()
    
    var title : String? {
        willSet{
            button.setTitle(newValue, for: .normal)
        }
    }
    
    var titleColor : UIColor? {
        willSet{
            button.setTitleColor(newValue, for: .normal)
        }
    }
  
    override var backgroundColor: UIColor? {
        willSet{
            button.backgroundColor = newValue
        }
    }
        
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(_ target : Any?, action : Selector) {
        
        button.addTarget(target, action: action, for: .touchUpInside)
        
    }
    func startLoading(_ loading : Bool){
        button.isEnabled = !loading
        if loading{
            button.setTitle("", for: .normal)
            progress.startAnimating()
            alpha = 0.5
        }else{
            button.setTitle(title, for: .normal)
            progress.stopAnimating()
            alpha = 1.0
           
        }
    }
    
    
    private func setupViews() {
        
        addSubview(button)
        addSubview(progress)
       
        let buttonConstraints = [
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 50.0)
            
        
        ]
        let progressConstraints = [
          progress.leadingAnchor.constraint(equalTo: leadingAnchor),
          progress.trailingAnchor.constraint(equalTo: trailingAnchor),
          progress.topAnchor.constraint(equalTo: topAnchor),
          progress.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ]
        NSLayoutConstraint.activate(buttonConstraints)
        NSLayoutConstraint.activate(progressConstraints)
    }

    
   
    
    
    
    
    
}

