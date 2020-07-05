//
//  NewsCell.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Domain

class NewsCell: UITableViewCell {
    var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imgView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .lightGray
        image.translatesAutoresizingMaskIntoConstraints = false
        image.radius(8)
        image.clipsToBounds = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return image
    }()
    
    var lblDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lblDes: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
}
//Lifecylce
extension NewsCell {
    
    private func setup() {
        bakeUi()
    }
    
    func config(model: NewsModel) {
        if let image = URL(string: model.imagePath ?? "") {
            imgView.kf.setImage(with: image)
        } else {
            imgView.image = #imageLiteral(resourceName: "page-not-found")
        }
        self.lblTitle.text = model.title
        self.lblDes.text = model.desc
        self.lblDate.text = model.date
    }
}
//Constraint - View
extension NewsCell {
    
    func bakeUi() {
        let main = ViewMaker.makeStackView(axios: .horizontal, aligment: .top, space: 8)
        self.contentView.addSubview(main)
        
        main.addArrangedSubview(makeLabelesStack())
        main.addArrangedSubview(imgView)
        
        main.activateFillConstraint(with: self.contentView, margin: 8)
    }
    
    func makeLabelesStack() -> UIStackView {
        let verticalSV = ViewMaker.makeStackView( aligment: .trailing, space: 8)
        verticalSV.addArrangedSubview(lblTitle)
        verticalSV.addArrangedSubview(lblDes)
        verticalSV.addArrangedSubview(lblDate)
        
        return verticalSV
    }
}
