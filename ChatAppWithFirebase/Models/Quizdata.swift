//
//  Quizdata.swift
//  SummerHackason
//
//  Created by yu mikami on 2020/09/17.
//  Copyright © 2020 yu.m. All rights reserved.
//

import Foundation


class Quizdata{
    /*
    let Quizsentences : String
    let Choice_A : String
    let Choice_B : String
    let Choice_C : String
    let Choice_D : String
    let Choice_ans : String
    let Commentary : String
    */
    let qsent : String
    let cA : String
    let cB : String
    let cC : String
    let cD : String
    let cans : String
    let comment : String
    
    
    init(dic : [String:Any]){
        self.qsent = dic["qsent"] as? String ?? ""
        self.cA = dic["cA"] as? String ?? ""
        self.cB = dic["cB"] as? String ?? ""
        self.cC = dic["cC"] as? String ?? ""
        self.cD = dic["cD"] as? String ?? ""
        self.cans = dic["cans"] as? String ?? ""
        self.comment = dic["comment"] as? String ?? ""
    }
}
