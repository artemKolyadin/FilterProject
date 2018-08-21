
import UIKit

class HeaderCollectionView: UICollectionReusableView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var reuseIdentifier: String {
        get { return "HeaderCollectionView" }
    }
    
    fileprivate func setupViews() {
        
        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.backgroundColor = UIColor.blue
        self.addSubview(title)
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        title.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true

        self.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 13).isActive = true
        
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.orange
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
