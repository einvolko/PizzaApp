//
//  Functions.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 24.02.2024.
//

import Foundation
import UIKit
func setupShadow(cell: UIView){
    cell.layer.cornerRadius = cornerRadius
    cell.layer.borderWidth = 1.0
    cell.layer.borderColor = UIColor.lightGray.cgColor
    cell.layer.shadowColor = UIColor.gray.cgColor
    cell.layer.shadowOffset = CGSizeMake(0, 1)
    cell.layer.shadowRadius = 5
    cell.layer.shadowOpacity = 0.5
}




