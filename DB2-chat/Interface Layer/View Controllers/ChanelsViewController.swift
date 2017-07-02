//
//  ChanelsViewController.swift
//  DB2-chat
//
//  Created by Alexander Slobodjanjuk on 01.07.17.
//  Copyright © 2017 Alexander Slobodjanjuk. All rights reserved.
//

import UIKit
import SWTableViewCell
import BetterSegmentedControl

class ChannelsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTypeSegmentControll: BetterSegmentedControl!
    
    @IBOutlet weak var dialogsWithUnreadMessagesLabel: UILabel!
    
    var networkManager = NetworkManager()
    var channels = [Channel]()
    var leftUtilityButtons: NSMutableArray = []
    
    
    //    var unreadMessagesCount: NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTypeSegmentControll.titles = ["Chat", "Live Chat"]
        chatTypeSegmentControll.titleFont = UIFont.init(name: "HelveticaNeue", size: 13)!
        chatTypeSegmentControll.selectedTitleFont = UIFont.init(name: "HelveticaNeue", size: 13)!
        dialogsWithUnreadMessagesLabel.text = "2"
        dialogsWithUnreadMessagesLabel.layer.cornerRadius = dialogsWithUnreadMessagesLabel.frame.height/2
        dialogsWithUnreadMessagesLabel.layer.masksToBounds = true

        navigationController?.navigationBar.barTintColor = UIColor.lightBlueColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        

        
        networkManager.getChanelInfo { (channels) in
            self.channels = channels
            OperationQueue.main.addOperation({ () -> Void in
                self.tableView.reloadData()
            })
        }
        

        
        
    }
    
    
    //MARK: - NavigationBar Actions

    @IBAction func leftBarButtonItemPressed(_ sender: Any) {
        self.showMessage(message: "Back button pressed", userResponce: "I know")
    }
    
    @IBAction func rightBarButtonItemPressed(_ sender: Any) {
        self.showMessage(message: "Write new message button pressed", userResponce: "I know")

    }
    
    
}


//MARK: - UITableView Delegate

extension ChannelsViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 1:
//            return self.unreadMessagesCount
//        case 2:
//            return channels.count - unreadMessagesCount
//        default:
//            break
//        }
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChannelsTableViewCell
        
        cell.userNameLabel.text = self.channels[indexPath.row].firstName + " " + self.channels[indexPath.row].lastName
        cell.messageLabel.text = self.channels[indexPath.row].lastMessageText
        cell.timeLabel.text = self.channels[indexPath.row].createdDate
        
        cell.unreadMessagesCountLabel.text = String(self.channels[indexPath.row].unreadCount)

        
        
        if cell.unreadMessagesCountLabel.text == "0"{
            cell.unreadMessagesCountLabel.isHidden = true
        } else {
            cell.unreadMessagesCountLabel.isHidden = false
        }
        
        if let imageName = channels[indexPath.row].photo{
            self.networkManager.getImage(imageName: imageName) { (image) in
                cell.avatarImageView?.image = image
                cell.setNeedsLayout()
            }
        }
        
//        if channels[indexPath.row].isRead == false {
//            self.unreadMessagesCount += 1
//        }
        
        fillArrayCellActions()
        cell.delegate = self
        cell.setLeftUtilityButtons(leftUtilityButtons as! [Any], withButtonWidth: 140)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 12)
        let footerView = UIView(frame:rect)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ChatViewControllerID") as! ChatViewController
        
        viewController.userIdentifier = String(indexPath.row)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}


//MARK: - SWTableViewCell Delegate

extension ChannelsViewController: SWTableViewCellDelegate{
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerLeftUtilityButtonWith index: Int) {
        
        print("Remove button pressed! \(index)")
    }
    
    func fillArrayCellActions(){
        
        let _leftUtilityButtons = NSMutableArray()
        
        _leftUtilityButtons.sw_addUtilityButton(with: UIColor.lightBlueColor(), title: "Remove")
        
        leftUtilityButtons = _leftUtilityButtons
    }
}

//MARK: - UIViewController extensions

extension UIViewController {
    
    func showMessage(message: String, userResponce: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: userResponce, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

