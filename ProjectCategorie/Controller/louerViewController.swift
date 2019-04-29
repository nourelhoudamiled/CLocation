//
//  louerViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 29/03/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class louerViewController: UIViewController {
    
    var product : ProductClass?
    var text : Int?

    @IBOutlet var nameUniteLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var prixLabel: UILabel!
    @IBOutlet var isAvailble: UISwitch!
    @IBOutlet var telLabel: UILabel!
    @IBOutlet var adrLabel: UILabel!
    @IBOutlet var pageView: UIPageControl!
    @IBOutlet var sliderCollectionView: UICollectionView!
    
    var imgArr = [  UIImage(named:"AlexandraDaddario"),
                    UIImage(named:"AngelinaJolie") ,
                    UIImage(named:"AnneHathaway") ,
                    UIImage(named:"DakotaJohnson") ,
                    UIImage(named:"EmmaStone") ,
                    UIImage(named:"EmmaWatson") ,
                    UIImage(named:"HalleBerry") ,
                    UIImage(named:"JenniferLawrence") ,
                    UIImage(named:"JessicaAlba") ,
                    UIImage(named:"ScarlettJohansson") ]
    
    var timer = Timer()
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("product \(String(describing: product))")
        nameUniteLabel.text = product?.enumUniteName
        cityLabel.text = product?.enumCityName
        descriptionLabel.text = product?.description
      
        prixLabel.text =  "\(String(describing: product?.price))"
        
     
        
        adrLabel.text = product?.address
        if (product?.isAvailable == true){
            isAvailble.isOn = true
        }
        else{
           isAvailble.isOn = false
        }
        
        
        
//        telLabel.text = product.
        
        pageView.numberOfPages = imgArr.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @objc func changeImage() {
        
        if counter < imgArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
        
    }
    
    @IBAction func Gotocommentaire(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentaireViewController") as! CommentaireViewController
        
        present(vc, animated: true, completion: nil)
    }
    
}

extension louerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = imgArr[indexPath.row]
        }
        return cell
    }
}

extension louerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
