//
//  NewsSaved_VM.swift
//  UI in Code
//
//  Created by Amir Ardalan on 7/5/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain
import RepositroyPlatform

class NewsSavedVM: ViewModel {
    
    let favoriteServices: FavoriteUsecase
    let news = BehaviorSubject<[NewsModel]>(value: [])
    let navigation: NewsSavedNavigation
    let bag = DisposeBag()
    
    init(favoriteUsecases: FavoriteUsecase, navigation: NewsSavedNavigation) {
        self.favoriteServices = favoriteUsecases
        self.navigation = navigation
    }
    
    func transform(input: NewsSavedVM.Input) -> NewsSavedVM.Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let trigger = Observable.combineLatest(self.favoriteServices.changeStorageState().startWith(""), input.getList.asObservable().startWith() )
        
        input.favoriteUpdated.asObservable().withLatestFrom(news) { (itemId, news) -> NewsModel? in
            news.first { ($0.link ?? "--") == itemId }
        }.filter { $0 != nil}.subscribe(onNext: { (model) in
            self.favoriteServices.toggle(model: model!).subscribe().disposed(by: self.bag)
        }).disposed(by: bag)
        
        let listOutput = trigger.flatMapLatest { (_) -> Observable<[NewsModel]> in
            return self.getFavoriteList().trackError(errorTracker).trackActivity(activityTracker)
            }.do(onNext: { (list) in
                self.news.onNext(list)
            }).asDriverOnErrorJustComplete()
        
        input.selectedItem.withLatestFrom(news.asSharedSequence(onErrorJustReturn: [])) { (index, list)  in
            return list[index.row]
        }.drive(onNext: { (elemnt) in
            self.navigation.detail(elemnt)
        }).disposed(by: bag)
        
        return Output(list: listOutput,
                      loading: activityTracker.asDriver(),
                      errorHappend: errorTracker.asDriver()
        )
    }
    
    func getFavoriteList() -> Observable<[NewsModel]> {
        return self.favoriteServices.retriveFavoritesModels()
    }
    
}

extension NewsSavedVM {
    struct Input {
        let getList: Driver<Void>
        let selectedItem: Driver<IndexPath>
        let favoriteUpdated: Driver<String>
    }
    
    struct Output {
        let list: Driver<[NewsModel]>
        let loading: Driver<Bool>
        let errorHappend: Driver<Error>
    }
}
