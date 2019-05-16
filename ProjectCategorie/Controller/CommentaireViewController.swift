//
//  CommentaireViewController.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 26/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
import Alamofire
class CommentaireViewController: UIViewController , UITextFieldDelegate  {

    var urlRequestImageByAttachmentId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    
    //   @IBOutlet var downloadImage: UIImageView!
    var urlRequestAttachmentsId = URLRequest(url: URL(string: "http://clocation.azurewebsites.net/api/Attachments/")!)
    var attachementList = [Int]()
    var responseImage = [UIImage]()
    @IBOutlet var pageView: UIPageControl!
    var timer = Timer()
    var counter = 0
    @IBOutlet var collectionSlide: UICollectionView!
    @IBOutlet var collectionView: UICollectionView!
    let uploadImageView = UIImageView()
   

    let separatorLineView = UIView()
    var comments = [Comment]()
     var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your commentaire..."
        textField.translatesAutoresizingMaskIntoConstraints = false
      
        return textField
    }()
     let sendButton = UIButton(type: .system)
    var containerViewBottomAnchor: NSLayoutConstraint?
    var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 50 , height: 50)
        containerView.backgroundColor = UIColor.white

       
     
        
        return containerView
    }()
    
       let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
     print("pid\(Share.sharedName.product?.id)")
        pageView.numberOfPages = responseImage.count
        photos()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    fetchdata()
   
         }
   func ecrirecommentaire () {
    
    inputTextField.delegate = self
    uploadImageView.isUserInteractionEnabled = true
    uploadImageView.image = UIImage(named: "upload_image_icon")
    uploadImageView.translatesAutoresizingMaskIntoConstraints = false
    inputContainerView.addSubview(uploadImageView)
    //x,y,w,h
    uploadImageView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
    uploadImageView.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
    uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
    uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    sendButton.setTitle("Comment", for: UIControl.State())
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    inputContainerView.addSubview(sendButton)
    //x,y,w,h
    sendButton.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
    sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
    sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    sendButton.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor).isActive = true
    
    
    inputContainerView.addSubview(self.inputTextField)
    self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
    self.inputTextField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
    self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
    self.inputTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor).isActive = true
    //x,y,w,h
    
    
    separatorLineView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    separatorLineView.translatesAutoresizingMaskIntoConstraints = false
    inputContainerView.addSubview(separatorLineView)
    //x,y,w,h
    separatorLineView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
    separatorLineView.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
    separatorLineView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
    separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    //        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    
    collectionView?.alwaysBounceVertical = true
    collectionView?.backgroundColor = UIColor.white
    //       collectionView?.register(CommentaireViewCell.self, forCellWithReuseIdentifier: cellId)
