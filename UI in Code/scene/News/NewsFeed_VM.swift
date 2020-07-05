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
    
    func transform(input: NewsFeedVM.Input) -> NewsFeedVM.Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()
        
        let trigger = Observable.combineLatest(self.favoriteServices.changeStorageState().startWith(""), input.getList.asObservable().startWith(),
                                               input.selectedSection.asObservable().startWith(0) )
        
        input.favoriteUpdated.asObservable().withLatestFrom(news) { (itemId, news) -> NewsModel? in
            news.first { ($0.link ?? "--") == itemId }
        }.filter { $0 != nil}.subscribe(onNext: { ( model) in
            self.favoriteServices.toggle(model: model!.toggleFavoriteState()).subscribe().disposed(by: self.bag)
        }).disposed(by: bag)
        
        let listOutput = trigger.flatMapLatest { ( _, _, index) -> Observable<[NewsModel]> in
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
    
    func getVarzesh3News() -> Observable<[NewsModel]> {
        let favoriteIdList = self.favoriteServices.retriveFavoritesModels().map { $0.map { $0.link ?? "-1"} }
        return  Observable.zip( newsServices.getXMLVarzesh3Request(), favoriteIdList) { (news, fav)  in
            return news.channel?.items.map {
                NewsModel(title: $0.title,
                          date: $0.pubDate,
                          link: $0.link,
                          desc: $0.description,
                          imagePath: nil,
                          isFavorite: fav.contains($0.link ?? "") )
                } ?? []
        }
    }
    
    func getFFIRNews() -> Observable<[NewsModel]> {
        let favoriteIdList = self.favoriteServices.retriveFavoritesModels().map { $0.map { $0.link ?? "-1"} }
        return Observable.zip(newsServices.getXMLFFIRequest(), favoriteIdList) { (news, fav)  in
            return news.channel?.items.map {
                NewsModel(title: $0.title,
                          date: $0.pubDate,
                          link: $0.link,
                          desc: $0.description,
                          imagePath: $0.enclosure?.url,
                          isFavorite: fav.contains($0.link ?? "") ) }  ?? []
        }
    }
    
}

extension NewsFeedVM {
    struct Input {
        let getList: Driver<Void>
        let selectedItem: Driver<IndexPath>
        let selectedSection: Driver<Int>
        let favoriteUpdated: Driver<String>
    }
    
    struct Output {
        let list: Driver<[NewsModel]>
        let loading: Driver<Bool>
        let errorHappend: Driver<Error>
    }
}
