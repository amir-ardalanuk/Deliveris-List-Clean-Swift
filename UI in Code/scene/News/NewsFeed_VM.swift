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
import RepositroyPlatform

class NewsFeedVM: ViewModel {
    
    let newsServices: NewsXMLUsecase
    let favoriteServices: FavoriteUsecase
    let news = BehaviorSubject<[NewsModel]>(value: [])
    let navigation: NewsFeedNavigation
    let bag = DisposeBag()
    
    init(newsXMLUsecase: NewsXMLUsecase, favoriteUsecases: FavoriteUsecase, navigation: NewsFeedNavigation) {
        self.newsServices = newsXMLUsecase
        self.favoriteServices = favoriteUsecases
        self.navigation = navigation
    }
    
    func transform(input: NewsFeedVM.Input) -> NewsFeedVM.Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        let deliveryList =  getFFIRNews()
        
        let trigger = Observable.combineLatest(self.favoriteServices.changeStorageState().startWith(""), input.getList.asObservable().startWith() )
       
        let listOutput = trigger.flatMapLatest { (_) -> Driver<[NewsModel]> in
            print("change")
            return  Observable.zip(deliveryList, self.favoriteServices.retriveFavoritesIds()) { (news, _)  in
                return news.channel?.items.map {
                    NewsModel(title: $0.title, date: $0.pubDate, link: $0.link, desc: $0.description, imagePath: nil
                    ) } ?? []
            }.do(onNext: { (list) in
                self.news.onNext(list)
            }).trackActivity(activityTracker)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
        }.asDriver(onErrorJustReturn: [])
        
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
    
    func getVarzesh3News() -> Observable<XMLVerzesh3Entity> {
        return newsServices.getXMLVarzesh3Request()
    }
    
    func getFFIRNews() -> Observable<XMLFFIREntity> {
          return newsServices.getXMLFFIRequest()
      }
    
}

extension NewsFeedVM {
    struct Input {
        let getList: Driver<Void>
        let selectedItem: Driver<IndexPath>
    }
    
    struct Output {
        let list: Driver<[NewsModel]>
        let loading: Driver<Bool>
        let errorHappend: Driver<Error>
    }
}
