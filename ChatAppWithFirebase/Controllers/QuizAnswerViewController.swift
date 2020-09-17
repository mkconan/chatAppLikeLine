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

class QuizanswerViewCell: UIView{
    
    var qdata: Quizdata?{
        didSet{
            if let qdata = qdata{
                choice_a.titleLabel?.text = qdata.cA
                choice_b.titleLabel?.text = qdata.cB
                choice_c.titleLabel?.text = qdata.cC
                choice_d.titleLabel?.text = qdata.cD
                qsentence.text = qdata.qsent

            }
        }
    }
    
    
    @IBOutlet weak var qsentence: UITextField!
    @IBOutlet weak var choice_a: UIButton!
    @IBOutlet weak var choice_b: UIButton!
    @IBOutlet weak var choice_c: UIButton!
    @IBOutlet weak var choice_d: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    */
}
