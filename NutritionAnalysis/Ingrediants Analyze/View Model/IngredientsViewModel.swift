//
//  IngrediantsViewModel.swift
//  NutritionAnalysis
//
//  Created by Mohamed Ezzat on 6/24/21.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
import MBProgressHUD
import SwiftyJSON

class IngredientsViewModel {
    
    
    // Encapsulated Response Ingrediants Model
     var ingredientsmodel = PublishSubject<IngredientsSuccessModel>()
    
    var ingredientstotal = PublishSubject<[String: TotalDaily]>()
    
    
    // Observable Response Ingrediants Model
    var ingredients: Observable<IngredientsSuccessModel>{
        return ingredientsmodel
    }
    
    
    // Text entered into TextView
    var igrediantsBehavior = BehaviorRelay<String>(value: "")
    
    // Progress loading after any action
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    
    // Enabling Analyze Button once entre my ingrediants
    var isAnalyzeButtonEnabled: Observable<Bool>{
        return igrediantsBehavior.asObservable().map { (ingradient) -> Bool in
            let s = ingradient.isEmpty
            
            return !s
        }
    }
    
    func getData(){
        // Convert string into array
        let line = igrediantsBehavior.value.components(separatedBy: "\n")

        loadingBehavior.accept(true)
        
        let params = ["ingr" : line]
        
        let header = ["Content-Type" : "application/json",
                      "Accept": "application/json"
                      ]
        
        APIServices.instance.getData(url: urlImgredients, method: .post, params: params, encoding: JSONEncoding.default, headers: header) { [weak self] (IngrediantsModel:IngredientsSuccessModel?,baseerror: BaseErrorModel?, error) in
            
            
            // Memory leak
            guard let self = self else {return}
            
            self.loadingBehavior.accept(false)
            
            // Response from Ingrediants API
            if let error = error{
                print(error.localizedDescription, "qqq")
            }else if let baseerrormodel = baseerror{
                print(baseerrormodel.message ?? "", "www", baseerrormodel.error ?? "")
            }else{
                guard let IngrediantsModel = IngrediantsModel else{return}
                self.ingredientsmodel.onNext(IngrediantsModel)
                print("Done")
            }
        }
    }
    
}
