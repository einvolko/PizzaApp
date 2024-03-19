//
//  BasketCollectionViewCell.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 19.03.2024.
//

import UIKit

protocol BasketCollectionViewCellDelegate: AnyObject {
    func didTapDelete(cell: UICollectionViewCell)
}

class BasketCollectionViewCell: UICollectionViewCell {
    weak var delegate: BasketCollectionViewCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var cost: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = cornerRadius
    }

    @IBAction func deleteButtonAct(_ sender: Any) {
        delegate?.didTapDelete(cell: self)
    }
}
