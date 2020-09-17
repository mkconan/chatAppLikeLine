//
//  QuizanswerViewController.swift
//  SummerHackason
//
//  Created by yu mikami on 2020/09/17.
//  Copyright © 2020 yu.m. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class QuizanswerViewController: UIViewController {
    
    private var quizdata = [Quizdata]()
    
    @IBOutlet weak var choice_a: UIButton!
    @IBOutlet weak var choice_b: UIButton!
    @IBOutlet weak var choice_c: UIButton!
    @IBOutlet weak var choice_d: UIButton!
    
    
    
    //quiztableview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchQuizFromFirestore() 
        
    }
    
    private func fetchQuizFromFirestore(){
        Firestore.firestore().collection("quiz").getDocuments { (snapshots, err) in
            if let err = err {
                print("Firestoreへのアクセスに失敗しました。\(err)")
                return
            }
            snapshots?.documents.forEach({ (snapshot) in
                let dic = snapshot.data()
                let qdata = Quizdata.init(dic: dic)
                
                self.quizdata.append(qdata)
                
                self.quizdata.forEach { (qdata) in
                    print("test data:", qdata.qsent)
                }
                
                print("data:",qdata)
            })
        }
    }
}

class QuizanswerViewCell: UITableViewCell{
    
    var qdata: Quizdata?{
        didSet{

        }
    }
    
    @IBAction func qsentence(_ sender: Any) {
    
    }
    @IBAction func choice_a(_ sender: UIButton) {
        sender.setTitle(qdata?.cA, for: .normal)
    }
    
    @IBAction func choice_b(_ sender: Any) {
    }
    
    @IBAction func choice_c(_ sender: Any) {
    }
    @IBAction func choice_d(_ sender: Any) {
    }
    
}
