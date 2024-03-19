//
//  DetailVC.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 24.02.2024.
//

import UIKit

class DetailVC: UIViewController {
    var id = 0
    var num = 0
   lazy var rightSwipeGesture = {
       let gesture = UISwipeGestureRecognizer()
       gesture.direction = .right
       gesture.addTarget(self, action: #selector(self.didRightSwipe))
       return gesture
   }

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descript: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(rightSwipeGesture())
        setupShadow(cell: image)
        
    
    }
    @objc func didRightSwipe () {
        dismiss(animated: true)
    }
    
    @IBAction func addAction(_ sender: Any) {
        while stepper.value > 0{
            basketArray.append(Storage.shared.productContainers[id][num])
            stepper.value -= 1.0
        }
        dismiss(animated: true)
    }
    @IBAction func stepperAct(_ sender: Any) {
       
        quantity.text = String(format: "%.0f", stepper.value)
        if stepper.value == 0 {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
}


