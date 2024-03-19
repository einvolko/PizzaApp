//
//  BasketVC.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 11.03.2024.
//

import UIKit

class BasketVC: UIViewController {

    @IBOutlet weak var sentOrderButton: UIButton!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var switchDelivery: UISwitch!
    @IBOutlet weak var basketCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        basketCV.register(UINib(nibName: "BasketCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BasketCollectionViewCell")
        basketCV.register(UINib(nibName: "DefaultCVC", bundle: nil), forCellWithReuseIdentifier: "DefaultCVC")
        totalCostCalculate()
        isActiveButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        basketCV.reloadData()
        totalCostCalculate()
        isActiveButton()
    }
    func isActiveButton (){
        if basketArray.isEmpty {
            sentOrderButton.isEnabled = false
        } else {
            sentOrderButton.isEnabled = true
        }
    }
    @IBAction func sentOrderButton(_ sender: Any) {
        let alert = UIAlertController(title: "Add contact info", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter your name"
            textField.text = UserDefaults.standard.string(forKey: textField.placeholder!)
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter your city"
            textField.text = UserDefaults.standard.string(forKey: textField.placeholder!)
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter your street, house, apartment"
            textField.text = UserDefaults.standard.string(forKey: textField.placeholder!)
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter your mobile number"
            textField.text = UserDefaults.standard.string(forKey: textField.placeholder!)
            textField.keyboardType = .numberPad
        }
        let action1 = UIAlertAction(title: "Cancel", style: .destructive) { action in
            for i in alert.textFields! {
                UserDefaults.standard.setValue(i.text, forKey: i.placeholder!)
            }
        }
        let action2 = UIAlertAction(title: "Sent", style: .default) { action in
            for i in alert.textFields! {
                UserDefaults.standard.setValue(i.text, forKey: i.placeholder!)
                print(UserDefaults.standard.string(forKey: i.placeholder!))
            }
           // TODO : sent data to server
            print(basketArray)
            print(self.totalCost.text)
            print("Is delivery needed \(self.switchDelivery.isOn)")
            
                    
                    
                    
            let alert = UIAlertController(title: "Your order successfully sent!!!", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        
        present(alert, animated: true)
    }
    
    @IBAction func switchDeliveryAction(_ sender: Any) {
    }
    func totalCostCalculate (){
        var totalCostInt: Int = 0
        for i in basketArray {
            totalCostInt += i.cost
        }
        totalCost.text = "Tolal cost \(totalCostInt)"
    }
}
extension BasketVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  basketArray.count == 0 {
            1
        } else {
            basketArray.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if basketArray.count == 0 {
            let cell = basketCV.dequeueReusableCell(withReuseIdentifier: "DefaultCVC", for: indexPath) as! DefaultCVC
            return cell
            
        } else {
            let cell = basketCV.dequeueReusableCell(withReuseIdentifier: "BasketCollectionViewCell", for: indexPath) as! BasketCollectionViewCell
            cell.imageView.image = UIImage(named: basketArray[indexPath.item].name)
            cell.cost.text = basketArray[indexPath.item].cost.description
            cell.name.text = basketArray[indexPath.item].name
            cell.deleteButton.tag = indexPath.item
            cell.vc = self
            setupShadow(cell: cell)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if basketArray.count == 0 {
            return CGSize(width: basketCV.frame.width, height: basketCV.frame.height)
        } else {
            return CGSize(width: basketCV.frame.width, height: basketCV.frame.height / 5)
        }
    }
}
