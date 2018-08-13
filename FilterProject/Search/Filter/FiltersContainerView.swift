//
//  FilterVIew.swift
//  FizcultApp
//
//  Created by Artem Kolyadin on 13.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

protocol FlagFilterProtocol {
    var state: FlagFilterState {get set}
}

enum FlagFilterState {
    case enabled
    case disabled
    
    var opposite: FlagFilterState {
        return self == .enabled ? .disabled : .enabled
    }
}

class FiltersContainerView: UIView, AttributeFilterDelegate, CheckBoxFilterDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tappableView: UIView!
    @IBOutlet weak var roundedCornerView: UIView!
    @IBOutlet weak var lineAngleIndicatorContainer: UIView!
    @IBOutlet weak var lineAngleIndicator: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var mainFiltersContainer: UIView!
    @IBOutlet weak var mainFiltersStackView: UIStackView!
    @IBOutlet weak var otherFiltersContainer: UIView!
    @IBOutlet weak var otherFiltersStackView: UIStackView!
    @IBOutlet weak var attributeFiltersContainer: UIView!
    @IBOutlet weak var applyFiltersButton: UIButton!
    @IBOutlet weak var priceFilterContainer: UIView!
    
    var mainFilters : [CheckBoxFilter]?
    var otherFilters: [CheckBoxFilter]?
    var attributeFilters: [AttributeFilter]?
    var priceFilterView : PriceFilterView?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed("FiltersContainerView", owner: self, options: nil)
        addSubview(contentView)
        layout()
        
        ServerManager.shared.getMainFilters { filters in
            self.mainFilters = filters
            self.configureMainFilters()
        }
        ServerManager.shared.getOtherFilters { filters in
            self.otherFilters = filters
            self.configureOtherFilters()
        }
        ServerManager.shared.getAttributeFilters { filters in
            self.attributeFilters = filters
            self.configureAttributeFilters()
        }
        configurePriceFilter()
        layoutIfNeeded()
    }
    
    private func layout() {
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 10
        resetButton.layer.cornerRadius = resetButton.frame.size.height/7
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor =  #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        resetButton.tintColor = UIColor.black
        applyFiltersButton.tintColor = UIColor.white
        applyFiltersButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        applyFiltersButton.layoutIfNeeded()
        applyFiltersButton.layer.cornerRadius = applyFiltersButton.frame.height / 5
        applyFiltersButton.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
     private func configureAttributeFilters () {
        self.attributeFiltersContainer.layoutIfNeeded()
        var lastView = AttributeFilterView()
        var x:CGFloat = 0
        var y:CGFloat = 0
        let xSpacing:CGFloat = 15
        let ySpacing:CGFloat = 15
        var tag = 0
        for attribute in attributeFilters! {
            let view = AttributeFilterView()
            view.name.text = attribute.name
            view.facilityButton.tag = tag
            view.delegate = self
            view.layoutIfNeeded()
            view.frame = CGRect(x:x,y:y,width:view.name.frame.width+22,height:32)
            if view.frame.width >= self.attributeFiltersContainer.frame.width - x {
                x = 0
                y = y + view.frame.height + ySpacing
            }
            view.frame = CGRect(x:x,y:y,width:view.frame.width,height:view.frame.height)
            attributeFiltersContainer.addSubview(view)
            x = x + view.frame.width + xSpacing
            lastView = view
            tag += 1
        }
        let verticalSpace = NSLayoutConstraint(item: lastView, attribute: .bottom, relatedBy: .equal, toItem: self.attributeFiltersContainer, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([verticalSpace])
    }
    
    private func configureMainFilters () {
        self.mainFiltersContainer.layoutIfNeeded()
        for mainFilter in self.mainFilters! {
            let view = CheckBoxFilterView()
            view.name.text = mainFilter.name
            view.descriptionLabel.text = mainFilter.description
            view.delegate = self
            mainFiltersStackView.addArrangedSubview(view)
        }
    }
    
    private func configureOtherFilters () {
        self.otherFiltersContainer.layoutIfNeeded()
        for otherFilter in otherFilters! {
            let view = CheckBoxFilterView()
            view.name.text = otherFilter.name
            view.descriptionLabel.text = otherFilter.description
            view.delegate = self
            otherFiltersStackView.addArrangedSubview(view)
        }
    }
    
    private func configurePriceFilter () {
        self.priceFilterContainer.layoutIfNeeded()
        let view = PriceFilterView(frame: priceFilterContainer.bounds)
        priceFilterView = view
        self.priceFilterContainer.addSubview(view)
    }
    
    func attributeFilterPressed(name: String, state: FlagFilterState) {
        let attribute = attributeFilters?.filter({ (Attribute) -> Bool in
            Attribute.name == name
        }).first
        if attribute != nil {
        switch state {
        case .disabled:
            attribute?.isActive = false
        default:
            attribute?.isActive = true
            }
        }
    }
    
    func checkBoxFilterPressed(name: String, state: FlagFilterState) {
        let otherFilter = otherFilters?.filter({ (CheckBoxFilter) -> Bool in
            CheckBoxFilter.name == name
        }).first
        if otherFilter != nil {
        switch state {
        case .disabled:
            otherFilter?.isActive = false
        default:
            otherFilter?.isActive = true
            }
        }
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        for filterView in attributeFiltersContainer.subviews {
            if let filter = filterView as? AttributeFilterView {
                filter.state = .disabled
            }
        }
        for filterView in otherFiltersStackView.arrangedSubviews {
            if let filter = filterView as? CheckBoxFilterView {
                filter.state = .disabled
            }
        }
        if let priceFilterView = priceFilterView {
            priceFilterView.resetPriceRange()
        }
        for filterView in mainFiltersStackView.arrangedSubviews {
            if let filter = filterView as? CheckBoxFilterView {
                filter.state = .disabled
            }
        }
    }
    @IBAction func mockButtonClicked(_ sender: Any) {
        //костыль
        //чтобы фильтер вью не уезжал вниз при промахе в ближайшей области он кнопки сбросить
    }
    
}
