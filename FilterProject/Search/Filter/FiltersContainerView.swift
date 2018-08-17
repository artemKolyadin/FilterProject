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
        layout.estimatedItemSize = CGSize(width: width, height: 60)
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

extension FiltersContainerView : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCollectoinViewCell.reuseIdentifier, for: indexPath) as! CheckBoxCollectoinViewCell
            cell.name.text = "Закрепленный фильтр \(indexPath.row + 1)"
            cell.filterDescription.text = "Animation with constraints is easy, you shouldn't believe what others might say. I made some rules and an example that'll help you understanding the basic principles."
            return cell
        case 1:
            let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCollectoinViewCell.reuseIdentifier, for: indexPath) as! CheckBoxCollectoinViewCell
            cell.name.text = "Фильтр \(indexPath.row + 1)"
            cell.filterDescription.text = "Even Apple is struggling with adaptive layouts in the built-in iOS applications."
            return cell
        case 2:
            let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: PriceCollectionViewCell.reuseIdentifier, for: indexPath) as! PriceCollectionViewCell
            return cell
        case 3:
            let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier, for: indexPath) as! AttributeCollectionViewCell
            if indexPath.row % 2 == 0 {
                cell.name.text = "Аттрибут \(indexPath.row + 1)"
            } else {
                cell.name.text = "Атр. \(indexPath.row + 1 )"
            }
            return cell
        default:
            let cell = filterCollectionView.dequeueReusableCell(withReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier, for: indexPath) as! AttributeCollectionViewCell
            return cell
        }
        
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
        default:
            fatalError("Undexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: contentView.bounds.width, height: 35)
    }
    
    
}
