//
//  DeliveryDetailViewModel.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/28/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import Domain
import RxCocoa
import RxSwift

class DeliveryDetailViewModel: ViewModel {
    
    let bag = DisposeBag()
    let navigation: DeliveryDetailNavigation
    let deliveryItem: DeliveryEntity
    let favoriteServices: FavoriteUsecase
    let favStatus = BehaviorSubject<Bool>(value: false)
   
    init(navigation: DeliveryDetailNavigation, favoriteServices: FavoriteUsecase, deliveryItem: DeliveryEntity) {
        self.navigation = navigation
        self.deliveryItem = deliveryItem
        self.favoriteServices = favoriteServices
    }
    
    func transform(input: DeliveryDetailViewModel.Input) -> DeliveryDetailViewModel.Output {
        
       input.changeFavoriteStatus.flatMapLatest({ _ in
           let id = self.deliveryItem.id ?? ""
            return self.favoriteServices.isFavorite(id).map { (isFav) -> Bool in
                if isFav {
                    self.favoriteServices.removeFromFavorite(id: id)
                    return false
                } else {
                    self.favoriteServices.addToFavorite(id: id)
                    return true
                }
            }.asDriverOnErrorJustComplete()
        }).drive(onNext: { (state) in
            self.favStatus.onNext(state)
        }).disposed(by: bag)
        
        favoriteServices.isFavorite(deliveryItem.id ?? "").share().subscribe(onNext: { (state) in
            self.favStatus.onNext(state)
        }).disposed(by: bag)
        
        let favTitle = favStatus.asObservable().map {
                       $0 ? "remove from Favorite" : "add to Favorite" }
        
        let favTint = favStatus.asObservable().map {
            $0 ? UIColor.lightGray : UIColor.red }
    
        let fromDeliver = Driver.from(optional: deliveryItem.route?.start)
        let toDriver = Driver.from(optional: deliveryItem.route?.end)
        let priceDriver = Driver.from(optional: deliveryItem.deliveryFee)
        let pictureDriver = Driver.from(optional: URL(string: deliveryItem.goodsPicture ?? ""))
        let title = Driver.from(optional: "Goods to Deliver")
        
        return Output(from: fromDeliver,
                      to: toDriver,
                      title: title,
                      picture: pictureDriver,
                      price: priceDriver,
                      favTitle: favTitle, fav: favStatus.asObservable(), favTint: favTint)
    }
    
}

extension DeliveryDetailViewModel {
    struct Input {
        let changeFavoriteStatus: Driver<Void>
    }
    
    struct Output {
        let from: Driver<String>
        let to: Driver<String>
        let title: Driver<String>
        let picture: Driver<URL>
        let price: Driver<String>
        let favTitle: Observable<String>
        let fav: Observable<Bool>
        let favTint: Observable<UIColor>
    }
}