//    collectionView?.keyboardDismissMode = .interactive
    }
    
    @IBAction func retourButton(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        fetchdata()
        ecrirecommentaire()
    }
    
    @objc func changeImage() {
        
        if counter < responseImage.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionSlide.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionSlide.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
        
    }

    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
 
    @objc func handleSend() {
//        let properties = ["commentaire": inputTextField.text!]
       sendMessageWithProperties()
    }
    
    func fetchdata() {
        guard let productId = Share.sharedName.product?.id else {return}
        let urlString = "https://clocation.azurewebsites.net/api/Comments/\(productId)/Comment"
        self.comments.removeAll()

        AF.request(urlString, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch response.result {
            case .success:
                do {
                    if let data = response.data {
                        let itemDetails1 = try JSONDecoder().decode([Comment].self, from: data)
                        for item1 in itemDetails1 {
                        
                            self.comments.append(item1)
                            DispatchQueue.main.async(execute: {
                                self.collectionView?.reloadData()
                                //scroll to the last index
                                let indexPath = IndexPath(item: self.comments.count - 1, section: 0)
                                self.comments.sort() { $0.id! < $1.id! }
                                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
                                
                            })
                         
                        }
                      
                    
                            
                    }
                    
                }catch let errords {
                    
                    print(errords)
                }
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    func photos(){
        let urlStringAttachmentsId = urlRequestAttachmentsId.url?.absoluteString
        let urlStringImageByAttachmentId = urlRequestImageByAttachmentId.url?.absoluteString
        let productId = Share.sharedName.product?.id
        let attachementsURL = urlStringAttachmentsId! + "\(productId!)/AttachmentsId"
        AF.request(attachementsURL).responseJSON {
            response in
            do {
                guard let data = response.data else {return}
                let attachements = try JSONDecoder().decode([Attachement].self, from: data)
                for atachement in attachements {
                    self.attachementList.append(atachement.id!)
                    guard let  attachementId = atachement.id else {return}
                    let AttachmentIdURL = urlStringImageByAttachmentId! + "\(attachementId)/ImageByAttachmentId"
                    
                    AF.request(AttachmentIdURL , method : .get ).responseImage {
                        response in
                        guard let image = response.data else {return}
                        print(image)
                        self.responseImage.append( UIImage(data: image) ?? UIImage(named: "pot-1")! )
                        self.collectionSlide.reloadData()
                        
                    }
                }
                
                
            }catch let error {
                print(error)
            }
            
        }
        
        
    }
   func sendMessageWithProperties() {
    let urlString = "https://clocation.azurewebsites.net/api/Comments"
//    var values: [String: AnyObject] = ["commentaire": inputTextField.text! as AnyObject]
//
//    //append properties dictionary onto values somehow??
//    //key $0, value $1
//    properties.forEach({values[$0] = $1})
//    print(properties)
    let userId = AppManager.shared.iduser
    let userName = AppManager.shared.user?.email
    let productId = Share.sharedName.product?.id
    let productName =  "jupe"
    let params = ["userId" : userId , "userName" : userName,"productId" : productId, "productName" : productName,"commentaire" : inputTextField.text!] as [String : Any]
    AF.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
        response in
        
        switch response.result {
        case .success:
            print(response)
            self.inputTextField.text = nil
            
            self.fetchdata()
            
                    
                
                
          
            
            break
        case .failure(let error):
            
            print(error)
        }
     
        
        

        
    }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }


}


extension CommentaireViewController : UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate , UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == self.collectionSlide {
        return responseImage.count
        
       }
       else {
        return comments.count
        }
    }
    

 func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  if collectionView == self.collectionSlide {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! sliderCommentCollectionViewCell
    
    cell.imageView.image = responseImage[indexPath.row]
       return cell
    }
    
  else  {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentaireViewCell
    cell.index = indexPath
    cell.cellDelegate = self
 
        cell.CommentaireViewController = self
        let comment = comments[indexPath.item]
        cell.textView.text = comment.commentaire
        setupCell(cell, message: comment)

        if let text = comment.commentaire {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
            cell.textView.isHidden = false
        }
        
        
        
        return cell
    }
    }

    fileprivate func setupCell(_ cell: CommentaireViewCell, message: Comment) {
    
            cell.profileImageView.image = UIImage(named: "photo")
        
//outgoing blue
            cell.bubbleView.backgroundColor = CommentaireViewCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = false

            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false

      
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     if collectionView == self.collectionSlide {
        let size = collectionSlide.frame.size
        return CGSize(width: size.width, height: size.height)
     }
     else  {
        var height: CGFloat = 80
        
        let message = comments[indexPath.item]
        
        if let text = message.commentaire {
            height = estimateFrameForText(text).height + 20
        }
        
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    }
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes :[NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)] , context : nil)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
extension CommentaireViewController : crud {
    
    func update(index: Int)
    {          //  guard let indexPathTapped = self.collectionView.indexPath(for: cell) else { return }

        let alert = UIAlertController(title: "edit comment",
                                      message: "edit something",
                                      preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            
            
            let textField = alert.textFields![0]
            self.editCommentaire(Id: self.comments[index].id!, userId: self.comments[index].userId!, commentaire: textField.text!, productId: self.comments[index].productId!)
          

            print("commentaire update \(textField.text!)")
        })
        
       //   self.collectionView.reloadData()
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.text = self.comments[index].commentaire
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Type something here"
            textField.clearButtonMode = .whileEditing
            
            alert.addAction(submitAction)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func delete(index: Int) {
        self.deleteCommentaire(Id: comments[index].id!)
        comments.remove(at : index)
        collectionView.reloadData()
        
    }
    func deleteCommentaire (Id : Int ) {
        
        
        let urlString = "https://clocation.azurewebsites.net/api/Comments/\(Id)"
        
        AF.request(urlString, method: .delete,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            print(response)
        }
    }

    func editCommentaire (Id : Int , userId : String , commentaire : String, productId : Int) {
        let params = ["id": Id, "commentaire" : commentaire,"productId": productId,  "userId": userId ] as [String : Any]
        
        let urlString = "https://clocation.azurewebsites.net/api/Comments/\(Id)"
        
        AF.request(urlString, method: .put, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            print(response)
        }
    }
    
}
