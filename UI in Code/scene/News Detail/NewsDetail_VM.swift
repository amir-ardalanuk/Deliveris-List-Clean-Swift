//
//  NewsDetail_VM.swift
//  UI in Code
//
//  Created by Amir Ardalan on 7/1/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Domain
import RepositroyPlatform

class NewsDetailVM: ViewModel {
    
    var newsModel: NewsModel
    let favoriteServices: FavoriteUsecase
    
    let navigation: NewsDetailNavigation
    let bag = DisposeBag()
    
    init(newsModel: NewsModel, favoriteUsecases: FavoriteUsecase, navigation: NewsDetailNavigation) {
        self.newsModel = newsModel
        self.favoriteServices = favoriteUsecases
        self.navigation = navigation
    }
    
    func transform(input: NewsDetailVM.Input) -> NewsDetailVM.Output {
        let id = self.newsModel.link ?? ""
        let favStatus =  BehaviorSubject<Bool>(value: false)
        var favImage: Observable<UIImage> {
            return favStatus.asObservable().map { $0 ? #imageLiteral(resourceName: "icons8-love-96") : #imageLiteral(resourceName: "icons8-love-32") }
        }
        input.favTrigger.flatMapLatest({ _ in
            return self.favoriteServices.isFavorite(id).map { (isFav) -> Bool in
                if isFav {
                    self.newsModel.toggleFavoriteState()
                    self.favoriteServices.removeFromFavorite(news: self.newsModel)
                    return false
                } else {
                    self.newsModel.toggleFavoriteState()
                    self.favoriteServices.addToFavorite(news: self.newsModel)
                    return true
                }
            }.asDriverOnErrorJustComplete()
        }).drive(onNext: { (state) in
            favStatus.onNext(state)
        }).disposed(by: bag)
        
        self.favoriteServices.isFavorite(id).subscribe(onNext: { (addedBefore) in
            favStatus.onNext(addedBefore)
        }).disposed(by: bag)
        
        let url = Driver.from(optional: URL(string: self.newsModel.link?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""))
        return Output(link: url, favImage: favImage)
    }
    
}

extension NewsDetailVM {
    struct Input {
        var favTrigger: Driver<Void>
    }
    
    struct Output {
        var link: Driver<URL>
        var favImage: Observable<UIImage>
    }
    
}
