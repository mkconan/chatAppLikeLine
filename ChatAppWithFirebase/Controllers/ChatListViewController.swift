//
//  ChatListViewController.swift
//  ChatAppWithFirebase
//
//  Created by 松浦孝太朗 on 2020/09/13.
//  Copyright © 2020 Kotaro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Nuke

class ChatListViewController: UIViewController {
    
    private let cellId = "cellId"
    private var chatrooms = [ChatRoom]()
    private var chatRoomLister: ListenerRegistration?
    
    
    private var user: User? {
        didSet {
            navigationItem.title = user?.username
        }
    }
    
    @IBOutlet weak var chatListTableView: UITableView!
    @IBAction func tappedQuizMenuButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "QuizMenu", bundle: nil)
        let quizMenuViewController = storyboard.instantiateViewController(withIdentifier: "QuizMenuViewController")
        //self.present(quizMenuViewController, animated: true, completion: nil)
        navigationController?.pushViewController(quizMenuViewController, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        confirmLoggedInUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLoginUserInfo()
        fetchChatroomsInfoFromFirestore()
    }
    
    
    func fetchChatroomsInfoFromFirestore() {
        chatRoomLister?.remove()
        chatrooms.removeAll()
        chatListTableView.reloadData()
        
        chatRoomLister = Firestore.firestore().collection("chatRooms")
            .addSnapshotListener { (snapshots, err) in
                if let err = err {
                    print("チャットルーム情報の取得に失敗しました \(err)")
                    return
                }
                
                snapshots?.documentChanges.forEach({ (documentChange) in
                    switch documentChange.type {
                    case .added:
                        self.handleAddedDocumrentChange(documentChange: documentChange)
                    case .modified, .removed:
                        print("nothing to do")
                    }
                })
                
        }
    }
    
    private func handleAddedDocumrentChange(documentChange: DocumentChange) {
        let dic = documentChange.document.data()
        let chatroom = ChatRoom(dic: dic)
        chatroom.documentId = documentChange.document.documentID
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isContain = chatroom.members.contains(uid)
        
        if !isContain { return }
        
        chatroom.members.forEach { (memberUid) in
            if memberUid != uid {
                Firestore.firestore().collection("users").document(memberUid).getDocument { (userSnapshot, err) in
                    if let err = err {
                        print("ユーザ情報の取得に失敗しました \(err)")
                        return
                    }
                    
                    guard let dic = userSnapshot?.data() else { return }
                    let user = User(dic: dic)
                    user.uid = documentChange.document.documentID
                    chatroom.partnerUser = user
                    
                    guard let chatroomId = chatroom.documentId else { return }
                    let latestMessageId = chatroom.latestMessageId
                    
                    if latestMessageId == "" {
                        self.chatrooms.append(chatroom)
                        self.chatListTableView.reloadData()
                        return
                    }
                    
                    Firestore.firestore().collection("chatRooms").document(chatroomId).collection("messages").document(latestMessageId).getDocument { (messageSnapshot, err) in
                        if let err = err {
                            print("最新情報の取得に失敗しました \(err)")
                            return
                        }
                        
                        guard let dic = messageSnapshot?.data() else {return}
                        let message = Message(dic: dic)
                        chatroom.latestMessage = message
                        
                        self.chatrooms.append(chatroom)
                        self.chatListTableView.reloadData()
                        
                    }
                    
                    
                }
                
            }
        }
    }
    
    private func setupViews() {
        chatListTableView.tableFooterView = UIView()
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 29, green: 49, blue: 69)
        navigationItem.title = "Talk"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        let rightBarButton = UIBarButtonItem(title: "New Chat", style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(tappedLogoutButton))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = logoutBarButton
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil {
            pushLoginViewController()
        }
    }
    
    @objc private func tappedLogoutButton() {
        
        do {
            try Auth.auth().signOut()
            pushLoginViewController()
        } catch {
            print("ログアウトに失敗しました \(error)")
        }

        
    }
    
    @objc private func tappedNavRightBarButton() {

        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
    
    private func pushLoginViewController() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        let nav = UINavigationController(rootViewController: signUpViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    private func fetchLoginUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("ユーザ情報の取得に失敗しました \(err)")
                return
            }
            
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            
            let user = User(dic: dic)
            self.user = user
            
            
        }
        
    }
    
    
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
        cell.chatroom = chatrooms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        chatRoomViewController.user = user
        chatRoomViewController.chatroom = chatrooms[indexPath.row]
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    
}

class ChatListTableViewCell: UITableViewCell{

    
    var chatroom: ChatRoom? {
        didSet {
            if let chatroom = chatroom {
                partnerLabel.text = chatroom.partnerUser?.username
                
                guard let url = URL(string: chatroom.partnerUser?.profileImageUrl ?? "") else { return }
                Nuke.loadImage(with: url, into: userImageView)
                
                dateLabel.text = dateFormatterForDateLabel(date: chatroom.latestMessage?.createdAt.dateValue() ?? Date())
                latestMessageLabel.text = chatroom.latestMessage?.message
                
            }
            
        }
    }
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
 
    
        
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 30
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        
        return formatter.string(from: date)
    }
    
}
