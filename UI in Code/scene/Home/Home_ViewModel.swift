//
//  HomeViewModel.swift
//  UI in Code
//
//  Created by Amir Ardalan on 6/27/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain

class HomeViewModel : ViewModel {
    
    let deliveryServices : DeliveryUsecases;
    let favoriteServices: FavoriteUsecase;
    
    let navigation : HomeNavigation
    let bag = DisposeBag()
    
    init(deliveryServices: DeliveryUsecases,favoriteUsecases: FavoriteUsecase,navigation: HomeNavigation) {
        self.deliveryServices = deliveryServices
        self.favoriteServices = favoriteUsecases
        self.navigation = navigation
    }
    
    func transform(input: HomeViewModel.Input) -> HomeViewModel.Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        let deliveryList =  getDeliveryList()
        
        input.selectedItem.withLatestFrom(deliveryList.asSharedSequence(onErrorJustReturn: [])) { (index, list)  in
            return list[index.row]
        }.drive(onNext: { (elemnt) in
            self.navigation.detail(elemnt)
        }).disposed(by: bag)
        
        input.getList.asObservable().subscribe(onNext: { (_) in
            print("next")
        }, onError: { (err) in
            print(err)
        }, onCompleted: {
            print("com")
        }) {
            print("dis")
        }
        
        let trigger = Observable.combineLatest(self.favoriteServices.changeStorageState().startWith(""), input.getList.asObservable().startWith() )
       
        let listOutput = trigger.flatMapLatest { (_) -> Driver<[DeliveryModel]> in
            print("change")
            return  Observable.zip(deliveryList, self.favoriteServices.retriveFavoritesIds()) { (deliveries, favorites)  in
                           return deliveries.map{
                               DeliveryModel(imageUrl: $0.goodsPicture,
                                             from: $0.route?.start,
                                             to: $0.route?.end,
                                             price: $0.deliveryFee,
                                             fav: favorites.contains( $0.id ?? "--"),
                                             id: $0.id ?? "--") }
                           
            }.trackActivity(activityTracker)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }.asDriver(onErrorJustReturn: [])
       
        return Output(list: listOutput,
                      loading: activityTracker.asDriver(),
                      errorHappend: errorTracker.asDriver()
        )
    }
    
    
    
    func getDeliveryList() -> Observable<[DeliveryEntity]> {
        return deliveryServices.getDeliveryList()
    }
    
    
    
}

extension HomeViewModel{
    struct Input {
        let getList : Driver<Void>
        let selectedItem:Driver<IndexPath>
    }
    
    struct Output {
        let list: Driver<[DeliveryModel]>
        let loading:Driver<Bool>
        let errorHappend:Driver<Error>
    }
    
}
