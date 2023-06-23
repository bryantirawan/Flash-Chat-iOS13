//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self Refer to *** below
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        //Register MessageCell.xib file. Nib and Xib are interchangable. Nib was old name for Xib.
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        //internet not fast enough for this to actually load so tableView.reloadData() used later
        loadMessages()
        
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
        //.addSnapshotListener listnes to any changes in database
            .addSnapshotListener { (querySnapshot, error) in
                
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                //querySnapshot?.documents[0].data()[K.Fstore.senderField]
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            //retrieved sender and messagebody from DB, now making Message object
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            //These two lines of code help you automatically scroll to the bottom of the messages when going to chatVC
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
        //If you want to get messages once
//        db.collection(K.FStore.collectionName).getDocuments { (querySnapshot, error) in
//            if let e = error {
//                print("There was an issue retrieving data from Firestore. \(e)")
//            } else {
//                //querySnapshot?.documents[0].data()[K.Fstore.senderField]
//                if let snapshotDocuments = querySnapshot?.documents {
//                    for doc in snapshotDocuments {
//                        let data = doc.data()
//                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
//                            //retrieved sender and messagebody from DB, now making Message object
//                            let newMessage = Message(sender: messageSender, body: messageBody)
//                            self.messages.append(newMessage)
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//                        }
//
//                    }
//                }
//            }
//        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data:
            [K.FStore.senderField: messageSender,
             K.FStore.bodyField: messageBody,
             K.FStore.dateField: Date().timeIntervalSince1970
            ])
            { (error) in if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Successfully saved data")
                //self.loadMessages() better to use addSnapshotListener like above
                
                //when using closures and updating UI, always use DispatchQueue so that code is executed in main thread as opposed to background thread which is where closure code usually takes place
                DispatchQueue.main.async {
                    self.messageTextfield.text = ""
                }
            }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            //Go back to welcome screen if logout successful
            navigationController?.popToRootViewController(animated: true)
//            Another option:
//            performSegue(withIdentifier: "LogOutUser", sender: self)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}


extension ChatViewController: UITableViewDataSource {
    //code for how many rows in a table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //code for what to display in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //This is a message from current User
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        

        //label is IBOutlet in MessageCell.xib
        return cell
}
}


// ***
// Useful if you want to allow user to select row cell in tableView. Don't forget to set tableView.delegate = self above if using this. Useful for to-do app but not going to be used for this app.
//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}


