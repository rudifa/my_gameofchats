//
//  NewMessageController.swift
//  my_gameofchats
//
//  Created by Rudolf Farkas on 11.05.18.
//  Copyright © 2018 Rudolf Farkas. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    
    var users = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: {
            (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = UserData()
                user.id = snapshot.key
                // user.setValuesForKeys(dict) // this class is not key value coding-compliant for the key name.'

                user.name = dict["name"] as? String
                user.email = dict["email"] as? String
                user.profileImageUrl = dict["profileImageUrl"] as? String
                self.users.append(user)
                
                self.tableView.reloadData()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
           }
        })
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageCachingFrom(imageUrl: profileImageUrl)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    var messagesController: MessageController?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: {
            print("dismiss controller")
            let user = self.users[indexPath.row]
            self.messagesController?.showChatLogControllerFor(user: user)
        })
    }
    
}

