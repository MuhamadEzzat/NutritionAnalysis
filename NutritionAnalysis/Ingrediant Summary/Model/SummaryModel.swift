//
//  SummaryModel.swift
//  NutritionAnalysis
//
//  Created by Mohamed Ezzat on 6/24/21.
//

import Foundation


// MARK: - SummaryModel
struct SummaryModel: Codable {
    let uri: String
    let calories: Int
    let totalWeight: Double
    let dietLabels, healthLabels: [String]
    let totalNutrients, totalDaily: [String: TotalDaily]
//    let totalNutrientsKCal: TotalNutrientsKCal
}
