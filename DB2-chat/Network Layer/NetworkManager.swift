//
//  NetworkManager.swift
//  DB2-chat
//
//  Created by Alexander Slobodjanjuk on 01.07.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import JSQMessagesViewController

class NetworkManager: NSObject {
    
    var messages = [Message]() // This class contains values that may be useful
    
    var jsqMessages = [JSQMessage]()
    var sortedChanelsData = [[Channel]]()
    
    let baseURL: String = "http://ec2-34-211-67-136.us-west-2.compute.amazonaws.com/api/"
    
    //MARK: - Requests Functions

    public func getChanelInfo(completionBlock: @escaping([[Channel]]) -> ()){
        Alamofire.request(baseURL+"chat/channels/").responseJSON { (response: DataResponse<Any>) in
            
            self.sortedChanelsData = [[Channel()], [Channel()]] // init array
            
            guard response.result.isSuccess else {
                print("Error while fetching data: \(String(describing: response.result.error))")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any]
                else {
                    print("Invalid information received from the service")
                    return
            }
                        
            if let resultJSON = responseJSON["channels"] as? [[String:Any]] {
                self.parsingChanelsJSON(inputJSON: resultJSON)
            }
            
            self.sortedChanelsData[0].remove(at: 0)
            self.sortedChanelsData[1].remove(at: 0)

            completionBlock(self.sortedChanelsData)
        }
    }
    
    public func getMessageInfo(userIdentifier: String, completionBlock: @escaping([Message],[JSQMessage]) -> ()){
        Alamofire.request(baseURL+"/chat/channels/" + userIdentifier + "/messages/" ).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                print("Error while fetching data: \(String(describing: response.result.error))")
                return
            }
            
            guard let responseJSON = response.result.value as? [String: Any]
                else {
                    print("Invalid information received from the service")
                    return
            }
            
            if let resultJSON = responseJSON["messages"] as? [[String:Any]] {
                self.parsingMessagesJSON(inputJSON: resultJSON)
            }
            
            completionBlock(self.messages, self.jsqMessages)
        }
    }
    
    //MARK: - JSON Parsing Functions

    func parsingChanelsJSON(inputJSON: [[String: Any]]) -> (){
        
        for object in inputJSON {
            
            let channel = Channel()
            
            channel.id = object["id"] as! NSInteger
            channel.unreadCount = object["unread_messages_count"] as! NSInteger

            if let lastMessage = object["last_message"] as! NSDictionary?{
                channel.createdDate = lastMessage["create_date"] as! String
                channel.isRead = lastMessage["is_read"] as! Bool
                
                channel.lastMessageText = lastMessage["text"] as! String
                
                if let sender = lastMessage["sender"] as! NSDictionary? {
                    channel.firstName = sender["first_name"] as! String
                    channel.lastName = sender["last_name"] as! String
                    channel.photo = sender["photo"] as! String
                    channel.userName = sender["username"] as! String
                }
            }
            
            if channel.unreadCount != 0 {
                self.sortedChanelsData[0].append(channel)
            } else {
                self.sortedChanelsData[1].append(channel)
            }
        }
    }
    
    func parsingMessagesJSON(inputJSON: [[String: Any]]) -> (){
        
        for object in inputJSON {
            
            let message = Message()
            let jsqMessage: JSQMessage
            
            message.isRead = object["is_read"] as! Bool
            message.createDate = object["create_date"] as! String
            
            if let sender = object["sender"] as! NSDictionary?{
                
                message.photo = sender["photo"] as! String
                message.userName = sender["username"] as! String
                
            jsqMessage = JSQMessage.init(senderId: String(describing: sender["id"]!), displayName: sender["username"] as! String, text: object["text"] as! String)
                self.jsqMessages.append(jsqMessage)
            }

            self.messages.append(message)
        }
        
    }
    
    
    //MARK: - Get Image
    
    public func getImage(imageName: String, completionBlock: @escaping (UIImage) -> ()){
        
        Alamofire.request(imageName, method: .get).responseImage { response in
            guard let image = response.result.value else {
                print("download error")
                return
            }
            completionBlock(image)
        }
    }
    
}
