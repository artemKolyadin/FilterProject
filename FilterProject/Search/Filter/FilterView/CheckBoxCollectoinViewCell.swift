//
//  CheckBoxCollectoinViewCell.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 15.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class CheckBoxCollectoinViewCell: UICollectionViewCell {
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var reuseIdentifier: String {
        get { return "CheckBoxCollectoinViewCell" }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    
    fileprivate func setupViews () {
        
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        contentView.addSubview(checkBox)
        checkBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28).isActive = true
        checkBox.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        checkBox.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 25/375).isActive = true
        checkBox.heightAnchor.constraint(equalTo: checkBox.widthAnchor, multiplier: 1).isActive = true
        
        contentView.addSubview(name)
        name.topAnchor.constraint(equalTo:contentView.topAnchor, constant: 10).isActive = true
        name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        name.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -20).isActive = true

        contentView.addSubview(filterDescription)
        filterDescription.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        filterDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        filterDescription.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -20).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: filterDescription.bottomAnchor, constant: 10).isActive = true
        
    }
    
    let name: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filterDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icons8-unchecked-checkbox-40")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
}
