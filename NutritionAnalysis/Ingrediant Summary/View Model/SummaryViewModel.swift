//
//  SummaryViewModel.swift
//  NutritionAnalysis
//
//  Created by Mohamed Ezzat on 6/24/21.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class SummaryViewModel{
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
        
        private var isTableHidden = BehaviorRelay<Bool>(value: false)
        private var summaryModelSubject = PublishSubject<[TotalDaily]>()
        
        var summaryModelObservable: Observable<[TotalDaily]> {
            return summaryModelSubject
        }
        var isTableHiddenObservable: Observable<Bool> {
            return isTableHidden.asObservable()
        }
    
    var inputIngr = BehaviorRelay<String>(value: "")
        
        func getData() {
            
            print(inputIngr.value, "dasF")
            let urlString = "https://api.edamam.com/api/nutrition-data?app_id=06aeaec5&app_key=bf083632c3ac5ba2d3f7bd79540f4c91&nutrition-type=cooking&ingr=\(inputIngr.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(urlString)
            loadingBehavior.accept(true)
            APIServices.instance.getData(url:urlString ?? "", method: .get, params: nil, encoding: JSONEncoding.default, headers: nil) { [weak self] (summaryModel: SummaryModel?, errorModel: BaseErrorModel?, error)  in 
                print(summaryModel, "erweTW")
                guard let self = self else { return }
                self.loadingBehavior.accept(false)
                if let error = error {
                    print(error.localizedDescription)
                } else if let errorModel = errorModel {
                    print(errorModel.message ?? "")
                } else {
                    guard let summaryModel = summaryModel else { return }
                    print(summaryModel.calories, "ewedw")
                    
                    if summaryModel.dietLabels.count ?? 0 < 0 {
//                        self.summaryModelSubject.onNext(summaryModel.totalDaily)
                        self.isTableHidden.accept(false)
                    } else {
                        self.isTableHidden.accept(true)
                    }
                }
            }
        }
}
