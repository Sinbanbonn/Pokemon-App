//
//  CustomTitleView.swift
//  Pokemon App
//
//  Created by Андрей Логвинов on 7/21/23.
//
import UIKit
import Foundation

class TitleView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if isConnectedToNetwork {
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
        
        // Add constraints to position the label and image view
        // You can customize the layout as needed
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -200),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
