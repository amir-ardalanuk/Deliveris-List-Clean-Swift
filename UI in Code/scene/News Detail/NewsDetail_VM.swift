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
    
    let newsModel: NewsModel
    let favoriteServices: FavoriteUsecase
    
    let navigation: NewsDetailNavigation
    let bag = DisposeBag()
    
    init(newsModel: NewsModel, favoriteUsecases: FavoriteUsecase, navigation: NewsDetailNavigation) {
        self.newsModel = newsModel
        self.favoriteServices = favoriteUsecases
        self.navigation = navigation
    }
    
    func transform(input: NewsDetailVM.Input) -> NewsDetailVM.Output {
        let favStatus = PublishSubject<Bool>()
        input.favTrigger.flatMapLatest({ _ in
            let id = self.newsModel.link ?? ""
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
            favStatus.onNext(state)
        }).disposed(by: bag)
        
        let favTint = favStatus.asDriverOnErrorJustComplete().map {
            $0 ? UIColor.lightGray : UIColor.red }
        let url = Driver.from(optional: URL(string: self.newsModel.link?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""))
        return Output(link: url, favColor: favTint)
    }
    
}

extension NewsDetailVM {
    struct Input {
        var favTrigger: Driver<Void>
    }
    
    struct Output {
        var link: Driver<URL>
        var favColor: Driver<UIColor>
    }
    
}
