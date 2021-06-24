//
//  SummaryTableViewCell.swift
//  NutritionAnalysis
//
//  Created by Mohamed Ezzat on 6/24/21.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var foodnameLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    @IBOutlet weak var qtyLbk: UILabel!
    @IBOutlet weak var calLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
