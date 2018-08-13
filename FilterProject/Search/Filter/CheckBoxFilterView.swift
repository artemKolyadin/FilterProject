//
//  FlagFilterView.swift
//  FizcultApp
//
//  Created by Artem Kolyadin on 13.07.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

protocol CheckBoxFilterDelegate {
    func checkBoxFilterPressed(name: String, state: FlagFilterState)
}

class CheckBoxFilterView: UIView, FlagFilterProtocol {
    
    var state: FlagFilterState = .disabled {
        didSet {
            switch self.state {
            case .disabled:
                self.checkboxImage.image = #imageLiteral(resourceName: "icons8-unchecked-checkbox-40")
            default:
                self.checkboxImage.image = #imageLiteral(resourceName: "icons8-tick-box-80")
            }
        }
    }
    
    var delegate: CheckBoxFilterDelegate!
    
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBInspectable var valueName : String? {
        get {
            return name.text
        }
        set (valueName) {
            name.text = valueName
        }
    }
    
    @IBInspectable var valueText : String? {
        get {
            return descriptionLabel.text
        }
        
        set (valueText) {
            descriptionLabel.text = valueText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commitInit()    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed("CheckBoxFilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    @IBAction func filterClicked(_ sender: UIButton) {
        state = self.state.opposite
        delegate.checkBoxFilterPressed(name: name.text!, state: state)
    }
    
}

