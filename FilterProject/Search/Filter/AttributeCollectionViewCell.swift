//
//  AttributeCollectionViewCell.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 15.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class AttributeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    static var reuseIdentifier: String {
        get { return "AttributeCollectionViewCell" }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
