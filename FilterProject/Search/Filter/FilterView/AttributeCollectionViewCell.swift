//
//  AttributeCollectionViewCell.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 15.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class AttributeCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var reuseIdentifier: String {
        get { return "AttributeCollectionViewCell" }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    fileprivate func setupViews () {
        contentView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        contentView.addSubview(attribute)
        attribute.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11).isActive = true
        attribute.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11).isActive = true
        attribute.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        contentView.backgroundColor = UIColor.blue
        
        contentView.bottomAnchor.constraint(equalTo: attribute.bottomAnchor, constant: 12).isActive = true
        contentView.layer.cornerRadius = 10
        

    }
    
    let attribute : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
