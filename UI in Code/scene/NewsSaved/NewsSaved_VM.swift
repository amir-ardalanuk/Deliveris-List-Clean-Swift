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
    
    enum NewsSection: Int {
        case varzesh3 = 0
        case FFIRAN = 1
    }
    
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
    
    func transform(input: NewsSavedVM.Input) -> NewsSavedVM.Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let trigger = Observable.combineLatest(self.favoriteServices.changeStorageState().startWith(""), input.getList.asObservable().startWith() )
        
        let listOutput = trigger.flatMapLatest { (_) -> Observable<[NewsModel]> in
            let newsSection = NewsSection(rawValue: index)
                switch newsSection {
                case .varzesh3:
                    return self.getVarzesh3News().trackError(errorTracker).trackActivity(activityTracker)
                case .FFIRAN:
                    return self.getFFIRNews().trackError(errorTracker).trackActivity(activityTracker)
                case .none:
                     return Observable.from([])
                }
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
        return self.
    }
    
    func getFFIRNews() -> Observable<[NewsModel]> {
        return Observable.zip(newsServices.getXMLFFIRequest(), self.favoriteServices.retriveFavoritesIds()) { (news, _)  in
            return news.channel?.items.map {
                NewsModel(title: $0.title, date: $0.pubDate, link: $0.link, desc: $0.description, imagePath: $0.enclosure?.url
                ) } ?? []
        }
    }
    
}

extension NewsSavedVM {
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
