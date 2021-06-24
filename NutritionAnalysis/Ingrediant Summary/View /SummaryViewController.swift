//
//  SummaryViewController.swift
//  NutritionAnalysis
//
//  Created by Mohamed Ezzat on 6/24/21.
//

import UIKit
import RxSwift
import RxCocoa

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var summaryTableView: UITableView!
    @IBOutlet weak var summaryContainerView: UIView!
    @IBOutlet weak var nosummary: UILabel!
    @IBOutlet weak var ingrTextView: UITextView!
    
    let summaryTableViewCell = "SummaryTableViewCell"
    let summaryViewModel = SummaryViewModel()
    
    // Empty Array (Memory Management)
    let disposeBag = DisposeBag()
    
    var ingrInput = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTVtoViewmodel()
        subscribeToSummarySelection()
        setupTableView()
        bindToHiddenTable()
        subscribeToLoading()
        subscribeToResponse()
        getSummary()
    }
    
    func bindTVtoViewmodel(){
        self.ingrTextView.text = ingrInput
        self.ingrTextView.rx.text.orEmpty.bind(to:summaryViewModel.inputIngr).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        summaryTableView.register(UINib(nibName: summaryTableViewCell, bundle: nil), forCellReuseIdentifier: summaryTableViewCell)
    }
    
    
    func bindToHiddenTable() {
        summaryViewModel.isTableHiddenObservable.bind(to: self.summaryContainerView.rx.isHidden).disposed(by: disposeBag)
    }
    
    
    func subscribeToLoading() {
        summaryViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    func subscribeToResponse() {
        self.summaryViewModel.summaryModelObservable
            .bind(to: self.summaryTableView
                .rx
                .items(cellIdentifier: summaryTableViewCell,
                       cellType: SummaryTableViewCell.self)) { row, summary, cell in
                        print(row, "dsfdsf")
                cell.calLbl.text = "Calories: " + summary.label
                cell.foodnameLbl.text = "Food: " + self.ingrInput
                cell.qtyLbk.text = "Quantity: " + "\(summary.quantity)"
                cell.weightLbl.text = "Total Weight: " + "\(summary.quantity)"
                cell.unitLbl.text = "Unit: " + "\(summary.unit)"
                
        }
        .disposed(by: disposeBag)
    }
    
    func subscribeToSummarySelection() {
        Observable
            .zip(summaryTableView.rx.itemSelected, summaryTableView.rx.modelSelected(TotalDaily.self))
            .bind { [weak self] selectedIndex, summary in
                
                print(selectedIndex, summary.label ?? "")
        }
        .disposed(by: disposeBag)
    }
    func getSummary() {
        summaryViewModel.getData()
    }
}

