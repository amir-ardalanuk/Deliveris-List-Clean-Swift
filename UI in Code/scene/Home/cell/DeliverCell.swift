//
//  DeliverCell.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/23/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Kingfisher
class DeliveryCell : UITableViewCell {
    
    var lblTitleFrom : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "From: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lblTitleTo : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "To: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var lblFrom : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "4.9+"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lblTo : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "4.9+"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var imgView : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .red
        image.translatesAutoresizingMaskIntoConstraints = false
        image.radius(8)
        image.clipsToBounds = true
        return image
    }()
    
    var lblPrice : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "4.9+"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favoriteImageView : UIImageView = {
        let img = UIImageView()
        img.tintColor = .red
        img.image =  #imageLiteral(resourceName: "icons8-love-96")
        img.translatesAutoresizingMaskIntoConstraints = false;
        img.widthAnchor.constraint(equalToConstant: 16).isActive = true
        img.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        return img
    }()
    
    var mainHorizontalStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.alignment = UIStackView.Alignment.center
        sv.spacing = 16
        sv.distribution = UIStackView.Distribution.fill
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    var fromHorizontalStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fill
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    var destinationAndPriceStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.horizontal
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fill
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    var titlesVerticalStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fill
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    var verticalFromAndToStack : UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fill
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false;
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup(){
        self.addViews()
        self.makeViewsConstaint()
    }
}

extension DeliveryCell {
    func config(data : DeliveryModel){
        lblTo.text = data.to
        lblFrom.text = data.from
        lblPrice.text = data.price
        
        if let imgUrl = URL(string:data.imageUrl ?? "") {
            imgView.kf.setImage(with: imgUrl)
        }else{
            imageView?.image =  #imageLiteral(resourceName: "page-not-found")
        }
        favoriteImageView.isHidden = !data.fav
        
    }
}


extension DeliveryCell {
    
    func mainHorizontalStackConstraint(){
        let bottomConstraint = mainHorizontalStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -10)
        let constraints = [
            mainHorizontalStack.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor,constant: 10),
            mainHorizontalStack.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            bottomConstraint,
            mainHorizontalStack.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10)
        ]
        bottomConstraint.priority = UILayoutPriority(rawValue: 700)
        NSLayoutConstraint.activate(constraints)
        
    }
    
    func imageViewConstraint(){
        let constraints = [
            imgView.widthAnchor.constraint(equalTo: self.mainHorizontalStack.widthAnchor, multiplier: 0.2),
            imgView.aspectRation(1.0)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }

    func verticalFromAndToStackConstraint(){
        verticalFromAndToStack.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: NSLayoutConstraint.Axis.horizontal)
        verticalFromAndToStack.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: NSLayoutConstraint.Axis.horizontal)
    }
    
    func titlesVerticalStackConstraint(){
        titlesVerticalStack.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        titlesVerticalStack.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
        let constraints = [
                   titlesVerticalStack.widthAnchor.constraint(equalToConstant: 50)
               ]
               NSLayoutConstraint.activate(constraints)
    }
    
    
    
    func addViews(){
        
        self.contentView.addSubview(mainHorizontalStack)
        
        self.mainHorizontalStack.addArrangedSubview(imgView)
        self.mainHorizontalStack.addArrangedSubview(titlesVerticalStack)
        self.mainHorizontalStack.addArrangedSubview(verticalFromAndToStack)
        
        self.titlesVerticalStack.addArrangedSubview(lblTitleFrom)
        self.titlesVerticalStack.addArrangedSubview(lblTitleTo)
        
        self.verticalFromAndToStack.addArrangedSubview(fromHorizontalStack)
        self.verticalFromAndToStack.addArrangedSubview(destinationAndPriceStack)
        
        self.destinationAndPriceStack.addArrangedSubview(lblTo)
        self.destinationAndPriceStack.addArrangedSubview(lblPrice)
        
        self.fromHorizontalStack.addArrangedSubview(lblFrom)
        self.fromHorizontalStack.addArrangedSubview(favoriteImageView)
        
    }
    
    func makeViewsConstaint(){
        mainHorizontalStackConstraint()
        titlesVerticalStackConstraint()
        verticalFromAndToStackConstraint()
        imageViewConstraint()
    }
    
}
