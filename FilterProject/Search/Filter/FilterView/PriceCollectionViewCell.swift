//
//  PriceCollectionViewCell.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 17.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class PriceCollectionViewCell: UICollectionViewCell {
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    static var reuseIdentifier: String {
        get { return "PriceCollectionViewCell" }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    func setupViews() {
        contentView.addSubview(rangeLabel)
        rangeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        rangeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        rangeLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 335/375 , constant: 0).isActive = true
        
        contentView.addSubview(rangeSlider)
        rangeSlider.topAnchor.constraint(equalTo: rangeLabel.bottomAnchor, constant: 10).isActive = true
        rangeSlider.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        rangeSlider.widthAnchor.constraint(equalTo: rangeLabel.widthAnchor).isActive = true
        rangeSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.bottomAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 20).isActive = true
        
    }
    
    let rangeSlider: RangeSlider = {
        let slider = RangeSlider(frame: CGRect(x:0,y:0,width: UIScreen.main.bounds.size.width-40, height:30))
        slider.knobTintColor = UIColor.white
        slider.knobBorderThickness = 0.5
        slider.minimumValue = 2000
        slider.maximumValue = 5000
        slider.lowerValue = 2000
        slider.upperValue = 5000
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let rangeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "Диапазон значений"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
