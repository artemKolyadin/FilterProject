//
//  FilterPresenter.swift
//  FilterProject
//
//  Created by Artem Kolyadin on 21.08.2018.
//  Copyright © 2018 AK. All rights reserved.
//

import Foundation

protocol FilterPresenterProtocol {
    var view: FilterViewProtocol? {get set}
    var interactor : FilterInteractorProtocol? {get set}
    var router : FilterRouterProtocol? {get set}
    
    func onViewDidLoad ()
    func onFiltersFetched ()
}

class FilterPresenter: FilterPresenterProtocol {
    var router: FilterRouterProtocol?
    weak var view: FilterViewProtocol?
    var interactor: FilterInteractorProtocol?
    
    func onViewDidLoad() {
    }
    
    func onFiltersFetched() {
    }
    
    
}
