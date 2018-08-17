//
//  CheckBoxTitleView.swift
//  FilterProject
//CheckBoxCollectoinViewCell
//  Created by Artem Kolyadin on 15.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class HeaderCollectionView: UICollectionReusableView {

    @IBOutlet weak var groupName: UILabel!
    
    static var reuseIdentifier: String {
        get { return "HeaderCollectionView" }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
