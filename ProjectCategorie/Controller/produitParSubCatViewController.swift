//
//  produitParSubCatViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
import DJSemiModalViewController
struct Expandable {
    
   // var names : String?
   //var favorite: Favorite?
     var products: ProductClass?
    var idFavoris : Int?
    var hasFavorited: Bool?
}
class produitParSubCatViewController: UIViewController {
    
   
    @IBOutlet var segmentController: DGKSegmentControl!
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    @IBOutlet var collectionView: UICollectionView!
    var urlRequestSearchRating = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/Product/Rating/")!)
    var ProductList = [ProductClass]()
    var attachementListId = [Int]()
    var attachementPathFile = [String]()
    var responseImages = [UIImage]()
    var ratingNotes = [String]()
    var btn1 : UIButton?
    var btn2 : UIButton?
    var btn3 : UIButton?
    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequestAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var urlRequest = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Search/SubCategory/Product/")!)
    
    var twoDimensionalArray = [Expandable]()
    var favoiriteList = [Favorite]()
    
    var urlRequestfavorite = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Favorites")!)
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentController.titles = ["Filtres", "Popularité"]

   
        activityIndicator.startAnimating()

        
    }
    
    
    
    @IBAction func segmentControlButton(_ sender: DGKSegmentControl) {
        print("ss")
    print("ssss\(sender.selectedTitle)")
        print("ssss\( sender.titles[sender.selectedIndex])")
        if sender.titles[sender.selectedIndex] == "Popularité" {
            self.tabBarController?.tabBar.isHidden = true

            let controller = createSemiModalViewController()
            
            controller.presentOn(presentingViewController: self, animated: true, onDismiss: {
                debugPrint("`DJSemiModalViewController` dismissed")
                self.tabBarController?.tabBar.isHidden = false

                
            })
            
            debugPrint("`DJSemiModalViewController` presented")
        }
    }
    @IBAction private func ETATAction(_ sender: UIButton) {
print("aaaa")
//        self.btn2?.isSelected = false
//        self.btn3?.isSelected = false
//
//        sender.isSelected = !sender.isSelected
    
        sender.backgroundColor = .mainRoze
        self.btn2?.backgroundColor = .white
        self.btn3?.backgroundColor = .white
        self.ratingNotes.sort() { $0 > $1}

        self.collectionView.reloadData()

        
    }
    @IBAction private func eleveAction(_ sender: UIButton) {
//        self.btn1?.isSelected = false
//        self.btn3?.isSelected = false
//
//        sender.isSelected = !sender.isSelected
        
        sender.backgroundColor = .mainRoze
        self.btn1?.backgroundColor = .white
        self.btn2?.backgroundColor = .white
        print("aaaa")
  self.ProductList.sort() { $0.price! > $1.price! }
        self.collectionView.reloadData()
    
        
    }
    @IBAction private func basAction(_ sender: UIButton) {

        
        sender.backgroundColor = .mainRoze
        self.btn3?.backgroundColor = .white
        self.btn1?.backgroundColor = .white
        self.ProductList.sort() { $0.price! < $1.price! }
        self.collectionView.reloadData()
        print("aaaa")

        
    }
    private func createSemiModalViewController() -> DJSemiModalViewController {
        
        let controller = DJSemiModalViewController()
        controller.maxWidth = 420
        controller.minHeight = 200
        controller.title = "Trier Par"
        controller.titleLabel.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)

        controller.closeButton.setTitle("Done", for: .normal)
        
    
        let button = UIButton()
        button.setTitle("Rating", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(ETATAction), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        self.btn1 = button
        controller.addArrangedSubview(view: button)
        
        let button2 = UIButton()
        button2.setTitle("Lowest price", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button2.addTarget(self, action: #selector(basAction), for: .touchUpInside)
        activityIndicator.startAnimating()

        button2.layer.cornerRadius = 8
        button2.backgroundColor = UIColor.white
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.btn2 = button2
        controller.addArrangedSubview(view: button2)
        
        let button3 = UIButton()
        button3.setTitle("Highest price", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button3.addTarget(self, action: #selector(eleveAction), for: .touchUpInside)
        button3.layer.cornerRadius = 8
        button3.backgroundColor = UIColor.white
        button3.translatesAutoresizingMaskIntoConstraints = false
        self.btn3 = button3
        controller.addArrangedSubview(view: button3)
        
        return controller
    }
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          expendlistproduit()
        navigationController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        activityIndicator.startAnimating()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
  
    func someMethodIWantToCall(cell: produitParSubViewCell) {
        
        guard let indexPathTapped = collectionView.indexPath(for: cell) else { return }
        if twoDimensionalArray.count > 0 {
            let hasFavorited = twoDimensionalArray[indexPathTapped.row].hasFavorited
            twoDimensionalArray[indexPathTapped.row].hasFavorited = !hasFavorited!
// let color  = isSelected ? selectedColor : normalColor
            cell.favoriteButton.isSelected = hasFavorited! ?  false : true
            if (hasFavorited == false) {
                 cell.viewProduit.alpha = 0.5 // 50% opacity
                let userDictionnary = UserDefaults.standard.dictionary(forKey: "userDictionnary")
                let id = userDictionnary?["id"] as? String
                self.postFavorite(Id: ProductList[indexPathTapped.row].id!, userId: id!)
            }
            if (hasFavorited == true) {
                 cell.viewProduit.alpha = 1 // 50% opacity
                self.deleteFavorite(Id: twoDimensionalArray[indexPathTapped.row].idFavoris ?? 0)
            }
        }

        
    }
    
    
    
    func postFavorite (Id : Int , userId : String) {
        let params = ["productId": Id ,  "userId": userId] as [String : Any]
        
        let urlString = "https://clocation.azurewebsites.net/api/Favorites"
        
        AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                  print("ajout")
                let favorite : String = "you add in your favorites"
                self.ProductList.removeAll()
                self.expendlistproduit2()
             self.alertdisaper(userMessage: favorite)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func deleteFavorite (Id : Int) {
       
        
        let urlString = "https://clocation.azurewebsites.net/api/Favorites/\(Id)"
        
        AF.request(urlString, method: .delete,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                print(response)
                print("delete")
                let favorite : String = "you have deleted in your favorites"
                self.alertdisaper(userMessage: favorite)
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }

    
    func searchRating (productId : Int) {
        
        let urlStringSearchRating = urlRequestSearchRating.url?.absoluteString
        let SearchRatingURL = urlStringSearchRating! + "\(productId)"
        
        AF.request(SearchRatingURL , method : .get).responseJSON {
            response in
            
            guard let data = response.data else {return}
            print("response\(response)")
            var notevalue = String(data: data, encoding: .utf8)!
            print("notevalue\(notevalue)")
            if notevalue == "\"NaN\"" {
                
                notevalue = "0"
            }
            self.ratingNotes.append(notevalue)
            self.searchImage(productId : productId)
//            self.collectionView.reloadData()
            
        }
    }
    func searchRatingTrie (productId : Int) {
        
        let urlStringSearchRating = urlRequestSearchRating.url?.absoluteString
        let SearchRatingURL = urlStringSearchRating! + "\(productId)"
        
        AF.request(SearchRatingURL , method : .get).responseJSON {
            response in
            
            guard let data = response.data else {return}
            print("response\(response)")
            var notevalue = String(data: data, encoding: .utf8)!
            print("notevalue\(notevalue)")
            if notevalue == "\"NaN\"" {
                
                notevalue = "0"
            }
            self.ratingNotes.append(notevalue)
            
           // self.ratingNotes.sort() { $0.ratingNotes! < $1.ratingNotes! }

            self.searchImage(productId : productId)
            //            self.collectionView.reloadData()
            
        }
    }
    func searchImage(productId : Int) {
        
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let attachementURL = urlStringImageByAttachmentId! + "\(productId)/ImageByProductId"
        
        AF.request(attachementURL , method : .get ).responseImage {
            response in
            guard let image = response.data else {return}
            print(image)
            self.responseImages.append( UIImage(data: image) ?? UIImage(named: "EmmaStone")!)
            self.collectionView.reloadData()
        }
    }

    func expendlistproduit() {
        let urlString = urlRequest.url?.absoluteString
        guard let subCategorieID = Share.sharedName.sousCategorie?.id else {return}
        let productURL = urlString! + "\(subCategorieID)"
        print("subCategorieID : \(subCategorieID)")

        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                guard let data = response.data else {return}

                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
//                self.ProductList.removeAll()

                for item  in itemDetails {
                    self.ProductList.append(item)
                    self.twoDimensionalArray.append(Expandable(products: item, idFavoris: nil, hasFavorited: false))

                    guard let productId = item.id else {return}
                    self.searchRating (productId : productId)

                let urlString = self.urlRequestfavorite.url?.absoluteString
                    AF.request(urlString! , method : .get).responseJSON {
                        response in
                        do {
                            guard let data = response.data else {return }
                                let itemDetails1 = try JSONDecoder().decode([Favorite].self, from: data)
                                for  item1 in itemDetails1{
                                    
                                    if (item.id == item1.productId && item.name == item1.productName)
                                    {
                                        var index : Int?
                                        for i in (0...self.ProductList.count - 1) {
                                            if self.ProductList[i].id == item1.productId {
                                                index = i
                                            }
                                        }
                                        self.twoDimensionalArray[index ?? 0 ] = Expandable(products: item, idFavoris: item1.id, hasFavorited: true)

                                    }
                                    self.favoiriteList.append(item1)



                                }
                              self.collectionView.reloadData()
                        }catch let errords {

                            print(errords)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                self.collectionView.reloadData()
            }catch let errors {
                print(errors)
            }
            
        }
        
        
    }
    func expendlistproduit2() {
        let urlString = urlRequest.url?.absoluteString
        guard let subCategorieID = Share.sharedName.sousCategorie?.id else {return}
        let productURL = urlString! + "\(subCategorieID)"
        print("subCategorieID : \(subCategorieID)")
        
        AF.request(productURL , method : .get).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                
                let itemDetails = try JSONDecoder().decode([ProductClass].self, from: data)
                //                self.ProductList.removeAll()
                
                for item  in itemDetails {
                    self.ProductList.append(item)
                    self.twoDimensionalArray.append(Expandable(products: item, idFavoris: nil, hasFavorited: false))
                    
                    guard let productId = item.id else {return}
//                    self.searchRating (productId : productId)
                    
                    let urlString = self.urlRequestfavorite.url?.absoluteString
                    AF.request(urlString! , method : .get).responseJSON {
                        response in
                        do {
                            guard let data = response.data else {return }
                            let itemDetails1 = try JSONDecoder().decode([Favorite].self, from: data)
                            for  item1 in itemDetails1{
                                
                                if (item.id == item1.productId && item.name == item1.productName)
                                {
                                    var index : Int?
                                    for i in (0...self.ProductList.count - 1) {
                                        if self.ProductList[i].id == item1.productId {
                                            index = i
                                        }
                                    }
                                    self.twoDimensionalArray[index ?? 0 ] = Expandable(products: item, idFavoris: item1.id, hasFavorited: true)
                                    
                                }
                                self.favoiriteList.append(item1)
                                self.collectionView.reloadData()
                                
                                
                                
                            }
                        }catch let errords {
                            
                            print(errords)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
                
            }catch let errors {
                print(errors)
            }
            
        }
        
        
    }
}
extension produitParSubCatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseImages.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "list", for: indexPath) as! produitParSubViewCell
        cell.cellDelegate = self
        cell.index = indexPath
        cell.linkto = self
        let index = indexPath.row
        if ProductList.count > 0 {
        cell.nameLabel.text = ProductList[index].name
            cell.userLabel.text = ProductList[index].userName
            cell.prixLabel.text = "\(ProductList[index].price!) DT"

        }
        if twoDimensionalArray.count > 0 {

                    if twoDimensionalArray[index].hasFavorited == true {
                        cell.favoriteButton.isSelected = true
                    }
                    else
                    {
                    cell.favoriteButton.isSelected =  false
                    }
        }


        if responseImages.count > 0 {
            cell.produitsImage.image = self.responseImages[indexPath.row]
        }
            cell.cosmosView.rating = Double(ratingNotes[indexPath.row]) ?? 0
        cell.cosmosView.isUserInteractionEnabled = false
        
       
     
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = UIColor.white
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        //        cell.favoriteButton.inputAccessoryView
        
        return cell
    }
}
// extention for UICollectionViewDelegateFlowLayout
extension produitParSubCatViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(ProductList[indexPath.row]) is selected")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "louerViewController") as! louerViewController
        vc.product =  ProductList[indexPath.row]
        Share.sharedName.product =  ProductList[indexPath.row]
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellsize = (heightVal < widthVal) ?  bounds.height : bounds.width 
        
        return CGSize(width: cellsize - 10   , height:  cellsize - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}//end of extension  ViewController
extension produitParSubCatViewController : TableNew {
    
    
 

    
    //my custom zooming logic
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
             //   self.inputContainerView.alpha = 0
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
            }, completion: { (completed) in
                //                    do nothing
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
               // self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
    }
    
}
