//
//  ChatViewController.swift
//  DB2-chat
//
//  Created by Alexander Slobodjanjuk on 01.07.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var networkManager = NetworkManager()
    
    var jsqMessages = [JSQMessage]()
    
    var messages = [Message]()
    var avatar = UIImage.init()
    
    var avatarAdress: String = ""
    var controllerTitleText: String = ""
    
    var userIdentifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = controllerTitleText
        
        self.senderId = "1947"
        self.senderDisplayName = "nickrock"
        
        self.networkManager.getImage(imageName: avatarAdress) { (image) in
            self.avatar = image
        }
        
        networkManager.getMessageInfo(userIdentifier: userIdentifier) { (messages, jsqMessages) in
            
            self.jsqMessages = jsqMessages
            OperationQueue.main.addOperation({ () -> Void in
                self.collectionView.reloadData()
            })
        }
        
        controllerInterfaceSetup()
    }
        
    func controllerInterfaceSetup(){
        
        inputToolbar.contentView.rightBarButtonItemWidth = 50
        inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: "photo-image"), for: .normal)
        
        
        inputToolbar.contentView.leftBarButtonItem = nil
        inputToolbar.contentView.backgroundColor = .white
        inputToolbar.contentView.textView.layer.borderWidth = 0
        inputToolbar.contentView.textView.placeHolder = "Message..."
        inputToolbar.contentView.textView.textColor = UIColor.lightGray
        inputToolbar.contentView.textView.font = UIFont(name: "HelveticaNeue", size: 15)
        inputToolbar.layer.borderWidth = 0
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 40.0, height: 40.0)
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 0, height: 0)
        collectionView.backgroundColor = UIColor.generateColor(246, green: 246, blue: 246, alpha: 1)
        

        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back-image")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back-image")
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.backItem?.titleView?.isHidden = true
        
        
        let block = UIBarButtonItem(title: "Block", style: .plain, target: self, action: #selector(blockTapped))
        block.tintColor = .white
        
        if let font = UIFont(name: "HelveticaNeue-Medium", size: 13) {
            block.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }
        
        navigationItem.rightBarButtonItems = [block]

    }
    
    func blockTapped() {
        showMessage(message: "Block button pressed", userResponce: "I know")
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
}


extension ChatViewController {
    
    // COLLECTION VIEW FUNCTIONS
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
//        let imagee = JSQMessagesBubbleImage.init(messageBubble: UIImage(named: "photo-image")!, highlightedImage: (UIImage(named: "photo-image"))

        
        let message = jsqMessages[indexPath.item]
        
        
        if String(message.senderId) == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.lightBlueColor());
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.white);
        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return JSQMessagesAvatarImageFactory.avatarImage(with: avatar, diameter: 30);
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
        return jsqMessages[indexPath.item]
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = jsqMessages[indexPath.item]
        
        if String(message.senderId) == self.senderId {
            cell.textView.textColor = .white
            cell.textView.textAlignment = .right
            cell.messageBubbleImageView.image = UIImage.init(named: "blue-message")

        } else {
            cell.textView.textColor = .darkGray
            cell.textView.textAlignment = .left
            cell.messageBubbleImageView.image = UIImage.init(named: "white-message")

        }
        
        
        cell.textView.font = UIFont(name: "HelveticaNeue", size: 14)
        cell.textView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12) // This can be realized with an observer content size

        
        return cell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var superSize: CGSize = super.collectionView.collectionViewLayout.sizeForItem(at: indexPath)
        
        if(superSize.height < 40){
            superSize = CGSize(width: superSize.width, height: 40.0)
        }
        
        return superSize
    }
    
}
