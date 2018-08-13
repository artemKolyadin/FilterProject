//
//  PriceFilterView.swift
//  FizcultApp
//
//  Created by Artem Kolyadin on 13.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class PriceFilterView : UIView {
    
    @IBOutlet weak var priceRangeLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var priceSliderContainer: UIView!
    
    var rangeSlider : RangeSlider?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed("PriceFilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layoutIfNeeded()
        let rangeSlider = RangeSlider(frame: priceSliderContainer.frame)
        rangeSlider.knobTintColor = UIColor.white
        rangeSlider.knobBorderThickness = 0.5
        rangeSlider.minimumValue = 2000
        rangeSlider.maximumValue = 5000
        rangeSlider.lowerValue = 2200
        rangeSlider.upperValue = 4800
        rangeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: UIControlEvents.allEvents)
        self.rangeSlider = rangeSlider
        contentView.addSubview(rangeSlider)
    }
    
    @objc func sliderValueChanged(_ rangeSlider:RangeSlider) {
        updatePriceRangeLabel(rangeSlider)
    }
    
    func updatePriceRangeLabel (_ rangeSlider: RangeSlider) {
            priceRangeLabel.text = "\(Int(rangeSlider.lowerValue)) - \(Int(rangeSlider.upperValue))"
    }
    
    func resetPriceRange () {
        if let slider = self.rangeSlider {
            slider.lowerValue = slider.minimumValue
            slider.upperValue = slider.maximumValue
            updatePriceRangeLabel(slider)
        }
    }
}
