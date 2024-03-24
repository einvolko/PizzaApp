//
//  ViewController.swift
//  MyPizzaApp
//
//  Created by Михаил Супрун on 24.02.2024.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabaseInternal



class ViewController: UIViewController {
    var ref: DatabaseReference!
   
   
   
    var x:IndexPath?
    var y:IndexPath?
    var bool = false
    var duration = 0.3
    @IBOutlet weak var mainCollection: UICollectionView!
    @IBOutlet weak var menuCollection: UICollectionView!
    
    let db = Firestore.firestore()
    
    
    var selected : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBasket()
        fetchData()
        
  
//        let jsonData = try! JSONEncoder().encode(storage)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//        print(jsonString)
        
 
        mainCollection.register(UINib(nibName: "RootCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RootCollectionViewCell")
        menuCollection.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        mainCollection.layer.cornerRadius = 15
        mainCollection.backgroundView = nil
        mainCollection.backgroundColor = UIColor .clear
        menuCollection.backgroundView = nil
        menuCollection.backgroundColor = UIColor .clear

//        let refreshControl = UIRefreshControl(frame: .zero)
//        let refreshAction = UIAction { [weak self]  _ in
//            self?.fetchData()
//        }
//        refreshControl.addAction(refreshAction, for: .valueChanged)
//        mainCollection.refreshControl = refreshControl
//        
    }

    
   
    
    
    
    
    
    func fetchData() {
        db.collection("Pizza").getDocuments { snapshot, error in
            for i in snapshot!.documents {
                print("\(i.documentID) => \(i.data())")
            }
        }
    
        Storage.shared.newFetcher() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
//                self.mainCollection.refreshControl?.endRefreshing()
                
                switch result {
                case .success(_):
                    self.mainCollection.reloadData()
                    self.menuCollection.reloadData()
                case .failure(let error):
                    let alert = UIAlertController(title: "Error",
                                                  message: error.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    @objc func filterProducts(){
        bool ? Storage.shared.productContainers[selected].sort{$0.cost < $1.cost} : Storage.shared.productContainers[selected].sort{$0.cost > $1.cost}
        bool.toggle()
        UIView.animate(withDuration: duration) {
            self.mainCollection.reloadData()
            self.view.layoutIfNeeded()
        }
    }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  collectionView == mainCollection ? Storage.shared.productContainers.count : Storage.shared.productTypesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mainCollection {
            let cell = mainCollection.dequeueReusableCell(withReuseIdentifier: "RootCollectionViewCell", for: indexPath) as! RootCollectionViewCell
            cell.identifier = indexPath.item
            cell.viewController = self
            cell.rootCollectionView.reloadData()
            return cell
            
        }
        
        if collectionView == self.menuCollection {
            let cell = menuCollection.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.category.text = String(describing: Storage.shared.productTypesArray[indexPath.item]).uppercased()
            cell.button.addTarget(self, action: #selector(filterProducts), for: .touchUpInside)
            cell.backgroundColor = selected == indexPath.item ? .tertiaryLabel : .lightText
            setupShadow(cell: cell)
            
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mainCollection{
            
//            print("end dispay \(indexPath)")
            x = indexPath
            if x != y {
                menuCollection.scrollToItem(at: y!, at: .centeredHorizontally, animated: true)
                self.selected = y!.item
                menuCollection.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mainCollection{
//            print("will dispay \(indexPath)")
            y = indexPath
        }
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == menuCollection {
    
            self.selected = indexPath.item
            menuCollection.reloadItems(at: [indexPath])
            mainCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView == mainCollection ? CGSize(width: mainCollection.frame.width, height: mainCollection.frame.height) : CGSize(width: view.frame.width, height: menuCollection.frame.height - 20)
    }
}
