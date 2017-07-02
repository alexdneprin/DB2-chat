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
    
    var sortedChanelsData = [[Channel]]()
    
    var leftUtilityButtons: NSMutableArray = []
    
    var totalUnreadMessageCount: NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkManager.getChanelInfo { (sortedChanelsData) in
            self.sortedChanelsData = sortedChanelsData
            
            OperationQueue.main.addOperation({ () -> Void in
                self.tableView.reloadData()
                self.dialogsWithUnreadMessagesLabel.text = String(describing: sortedChanelsData[0].count)
            })
        }
        
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        
        chatTypeSegmentControll.titles = ["Chat", "Live Chat"]
        chatTypeSegmentControll.titleFont = UIFont.init(name: "HelveticaNeue", size: 13)!
        chatTypeSegmentControll.selectedTitleFont = UIFont.init(name: "HelveticaNeue", size: 13)!
        
        dialogsWithUnreadMessagesLabel.layer.cornerRadius = dialogsWithUnreadMessagesLabel.frame.height/2
        dialogsWithUnreadMessagesLabel.layer.masksToBounds = true
        
        navigationController?.navigationBar.barTintColor = UIColor.lightBlueColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
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
        
        if sortedChanelsData.count != 0{
            switch section {
            case 0:
                return sortedChanelsData[0].count
            case 1:
                return sortedChanelsData[1].count
            default:
                break
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChannelsTableViewCell
        
        cell.messageLabel.text = sortedChanelsData[indexPath.section][indexPath.row].lastMessageText
        cell.userNameLabel.text = (sortedChanelsData[indexPath.section][indexPath.row].firstName) + " " + (sortedChanelsData[indexPath.section][indexPath.row].lastName)
        
        
        //! The date must be in the correct format
        
        let currentTime = sortedChanelsData[indexPath.section][indexPath.row].createdDate.slice(from: "T", to: ".")
        cell.timeLabel.text = currentTime
        
        cell.unreadMessagesCountLabel.text = String(describing: sortedChanelsData[indexPath.section][indexPath.row].unreadCount)

        let imageName = sortedChanelsData[indexPath.section][indexPath.row].photo
        self.networkManager.getImage(imageName: imageName) { (image) in
            cell.avatarImageView?.image = image
            cell.setNeedsLayout()
        }
        
        if cell.unreadMessagesCountLabel.text == "0"{
            cell.unreadMessagesCountLabel.isHidden = true
        } else {
            cell.unreadMessagesCountLabel.isHidden = false
        }
        
        fillArrayCellActions()
        cell.delegate = self
        cell.setLeftUtilityButtons(leftUtilityButtons as! [Any], withButtonWidth: 140)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
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
        viewController.avatarAdress = sortedChanelsData[indexPath.section][indexPath.row].photo
        viewController.controllerTitleText = sortedChanelsData[indexPath.section][indexPath.row].firstName + " " + sortedChanelsData[indexPath.section][indexPath.row].lastName
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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




