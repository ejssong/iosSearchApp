//
//  ResultViewModel.swift
//  iosSearchApp
//
//  Created by Eunjin Song on 2024/03/03.
//

import Foundation

struct ResultViewModelActions{
    
}

protocol ResultViewModelInput{
    
}

protocol ResultViewModelOutput {
    
}

protocol ResultViewModel: ResultViewModelInput, ResultViewModelOutput { }

final class DefaultResultViewModel: ResultViewModel {
    
//    private let usecase: ResultUseCase
//    private let actions: ResultViewModelActions
//    
//    
//    init(usecase: ResultUseCase, actions: ResultViewModelActions) {
//        self.usecase = usecase
//        self.actions = actions
//    }
}
