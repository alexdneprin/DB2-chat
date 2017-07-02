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

class NetworkManager: NSObject {
    
    var channels = [Channel]()
    var messages = [Message]()
    
    let baseURL: String = "http://ec2-34-211-67-136.us-west-2.compute.amazonaws.com/api/"
    
    public func getChanelInfo(completionBlock: @escaping([Channel]) -> ()){
        Alamofire.request(baseURL+"chat/channels/").responseJSON { (response: DataResponse<Any>) in
            
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
                self.parceChanelsJSON(inputJSON: resultJSON)
            }
            
            completionBlock(self.channels)
        }
    }
    
    public func getMessageInfo(userIdentifier: NSInteger, completionBlock: @escaping([Message]) -> ()){
        Alamofire.request(baseURL+"/chat/channels/" + String(userIdentifier) + "/messages/" ).responseJSON { (response) in
            
            print(response)
            
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
                self.parceMessagesJSON(inputJSON: resultJSON)
            }
            
            completionBlock(self.messages)
            
        }
        
    }
    
    func parceChanelsJSON(inputJSON: [[String: Any]]) -> (){
        
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
            
            self.channels.append(channel)
        }
    }
    
    func parceMessagesJSON(inputJSON: [[String: Any]]) -> (){
        
        for object in inputJSON {
            
            let message = Message()
            
            message.isRead = object["is_read"] as! Bool
            message.createDate = object["create_date"] as! String
            message.text = object["text"] as! String
            
            if let sender = object["sender"] as! NSDictionary?{
                
                message.id = sender["id"] as! NSInteger
                message.firstName = sender["first_name"] as! String
                message.lastName = sender["last_name"] as! String
                message.photo = sender["photo"] as! String
                message.userName = sender["username"] as! String
                
                print(message.id)
                print(message.firstName)
                print(message.lastName)
                print(message.photo)
                print(message.userName)

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
