//
//  ViewController.swift
//  NutritionAnalysis
//
//  Created by Mohamed Ezzat on 6/24/21.
//

import UIKit
import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class IngredientsViewController: UIViewController {
    
    @IBOutlet weak var ingradientTV: UITextView!
    @IBOutlet weak var AnalyzeButton: UIButton!
    
    // Empty Array (Memory Management)
    private let disposeBag = DisposeBag()

    
    var ingredientvm = IngredientsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindTVtoViewmodel()
        subscribeToLoading()
        subscribetoresponse()
        subscribeToButtonIsEnabled()
        subscribeAnalyzeButtonToViewModel()
    }
    
    // binding TextView text to ingrediantBehavior in ViewModel
    func bindTVtoViewmodel(){
        ingradientTV.rx.text.orEmpty.bind(to:ingredientvm.igrediantsBehavior).disposed(by: disposeBag)
    }
    
    // function loading
    func subscribeToLoading(){
        ingredientvm.loadingBehavior.subscribe(onNext: {(isloading) in
            if isloading{
                self.showIndicator(withTitle: "", and: "")
            }else{
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    // Action After Response
    func subscribetoresponse(){
        ingredientvm.ingredients.subscribe(onNext: {
            print($0.calories, "sadwd")
                        
            if let homeVC = UIStoryboard(name: "Summary", bundle: nil).instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController {
                homeVC.ingrInput = self.ingradientTV.text
                self.present(homeVC, animated: true)
                }
        }).disposed(by: disposeBag)
        
        }
    
    // Enabling Analyze Button
    func subscribeToButtonIsEnabled(){
        ingredientvm.isAnalyzeButtonEnabled.bind(to: AnalyzeButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    // Tap of Analyze Button
    func subscribeAnalyzeButtonToViewModel(){
        AnalyzeButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else{return}
                self.ingredientvm.getData()
        }).disposed(by: disposeBag)
    }
}


