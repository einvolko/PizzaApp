//
//  RootCollectionViewCell.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 06.03.2024.
//

import UIKit

class RootCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
   
    weak var viewController : UIViewController?
    var identifier : Int = 0
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Storage.shared.productContainers[identifier].count
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = rootCollectionView.dequeueReusableCell(withReuseIdentifier: "MainMenuCell", for: indexPath) as! MainMenuCell
        cell.name.text =  Storage.shared.productContainers[identifier][indexPath.item].name
        cell.cost.text = Storage.shared.productContainers[identifier][indexPath.item].cost.description
        cell.image.image = UIImage(named: Storage.shared.productContainers[identifier][indexPath.item].name)
        cell.descriptField.text = Storage.shared.productContainers[identifier][indexPath.item].descript
        cell.button.tag = indexPath.item
        cell.id = identifier
        setupShadow(cell: cell)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailVC") as! DetailVC
        viewController?.present(vc, animated: true) { [weak self] in
            guard let self = self else { return }
           
            vc.image.image = UIImage(named: Storage.shared.productContainers[identifier][indexPath.item].name)
            vc.name.text = Storage.shared.productContainers[identifier][indexPath.item].name
            vc.descript.text = Storage.shared.productContainers[identifier][indexPath.item].descript
            vc.cost.text = Storage.shared.productContainers[identifier][indexPath.item].cost.description
            vc.id = identifier
            vc.num = indexPath.item
        }
    }
   
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rootCollectionView.frame.width, height: rootCollectionView.frame.height / 3.1)
    }

    @IBOutlet weak var rootCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        rootCollectionView.backgroundView = nil
        rootCollectionView.backgroundColor = UIColor .clear
        rootCollectionView.dataSource = self
        rootCollectionView.delegate = self
        rootCollectionView.register(UINib(nibName: "MainMenuCell", bundle: nil), forCellWithReuseIdentifier: "MainMenuCell")
       
    }

}
