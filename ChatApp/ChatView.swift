//
//  ChatView.swift
//  ChatApp
//
//  Created by Gomi Kouki on 2023/09/07.
//

import UIKit
import Foundation

class ChatView: UIViewController,UITableViewDelegate,UITableViewDataSource, InputViewDelegate{
    
    
    
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let database = DatebaseHelper()
    var roomData:ChatRoom!
    var chatData:[ChatText] = []
    var massageCount = -1
    
    private lazy var buttomInputView:InputView = {
        let view = InputView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    func sendTapped(text: String) {
        database.sendChatMessage(roomID: roomData.roomID, text: text)
    }
    
    override var inputAccessoryView: UIView?{
        return buttomInputView
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.getUserName(userID: roomData.userID, result: {
            name in
            self.navigationItem.title = name
        })

        database.chatDataListener(roomID: roomData.roomID, result: {
            result in
            self.chatData = result
            self.messageUpdated()
        })
        tableView.keyboardDismissMode = .interactive
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0)
        
    }
    
    func scrollToBottom(){
        let romNum = tableView.numberOfRows(inSection: 0)
        if romNum != 0{
            tableView.scrollToRow(at: IndexPath(row: romNum-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyboardFrame.cgRectValue.height
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollToBottom()
        }
    }
    @objc func keyboardWillHide(){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.0, right: 0)
    }
    
    func messageUpdated(){
        tableView.reloadData()
        scrollToBottom()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        let data = chatData[indexPath.row]
        if data.userID == AuthHelper().uid(){
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")!
        }
        let imageView = cell.viewWithTag(2) as! UIImageView
        imageView.layer.cornerRadius = imageView.frame.height * 0.5
        imageView.clipsToBounds = true
        database.getImage(userID: data.userID, imageView: imageView)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = data.text
        label.layer.cornerRadius = label.frame.height * 0.5
        label.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}
