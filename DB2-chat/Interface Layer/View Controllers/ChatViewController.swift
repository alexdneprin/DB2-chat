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
    
    var messages = [JSQMessage]()
    
    var messagesData = [Message]()
    
    var userIdentifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        networkManager.getMessageInfo(userIdentifier: userIdentifier, completionBlock:{(messages) in
//            self.messagesData = messages
//            
//            self.senderId = String(self.userIdentifier)
//            self.senderDisplayName = self.messagesData[1].firstName
//        })
        
        self.senderId = "1"
        self.senderDisplayName = "john"
//        self.messages[1].image
        
//        MessagesHandler.Instance.delegate = self;
//        self.senderId = AuthProvider.Instance.userID()
//        self.senderDisplayName = AuthProvider.Instance.userName;
        
//        MessagesHandler.Instance.observeMessages();
//        MessagesHandler.Instance.observeMediaMessages();

        
        messages.append(JSQMessage(senderId: "1", displayName: "john", text: self.userIdentifier));
        

    }

    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }

}


extension ChatViewController {
    
    // COLLECTION VIEW FUNCTIONS
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
//        let message = messagesData[indexPath.item]
        
//        if String(message.id) == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue);
//        } else {
//            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.blue);
//        }
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "community-image"), diameter: 30);
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        
//        let message = messages[indexPath.item];

        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
//        let msg = messagesData[indexPath.item]
        
//        if msg.isMediaMessage {
//            if let mediaItem = msg.media as? JSQVideoMediaItem {
//                let player = AVPlayer(url: mediaItem.fileURL);
//                let playerController = AVPlayerViewController();
//                playerController.player = player;
//                self.present(playerController, animated: true, completion: nil);
//            }
//        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell;
    }
    
    
    // DELEGATION FUNCTIONS


//    func messageReceived(senderID: String, senderName: String, text: String) {
//        messages.append(JSQMessage(senderId: "1", displayName: "john", text: self.userIdentifier as String!));
//        collectionView.reloadData();
//    }
}
