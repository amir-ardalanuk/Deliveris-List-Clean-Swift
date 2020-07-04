//
//  DeliveryDetailViewController.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/23/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DeliveryDetailViewController: UIViewController {
    
    let bag = DisposeBag()
    
    var vMainStack: UIStackView = {
        let sv = UIStackView()
        sv.axis  = NSLayoutConstraint.Axis.vertical
        sv.alignment = UIStackView.Alignment.fill
        sv.distribution = UIStackView.Distribution.fill
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var labelTitleFrom: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "From:"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelTitleTo: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "To:"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelFrom: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "XXXX"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelTo: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "XXXX"
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favoriteButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("Add to Favorite", for: UIControl.State.normal)
        btn.setImage(#imageLiteral(resourceName: "icons8-love-96"), for: UIControl.State.normal)
        btn.backgroundColor = .white
        btn.tintColor = .blue
        btn.radius(8)
        btn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        return btn
    }()
    
    var labelStatusTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "title"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelPriceTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "DeliveryFee"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelPrice: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "85"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var deliveryImage: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = .blue
        return imgv
    }()
    
    let viewModel: DeliveryDetailViewModel
    
    init(viewModel: DeliveryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//Lifecylce
extension DeliveryDetailViewController {
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .lightGray
        self.addViews()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.databinding()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Delivery Detail"
    }
}

//data binding
extension DeliveryDetailViewController {
    func databinding() {
        let output = viewModel.transform(input: DeliveryDetailViewModel.Input(changeFavoriteStatus:
            favoriteButton.rx.controlEvent(.touchUpInside)
            .asDriver()))
        output.from.drive(labelFrom.rx.text).disposed(by: bag)
        output.to.drive(labelTo.rx.text).disposed(by: bag)
        output.title.drive(labelStatusTitle.rx.text).disposed(by: bag)
        output.price.drive(labelPrice.rx.text).disposed(by: bag)
        output.picture.drive(deliveryImage.rx.imageURL).disposed(by: bag)
        output.favTitle.bind(to: favoriteButton.rx.title()).disposed(by: bag)
        output.favTint.bind(to: favoriteButton.rx.tintColor).disposed(by: bag)
    }
}

//Constraint
extension DeliveryDetailViewController {
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.radius(8)
        view.backgroundColor = .white
        return view
    }
    
    func addViews() {
        self.view.addSubview(vMainStack)
        vMainStack.activateFillSafeAreaConstraint(with: self.view, margin: 12)
        
        self.vMainStack.addArrangedSubview(makeDeliveryInfoContainer())
        self.vMainStack.addArrangedSubview(makeDeliveryStatusContainer())
        self.vMainStack.addArrangedSubview(makeDeliveryPriceContainer())
        
        self.vMainStack.addArrangedSubview(UIView())
        self.vMainStack.addArrangedSubview(favoriteButton)
    }
    
    func makeDeliveryInfoContainer() -> UIView {
        let deliverContainerView = makeContainer()
        let vStack = ViewMaker.makeStackView(space: 12)
        
        deliverContainerView.addSubview(vStack)
        vStack.activateFillConstraint(with: deliverContainerView, margin: 8)
        
        let fromStack = ViewMaker.makeStackView(axios: .horizontal, distribution: .fillEqually, aligment: .fill)
        fromStack.addArrangedSubview(self.labelTitleFrom)
        fromStack.addArrangedSubview(self.labelFrom)
        
        let destinationStack = ViewMaker.makeStackView(axios: .horizontal, distribution: .fillEqually, aligment: .fill)
        destinationStack.addArrangedSubview(self.labelTitleTo)
        destinationStack.addArrangedSubview(self.labelTo)
        
        vStack.addArrangedSubview(fromStack)
        vStack.addArrangedSubview(destinationStack)
        
        return deliverContainerView
    }
    
    func makeDeliveryStatusContainer() -> UIView {
        let statusContainerView = makeContainer()
        let vStack = ViewMaker.makeStackView(aligment: .leading, space: 12)
        
        statusContainerView.addSubview(vStack)
        vStack.activateFillConstraint(with: statusContainerView, margin: 8)
        
        vStack.addArrangedSubview(labelStatusTitle)
        vStack.addArrangedSubview(deliveryImage)
        
        let deliveryImageConstraint = [
            deliveryImage.widthAnchor.constraint(equalToConstant: 100),
            deliveryImage.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(deliveryImageConstraint)
        
        return statusContainerView
    }
    
    func makeDeliveryPriceContainer() -> UIView {
        let priceContainerView = makeContainer()
        let hStack = ViewMaker.makeStackView(axios: .horizontal, distribution: .fillEqually, space: 8)
        
        priceContainerView.addSubview(hStack)
        hStack.activateFillConstraint(with: priceContainerView, margin: 8)
        
        hStack.addArrangedSubview(labelPriceTitle)
        hStack.addArrangedSubview(labelPrice)
        
        return priceContainerView
    }
    
}
