//
//  Calculator.swift
//  Calculator
//
//  Created by hirosawak on 2015/06/05.
//  Copyright (c) 2015年 hirosawak. All rights reserved.
//

import UIKit

class Calculator {
    
    var temp : Double = 0.0
    var status : Int = 0
    var meloStatus : Bool = false

    /*
    1 : +
    2 : -
    3 : *
    4 : /
    5 : ^
    */
    
    func setTemp(num:Double){
        
        temp = num
    }
    
    func add(num1 : Double)->Double{
        return temp + num1;
    }
    
    func sub(num1 : Double)->Double{
        return temp * num1;
    }
    
    func mlt(num1 : Double)->Double{
        return temp * num1;
    }
    
    func div(num1 : Double)->Double{
        return temp / num1;
    }
    
    func pow(num1 : Int)->Double{
        var num2 : Double = 1.0
        for i in 0..<num1 {
            num2 = num2 * temp
        }
        return num2
    }

}
