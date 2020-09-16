//
//  UserListViewController.swift
//  ChatAppWithFirebase
//
//  Created by 松浦孝太朗 on 2020/09/16.
//  Copyright © 2020 Kotaro. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Nuke

class UserListViewController: UIViewController {
    
    private let cellId = "cellId"
    private var users = [User]()
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var startChatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userListTableView.delegate = self
        userListTableView.dataSource = self
        startChatButton.layer.cornerRadius = 15
        
        navigationController?.navigationBar.barTintColor = .rgb(red: 39, green: 49, blue: 69)
        fetchUserInfoFromFirestore()
    }
    
    private func fetchUserInfoFromFirestore(){
        
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("user情報の取得に失敗しました \(err)")
                return
            }
            
            print("user情報の取得に成功しました")
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                if uid == snapshot.documentID {
                    return 
                }
                
                self.users.append(user)
                self.userListTableView.reloadData()
                
            })
        }
        
    }
    
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserListTableViewCell
        cell.user = users[indexPath.row]
        
        
        return cell
    }
    
    
}

class UserListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLagel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user: User? {
        didSet {
            usernameLagel.text = user?.username
            
            if let url = URL(string: user?.profileImageUrl ?? "") {
                Nuke.loadImage(with: url, into: userImageView)
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 25
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
