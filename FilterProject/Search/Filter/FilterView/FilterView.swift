//
//  FilterViewController.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 21.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

protocol FilterViewProtocol: class {
    
}

class FilterView: UIViewController , FilterViewProtocol {
    
    // MARK:  IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK:  Properties
    var presenter : FilterPresenterProtocol?
    
    var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.size.width
        layout.estimatedItemSize = CGSize(width: width, height: 1)
        return layout
    }()

    // MARK:  Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CheckBoxCollectoinViewCell.self, forCellWithReuseIdentifier: CheckBoxCollectoinViewCell.reuseIdentifier)

        collectionView.register(PriceCollectionViewCell.self, forCellWithReuseIdentifier: PriceCollectionViewCell.reuseIdentifier)
        
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.reuseIdentifier)
        
        collectionView.register(FooterCollectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FooterCollectionView.reuseIdentifier)
        
        collectionView.register(AttributeCollectionViewCell.self, forCellWithReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier)
        
        collectionView?.collectionViewLayout = collectionLayout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
}

// MARK:  UICollectionViewDataSource, UICollectionViewDelegate

    private let numberOfRows = [1,2,1,5]

    private var cashedHeights = [IndexPath: CGFloat] ()

extension FilterView : UICollectionViewDataSource, UICollectionViewDelegate {
    
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
                let checkBoxCell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckBoxCollectoinViewCell.reuseIdentifier, for: indexPath) as? CheckBoxCollectoinViewCell
                checkBoxCell?.name.text = indexPath.section == 0 ? "Закрепленный фильтр \(indexPath.row + 1)" : "Фильтр \(indexPath.row + 1)"
                checkBoxCell?.filterDescription.text = indexPath.section == 0 ? "Animation with constraints is easy, you shouldn't believe what others might say. I made some rules and an example that'll help you understanding the basic principles." : "Even Apple is struggling with adaptive layouts in the built-in iOS applications."
                checkBoxCell?.filterDescription.sizeToFit()
                cell = checkBoxCell
            case 2:
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceCollectionViewCell.reuseIdentifier, for: indexPath) as? PriceCollectionViewCell
            case 3:
                let attributeCell = collectionView.dequeueReusableCell(withReuseIdentifier: AttributeCollectionViewCell.reuseIdentifier, for: indexPath) as? AttributeCollectionViewCell
                attributeCell?.attribute.text = indexPath.row % 2 == 0 ? "Аттрибут \(indexPath.row + 1)" : "Аттр. \(indexPath.row + 1)"
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

extension FilterView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.reuseIdentifier, for: indexPath) as! HeaderCollectionView
            reusableView.title.text = "Группа фильтров \(indexPath.section + 1)"
            return reusableView
        case UICollectionElementKindSectionFooter:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FooterCollectionView.reuseIdentifier, for: indexPath) as! FooterCollectionView
            return reusableView
        default:
            fatalError("Undexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) ->  CGSize {
        if section == 3 {
            return CGSize(width: view.bounds.width/2, height: 50)
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
