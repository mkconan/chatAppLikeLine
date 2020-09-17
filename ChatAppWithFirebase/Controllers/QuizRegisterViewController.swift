//
//  QuizRegisterViewController.swift
//  SummerHackason
//
//  Created by yu mikami on 2020/09/16.
//  Copyright © 2020 yu.m. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class  QuizRegisterViewController: UIViewController{
    
    @IBOutlet weak var Qsentences: UITextField!
    @IBOutlet weak var Choice_A: UITextField!
    @IBOutlet weak var Choice_B: UITextField!
    @IBOutlet weak var Choice_C: UITextField!
    @IBOutlet weak var Choice_D: UITextField!
    @IBOutlet weak var Choice_ans: UITextField!
    @IBOutlet weak var Commentary: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        RegisterButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        
        Qsentences.delegate = self
        Choice_A.delegate = self
        Choice_B.delegate = self
        Choice_C.delegate = self
        Choice_D.delegate = self
        Choice_ans.delegate = self
        Commentary.delegate = self

        RegisterButton.isEnabled = false
        RegisterButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
    }
    
    @objc private func tappedRegisterButton(){
        guard let qsent = Qsentences.text else { return }
        guard let cA = Choice_A.text else { return }
        guard let cB = Choice_B.text else { return }
        guard let cC = Choice_C.text else { return }
        guard let cD = Choice_D.text else { return }
        guard let cans = Choice_ans.text else { return }
        guard let comment = Commentary.text else { return }
        
        let docData = [
            "qsent": qsent,
            "cA": cA,
            "cB": cB,
            "cC": cC,
            "cD": cD,
            "cans": cans,
            "comment": comment
            ] as [String : Any]
        
        Firestore.firestore().collection("quiz").document(qsent).setData(docData) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました。\(err)")
                //HUD.hide()
                return
            }
            
            print("Firestoreへの情報の保存が成功しました。")
            //HUD.hide()
            self.dismiss(animated: true, completion: nil)
            
        }
            
    
    }
    
}

extension QuizRegisterViewController:UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let qsentencesIsEmpty = Qsentences.text?.isEmpty ?? false
        let choiceAISEmpty = Choice_A.text?.isEmpty ?? false
        let choiceBISEmpty = Choice_B.text?.isEmpty ?? false
        let choiceCISEmpty = Choice_C.text?.isEmpty ?? false
        let choiceDISEmpty = Choice_D.text?.isEmpty ?? false
        let choiceansISEmpty = Choice_ans.text?.isEmpty ?? false
        let commentaryISEmpty = Commentary.text?.isEmpty ?? false
        
        if qsentencesIsEmpty || choiceAISEmpty || choiceBISEmpty || choiceCISEmpty || choiceDISEmpty || choiceansISEmpty || commentaryISEmpty {
            RegisterButton.isEnabled = false
            RegisterButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)
        } else {
            RegisterButton.isEnabled = true
            RegisterButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
        }
    }
}
