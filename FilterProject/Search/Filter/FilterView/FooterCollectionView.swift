//
//  ApplyButtonCollectionView.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 17.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class FooterCollectionView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var reuseIdentifier: String {
        get { return "FooterCollectionView" }
    }
    
    fileprivate func setupViews() {
        
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(applyButton)
        applyButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        applyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        applyButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        applyButton.backgroundColor = UIColor.blue
        
        self.bottomAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: -15).isActive = true
    }
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitle("Применить", for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}
