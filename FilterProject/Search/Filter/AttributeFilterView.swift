//
//  AttributeFilterView.swift
//  FizcultApp
//
//  Created by Artem Kolyadin on 18.07.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import UIKit

protocol AttributeFilterDelegate {
    func attributeFilterPressed (name: String, state: FlagFilterState)
}

class AttributeFilterView: UIView, FlagFilterProtocol {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var facilityButton: UIButton!
    
    var state: FlagFilterState = .disabled {
        didSet {
            switch self.state {
            case .disabled:
                self.contentView.backgroundColor = UIColor.white
                self.name.textColor = UIColor.black
                self.contentView.layer.borderWidth = 1
            default:
                self.contentView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                self.name.textColor = UIColor.white
                self.contentView.layer.borderWidth = 0
            }
        }
    }
    var delegate : AttributeFilterDelegate!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    private func commitInit() {
        Bundle.main.loadNibNamed("AttributeFilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
    }

    @IBAction func facilityFilterChecked(_ sender: UIButton) {
          state = self.state.opposite
          delegate.attributeFilterPressed(name: name.text!, state: state)
    }
}
