//
//  logoUIView.swift
//  checkListGerente
//
//  Created by Danilo Costa tiago on 27/03/24.
//

import UIKit

class logoUIView: UIView {

    private let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "logo")
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        
    }
    
}
