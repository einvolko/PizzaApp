//
//  BasketCollectionViewCell.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 19.03.2024.
//

import UIKit

class BasketCollectionViewCell: UICollectionViewCell {
    weak var vc : BasketVC?

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = cornerRadius
    }

    @IBAction func deleteButtonAct(_ sender: Any) {
        basketArray.remove(at: deleteButton.tag)
        vc?.totalCostCalculate()
        vc?.isActiveButton()
        UIView.animate(withDuration: 0.2) {
            self.vc?.basketCV.reloadData()
        }
       
    }
}
