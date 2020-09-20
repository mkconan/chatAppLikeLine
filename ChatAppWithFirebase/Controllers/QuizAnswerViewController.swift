//
//  QuizAnswerViewController.swift
//  ChatAppWithFirebase
//
//  Created by 松浦孝太朗 on 2020/09/20.
//  Copyright © 2020 Kotaro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class QuizAnswerViewController: UIViewController {
    
    private var quizdata = [Quizdata]()
    
    @IBOutlet weak var questionTextView: UILabel!
    @IBOutlet weak var choiceAButton: UIButton!
    @IBOutlet weak var choiceBButton: UIButton!
    @IBOutlet weak var choiceCButton: UIButton!
    @IBOutlet weak var choiceDButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        fetchQuizFromFirestore()
    }
    
    private func setUpViews() {
        
        questionTextView.layer.borderWidth = 1
        questionTextView.layer.cornerRadius = 10
        choiceAButton.layer.borderWidth = 1
        choiceAButton.layer.cornerRadius = 25
        choiceBButton.layer.borderWidth = 1
        choiceBButton.layer.cornerRadius = 25
        choiceCButton.layer.borderWidth = 1
        choiceCButton.layer.cornerRadius = 25
        choiceDButton.layer.borderWidth = 1
        choiceDButton.layer.cornerRadius = 25
    }
    
    private func fetchQuizFromFirestore() {
        Firestore.firestore().collection("quiz").getDocuments { (snapshots, err) in
            if let err = err {
                print("Firestoreへのアクセスに失敗しました \(err)")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let qdata = Quizdata.init(dic: dic)

                print("data: ", qdata)
                self.quizdata.append(qdata)
                
                
                self.questionTextView.text = qdata.qsent
                self.choiceAButton.setTitle(qdata.cA, for: .normal)
                self.choiceBButton.setTitle(qdata.cB, for: .normal)
                self.choiceCButton.setTitle(qdata.cC, for: .normal)
                self.choiceDButton.setTitle(qdata.cD, for: .normal)
                
                self.quizdata.forEach { (qdata) in
//                    print("Test data: ", qdata.qsent)
                }
                

                
            })
            
        }
    }
    
    
}
