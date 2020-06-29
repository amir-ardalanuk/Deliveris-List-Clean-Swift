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
    func addToFavorite(id:String)
    func removeFromFavorite(id:String)
    func isFavorite(_ id:String)-> Observable<Bool>
    func retriveFavoritesIds()->Observable<[String]>
    func changeStorageState() -> Observable<String>
}
