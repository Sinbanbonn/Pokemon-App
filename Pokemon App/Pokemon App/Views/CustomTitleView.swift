import UIKit
import Foundation

class TitleView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Pokemon List"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if PokemonManager.shared.isConnectedToNetwork {
            imageView.image = UIImage(systemName: "wifi")
        }else {
            imageView.image = UIImage(systemName: "wifi.slash")}
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(imageView)
        
        let imageViewContraints = [
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
        ]
        
        let titleLabelConstaints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -200),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewContraints)
        NSLayoutConstraint.activate(titleLabelConstaints)
    }
}
