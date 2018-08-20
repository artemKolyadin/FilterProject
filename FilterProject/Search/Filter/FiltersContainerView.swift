//
//  FilterVIew.swift
//  FizcultApp
//
//  Created by Artem Kolyadin on 13.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

class FiltersContainerView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tappableView: UIView!
    @IBOutlet weak var roundedCornerView: UIView!
    @IBOutlet weak var lineAngleIndicatorContainer: UIView!
    @IBOutlet weak var lineAngleIndicator: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var filterCollectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 1)
        return layout
    }()
    
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

        filterCollectionView.register(CheckBoxCollectoinViewCell.self, forCellWithReuseIdentifier: CheckBoxCollectoinViewCell.reuseIdentifier)
        
        filterCollectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: PriceCollectionViewCell.reuseIdentifier)
        
        let attributeNibCell = UINib(nibName: AttributeCollectionViewCell.reuseIdentifier, bundle: nil)
        filterCollectionView.register(attributeNibCell, forCellWithReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier)
        
        let nibTitle = UINib(nibName: HeaderCollectionView.reuseIdentifier, bundle: nil)
        filterCollectionView.register(nibTitle, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.reuseIdentifier)
        
        let applyButtonNib = UINib(nibName: ApplyButtonCollectionView.reuseIdentifier, bundle: nil)
        filterCollectionView.register(applyButtonNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ApplyButtonCollectionView.reuseIdentifier)
        
        
        filterCollectionView?.collectionViewLayout = filterCollectionLayout
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
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
    }
    
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
    }
    @IBAction func mockButtonClicked(_ sender: Any) {
        //костыль
        //чтобы фильтер вью не уезжал вниз при промахе в ближайшей области он кнопки сбросить
    }
    
}

// MARK:  UICollectionViewDataSourse, UICollectionViewDelegate

    private let numberOfRows = [1,2,1,5]

    private var cashedHeights = [IndexPath:CGFloat]()

extension FiltersContainerView : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfRows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell?
        
        switch indexPath.section {
        case 0,1:
            let checkBoxCell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCollectoinViewCell.reuseIdentifier, for: indexPath) as? CheckBoxCollectoinViewCell
            checkBoxCell?.name.text = indexPath.section == 0 ? "Закрепленный фильтр \(indexPath.row + 1)" : "Фильтр \(indexPath.row + 1)"
            checkBoxCell?.filterDescription.text = indexPath.section == 0 ? "Animation with constraints is easy, you shouldn't believe what others might say. I made some rules and an example that'll help you understanding the basic principles." : "Even Apple is struggling with adaptive layouts in the built-in iOS applications."
            checkBoxCell?.filterDescription.sizeToFit()
            cell = checkBoxCell
        case 2:
             cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: PriceCollectionViewCell.reuseIdentifier, for: indexPath) as? PriceCollectionViewCell
        case 3:
            let attributeCell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier, for: indexPath) as? AttributeCollectionViewCell
            attributeCell?.name.text = indexPath.row % 2 == 0 ? "Аттрибут \(indexPath.row + 1)" : "Аттр. \(indexPath.row + 1)"
            cell = attributeCell
        default:
            fatalError("Unexpected section")
        }
        cell?.layoutSubviews()
        
        if cell?.systemLayoutSizeFitting(UILayoutFittingExpandedSize) != nil {
            cashedHeights[indexPath] = cell?.systemLayoutSizeFitting(UILayoutFittingExpandedSize).height
        }
        return cell ?? UICollectionViewCell(frame: CGRect.zero)
    }
}

// MARK:  UICollectionViewDelegateFlowLayout

extension FiltersContainerView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.reuseIdentifier, for: indexPath) as! HeaderCollectionView
            reusableView.groupName.text = "Группа фильтров \(indexPath.section + 1)"
            return reusableView
        case UICollectionElementKindSectionFooter:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ApplyButtonCollectionView.reuseIdentifier, for: indexPath) as! ApplyButtonCollectionView
            return reusableView
        default:
            fatalError("Undexpected element kind")
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: contentView.bounds.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 3 {
            return CGSize(width: contentView.bounds.width/2, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 3 {
             return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = cashedHeights[indexPath] ?? 60
        let itemWidth = indexPath.section == 3 ? UIScreen.main.bounds.size.width - 40 : UIScreen.main.bounds.size.width
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }

}
