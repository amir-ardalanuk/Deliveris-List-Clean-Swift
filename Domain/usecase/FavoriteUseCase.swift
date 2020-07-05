//
//  FavoriteUseCase.swift
//  Domain
//
//  Created by Amir Ardalan on 6/28/20.
//  Copyright © 2020 Clean-Coder. All rights reserved.
//

import Foundation
import RxSwift

public protocol FavoriteUsecase {
    func addToFavorite(news: NewsModel)
    func removeFromFavorite(news: NewsModel)
    func isFavorite(_ id: String)-> Observable<Bool>
    func retriveFavoritesModels()->Observable<[NewsModel]>
    func changeStorageState() -> Observable<String>
    func toggle(model: NewsModel) -> Observable<Bool>
}
