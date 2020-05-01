//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Shikhar Kumar on 1/19/20.
//  Copyright © 2020 Shikhar Kumar. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageBar: UITextField!
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: K.chatNibName, bundle: nil), forCellReuseIdentifier: K.chatCellIdentifier)
        
        title = K.appName
        navigationItem.hidesBackButton = true
        
        messageBar.delegate = self
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener() { (querySnapshot, err) in
            self.messages = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let documents = querySnapshot?.documents {
                    for document in documents {
                        if let sender = document.data()[K.FStore.senderField] as? String,
                            let body =  document.data()[K.FStore.bodyField] as? String,
                            let date =  document.data()[K.FStore.dateField] as? TimeInterval {
                            self.messages.append(Message(sender: sender, body: body, date: date))
                            
                            DispatchQueue.main.async {
                                self.chatTableView.reloadData()
                                
                                let finalRowIndex = IndexPath(row: self.messages.count - 1, section: 0)
                                self.chatTableView.scrollToRow(at: finalRowIndex, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageBar.text, let messageSender = Auth.auth().currentUser?.email {
            performMessageSend(body: messageBody, sender: messageSender)
        }
    }
    
    func performMessageSend(body: String, sender: String) {
        db.collection(K.FStore.collectionName).addDocument(data: [
            K.FStore.bodyField: body,
            K.FStore.senderField: sender,
            K.FStore.dateField: Date().timeIntervalSince1970
        ]) { (error) in
            if let e = error {
                print ("There was an error trying to saving data to firestore. \(e)`")
            } else {
                DispatchQueue.main.async {
                    self.messageBar.text = ""
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: K.chatCellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].body
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            formatMeCell(cell)
        } else {
            formatYouCell(cell)
        }
        
        return cell
    }
    
    func formatMeCell(_ cell: MessageCell) {
        cell.leftAvatar.isHidden = true
        cell.rightAvatar.isHidden = false
        cell.messageBubble.backgroundColor = UIColor.init(named: K.BrandColors.purple)
        cell.messageLabel.textColor = UIColor.init(named: K.BrandColors.lightPurple)
    }
    
    func formatYouCell(_ cell: MessageCell) {
        cell.leftAvatar.isHidden = false
        cell.rightAvatar.isHidden = true
        cell.messageBubble.backgroundColor = UIColor.init(named: K.BrandColors.blue)
        cell.messageLabel.textColor = UIColor.init(named: K.BrandColors.lightBlue)
    }
}

// MARK: - UITextViewDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let messageBody = messageBar.text, let messageSender = Auth.auth().currentUser?.email {
            performMessageSend(body: messageBody, sender: messageSender)
        }
        return true
    }
}
