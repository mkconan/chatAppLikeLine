//
//  QuizMenuViewController.swift
//  ChatAppWithFirebase
//
//  Created by 松浦孝太朗 on 2020/09/17.
//  Copyright © 2020 Kotaro. All rights reserved.
//

import UIKit

class QuizMenuViewController:UIViewController {
    
    @IBAction func tappedAnswerButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "QuizAnswer", bundle: nil)
        let quizAnswerViewController = storyboard.instantiateViewController(identifier: "QuizAnswerController")
        //self.present(quizAnswerViewController, animated: true, completion: nil)
        navigationController?.pushViewController(quizAnswerViewController, animated: true)
    }
    
    @IBAction func tappedQuestionButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "QuizRegister", bundle: nil)
        let quizRegisterViewController = storyboard.instantiateViewController(identifier: "QuizRegisterViewController")
        //self.present(quizRegisterViewController, animated: true, completion: nil)
        navigationController?.pushViewController(quizRegisterViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "クイズ"
        
        
    }
}
