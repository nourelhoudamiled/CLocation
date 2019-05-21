//
//  CommentaireViewCell.swift
//  ProjectCategorie
//
//  Created by MacBook Pro on 26/04/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit
protocol crud{
    
    func delete(index : Int )
      func update(index : Int)
}
class CommentaireViewCell: UICollectionViewCell {
    var CommentaireViewController: CommentaireViewController?
    var cellDelegate : crud?
    var index : IndexPath?
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    static let blueColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        
        
        //x,y,w,h
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 1).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        //x,y,w,h
        
        //x,y,w,h
        
        bubbleViewRightAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50)
        
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ios 9 constraints
        //x,y,w,h
        //        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //        textView.widthAnchor.constraintEqualToConstant(200).active = true
        
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        DeleteButton.setImage(#imageLiteral(resourceName: "permissionsIcon"), for: .normal)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func delButton(_ sender: Any) {
          cellDelegate?.delete(index: index!.row)
    }
    @IBAction func editButton(_ sender: Any) {
        cellDelegate?.update(index: index!.row)
    }
   
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}

