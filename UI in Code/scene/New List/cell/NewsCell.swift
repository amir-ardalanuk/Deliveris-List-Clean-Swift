//
//  NewsCell.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/30/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import Domain
import RxCocoa
import RxSwift

class NewsCell: UITableViewCell {
    
    let onFavoriteClicked = PublishSubject<String>()
    var bag = DisposeBag()
    
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
    
    var btnFav: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "icons8-love-96"), for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bag = DisposeBag()
    }
    
    private func setup() {
        bakeUi()
    }
    
    func config(model: NewsModel) -> PublishSubject<String> {
        if let image = URL(string: model.imagePath ?? "") {
            imgView.kf.setImage(with: image)
        } else {
            imgView.image = #imageLiteral(resourceName: "page-not-found")
        }
        self.lblTitle.text = model.title
        self.lblDes.text = model.desc
        self.lblDate.text = model.date
        
        self.btnFav.setImage(model.isFavorite ? #imageLiteral(resourceName: "icons8-love-96") : #imageLiteral(resourceName: "icons8-love-32"), for: .normal)
        self.btnFav.rx.tap.map {
            let new = model.toggleFavoriteState()
            return new.link ?? "-1"
        }.bind(to: onFavoriteClicked).disposed(by: bag)
        return onFavoriteClicked
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
        
        let dateAndFav = makeDateAndFavStack()
        verticalSV.addArrangedSubview(dateAndFav)
        
        dateAndFav.leadingAnchor.constraint(equalTo: verticalSV.leadingAnchor, constant: 8).isActive = true
        
        return verticalSV
    }
    
    func makeDateAndFavStack() -> UIStackView {
        let horizontalStack = ViewMaker.makeStackView(axios: .horizontal, distribution: .fill, aligment: .center, space: 8)
        
        horizontalStack.addArrangedSubview(btnFav)
        horizontalStack.addArrangedSubview(lblDate)
        return horizontalStack
    }
}
