//
//  ViewController.swift
//  Calculator
//
//  Created by hirosawak on 2015/06/04.
//  Copyright (c) 2015年 hirosawak. All rights reserved.
//

import UIKit
import QuartzCore

class StringNumberHandler{
    
    class func isHandlingInt(origString:String)->Bool{
        
        for ch in origString{
            if(toString(ch) == "."){
                return false
            }
        }
        return true
    }
    
    class func toInt(origString:String)->Int{
        
        if let resultInt = origString.toInt(){
            return resultInt
        }
        return 0
    }
    
    class func toDouble(origString:String)->Double{
        
        return  (origString as NSString).doubleValue
    }
}

class ViewController: UIViewController {
    
    var viewCount : Int = 0
    
    var temp : Double = 0
    var castResult : Double = 0
    
    var status : String = ""
    var operatorStatus : Bool = false
    var stringStatus : Bool = false
    var stackStatus : Bool = false
    
    /*
    1 : +
    2 : -
    3 : *
    4 : /
    5 : ^
    */
    
    let xBtnCont = 5
    let yBtnCont = 4
    
    let BtnMargin : Double = 10
    
    let screenWidth  : Double = Double(UIScreen.mainScreen().bounds.size.width)
    let screenHeight : Double = Double(UIScreen.mainScreen().bounds.size.height)
    
    var editBox : UILabel!
    var statusBox : UILabel!
    
    var ScrollView : UILabel!
    var ScrollStatusView : UILabel!
    
    var myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexColor(0x000000, alpha: 1.0)
        
        var LabelYPos : CGFloat = CGFloat((screenHeight) / 2 - 60)
        var NextLabelYPos : CGFloat = LabelYPos - CGFloat(60 + BtnMargin)

        setScrollView()
        editBox = UILabel(frame: CGRectMake(CGFloat(BtnMargin + 60), LabelYPos, CGFloat(screenWidth-BtnMargin*2-60), 60))
        editBox.textAlignment = NSTextAlignment.Right
        editBox.backgroundColor = UIColor.whiteColor()
        editBox.text = "0"
        self.view.addSubview(editBox)
        editBox.font = UIFont(name: "LetsgoDigital-Regular",size: 50)

        statusBox = UILabel(frame: CGRectMake(CGFloat(BtnMargin), LabelYPos, 60, 60))
        statusBox.textAlignment = NSTextAlignment.Center
        statusBox.backgroundColor = UIColor.whiteColor()
        statusBox.text = ""
        self.view.addSubview(statusBox)
        statusBox.font = UIFont(name: "",size: 50)
        
        let title:[String] = [
            "7" , "8" , "9" , "%" ,"C",
            "4" , "5" , "6" , "×" ,"÷",
            "1" , "2" , "3" , "+" ,"-",
            "0" , "00", "." , "=" ,"秘"
        ]
        
        var NumBtnWidht  = (screenWidth - (BtnMargin * Double(xBtnCont+1)))/Double(xBtnCont)
        var NumBtnHeight = (screenHeight/2 - (BtnMargin * Double(yBtnCont+1)))/Double(yBtnCont)
        
        for x in 0..<xBtnCont {
            for y in 0..<yBtnCont {
                var CountBtn = y * xBtnCont + x
                var button = UIButton()
                var xPosition = NumBtnWidht * Double(x) + BtnMargin * Double(x + 1)
                var yPosition = NumBtnHeight * Double(y) + BtnMargin * Double(y + 1) + (screenHeight)/2
                
                button.frame = CGRect(x: xPosition,y: yPosition,width: NumBtnWidht,height: NumBtnHeight)
                
                var gra = CAGradientLayer()
                gra.frame = button.bounds
                
                var newColor1 = UIColor.hexColor(0x666666,alpha: 1.0).CGColor
                var newColor2 = UIColor.hexColor(0xAAAAAA,alpha: 1.0).CGColor

                var arrayColor : [CGColor] = [newColor1,newColor2]
                //button.backgroundColor = UIColor.greenColor()
                //button.backgroundColor = UIColor.hexColor(0x00FFFF,alpha: 1.0)
                gra.colors = arrayColor
                button.layer.insertSublayer(gra, atIndex: 0)
                button.setTitle(title[CountBtn], forState: UIControlState.Normal)
                button.setTitleColor(UIColor.hexColor(0x003300,alpha: 1.0), forState: .Highlighted)
                
                button.layer.masksToBounds = true
                button.layer.cornerRadius = 5.0
                
                self.view.addSubview(button)
                
                button.layer.shadowColor = UIColor.grayColor().CGColor
                // 濃さを指定
                button.layer.shadowOpacity = 5000
                // 影までの距離を指定
                button.layer.shadowOffset = CGSizeMake(10, 10)

                
                button.addTarget(self, action: "pushBtn:", forControlEvents: .TouchUpInside)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tempSet(){
        var num : Double
        
        if stackStatus {
            return
        }else{
            num = (editBox.text! as NSString).doubleValue
        }
        
        if temp == 0 && status == ""{
            temp = num
        }else{
            switch status {
            case "+" :
                temp = temp + num
            case "-" :
                temp = temp - num
            case "×" :
                temp = temp * num
            case "÷" :
                if num != 0 {
                    temp = temp / num
                }else{
                    if temp == 0 {
                        setError()
                        editBox.text = "ERROR"
                        statusBox.text = ""
                        stringStatus = true
                        return
                    } else {
                        setError()
                        editBox.text = "INFINITI"
                        statusBox.text = ""
                        stringStatus = true
                        return
                    }
                }
            case "%" :
                temp = temp / num * 100
            default :
                temp = num
            }
            stackStatus = true
        }
        
        println(temp)
        addScroll()
        editBox.text = checkNum(String(stringInterpolationSegment: temp)) as String
        operatorStatus = true
    }
    
    func pushOperator(Operator:String){
        tempSet()
        if !stringStatus {
            status = Operator
            statusBox.text = status
        }
    }
    
    func add(num : Double)->Double{
        return temp + num
    }
    
    func sub(num : Double)->Double{
        return temp - num
    }
    
    func mlt(num : Double)->Double{
        return temp * num
    }
    
    func div(num : Double)->Double{
        return temp / num
    }
    
    func pow(num : Int)->Double{
        
        var num1 : Double = 1.0
        for i in 0..<num {
            num1 = num1 * temp
        }
        return num1
    }
    
    func pushClear(){
        status = ""
        temp = 0
        stringStatus = false
        editBox.text = "0"
        statusBox.text = ""
        myScrollView.removeFromSuperview()
        viewCount = 0
        setScrollView()
    }
    
    func equal(){
        var num : Double = (editBox.text! as NSString).doubleValue
        var mess : String
        statusBox.text = "="
        
        println("ステータス:\(status)")
        switch status {
        case "+"  :
            mess = String(stringInterpolationSegment: add(num))
        case "-"  :
            mess = String(stringInterpolationSegment: sub(num))
        case "×"  :
            mess = String(stringInterpolationSegment: mlt(num))
        case "÷"  :
            if num != 0 {
                mess = String(stringInterpolationSegment: div(num))
            }else{
                if temp == 0 {
                    mess = "0"
                } else {
                    mess = "INFINITI"
                    stringStatus = true
                }
            }
        case "%"  :
            if num != 0 {
                mess = String(stringInterpolationSegment: div(num)*100)+"%"
            }else{
                if temp == 0 {
                    mess = "0"
                } else {
                    mess = "INFINITI"
                    stringStatus = true
                }
            }
        case "秘"  :
            mess = String(stringInterpolationSegment: pow(Int(num)))
        default :
            mess = String(stringInterpolationSegment: num)
        }
        stackStatus = false
        editBox.text = checkNum(mess) as String
        status = "="
        temp = (editBox.text! as NSString).doubleValue
    }

    func pushBtn(sender: UIButton){

        if stringStatus == false {
            switch(sender.currentTitle!){
            case "1","2","3","4","5","6","7","8","9","0","00","." :
                stackStatus = false
                if operatorStatus {
                    editBox.text = "0"
                    operatorStatus = false
                }
                
                var searchString : Bool = stringJudge(editBox.text!)
                
                //小数点以外の文字が入ってない
                if !searchString {
                    //INT型にできなかった時
                    if(editBox.text?.toInt() == nil){
                        if sender.currentTitle! != "." {
                            editBox.text = editBox.text! + sender.currentTitle!
                            println("これ\(editBox.text?.toInt())")
                        }
                    }else if editBox.text?.toInt() == 0 {
                    //0に変換できた時
                        if sender.currentTitle! == "0" || sender.currentTitle! == "00" {
                        //0もしくは00押されたとき
                            //何も追加しない
                            println("どれ\(editBox.text?.toInt())")
                        }else if sender.currentTitle! == "." {
                        //点を押された時
                            // "0" + "."
                            editBox.text = editBox.text! + sender.currentTitle!
                        } else {
                        //それ以外を押された時
                            editBox.text = sender.currentTitle!
                        }
                    }else{
                    //0以外の数字にできた時
                        editBox.text = editBox.text! + sender.currentTitle!
                    }
                    setEdidBox(editBox.text!)
                }else{
                //小数点以外の文字が入ってた場合
                    setError()
                }
                
            case "+","-","×","÷","%" :
                var searchString : Bool = stringJudge(editBox.text!)
                //小数点以外の文字が入ってない
                if !searchString {
                    pushOperator(sender.currentTitle!)
                }else{
                //小数点以外の文字が入ってた場合
                    setError()
                }
            case "=" :
                if viewCount < 50 && status != "="{
                    addScroll()
                }
                var searchString : Bool = stringJudge(editBox.text!)
                //小数点以外の文字が入ってない
                if !searchString {
                    equal()
                }else{
                    //小数点以外の文字が入ってた場合
                    setError()
                }
                setEdidBox(editBox.text!)
            case "秘" :
                editBox.text = "/*"
            default :
                pushClear()
            }
            
        }else{
            if sender.currentTitle! == "C" {
                pushClear()
            }
        }
    }

    func setEditBoxToString(text:String){
        //どちらの値も整数なら
        if(StringNumberHandler.isHandlingInt(text)){
            //StringNumberHandlerのメソッドtoIntを用いている
            var intResult = StringNumberHandler.toInt(text)
            editBox.text = toString(intResult)
        } else {
            var doubleA = StringNumberHandler.toDouble(text)
            editBox.text = toString(doubleA)
        }
    }
    
    func checkNum(text:String)->NSString{
        
        var ret : String = ""
        var numFlg : Bool = false
        for char in text {
            if numFlg {
                if char != "0" {
                    return text
                }
            }else{
                if char == "." {
                    numFlg = true
                }else{
                    ret = ret + String(char)
                }
            }
            
        }
        return ret
    }
    
    func setError(){
        pushClear()
        stringStatus = true
        stackStatus = false
        statusBox.text = ""
        editBox.text = "Error"
    }
    
    func stringJudge(text : String) -> Bool {
        var searchString : Bool = false
        
        //文字が入ってるかの判断
        for char in text {
            switch char {
            case "1","2","3","4","5","6","7","8","9","0","." :
                searchString = false
            default:
                searchString = true
                break
            }
        }
        return searchString
    }
    
    func setEdidBox(text:String){
        if (text as NSString).length > 11 {
            setError()
            statusBox.text = "E"
            var ret : String = ""
            for char in text {
                ret = ret + String(char)
                if count(ret) > 10 {
                    editBox.text = ret
                    return
                }
            }
        }else{
            editBox.text = text
        }
    }
    
    func setScrollView(){
        // ScrollViewを生成.
        myScrollView = UIScrollView()
        // ScrollViewの大きさを設定する.
        myScrollView.frame = CGRectMake(
            CGFloat(BtnMargin),
            CGFloat(BtnMargin),
            CGFloat(screenWidth-BtnMargin*2),
            CGFloat((screenHeight) / 2 - 60 - BtnMargin*2)
        )
        myScrollView.backgroundColor = UIColor.grayColor()
        myScrollView.contentSize = CGSizeMake(CGFloat(screenWidth-BtnMargin*2), 70)
        self.view.addSubview(myScrollView)
    }
    
    func addScroll(){
        var a = viewCount
        ScrollStatusView    = UILabel(frame: CGRectMake( 0, CGFloat((70) * a), 60, 60))
        ScrollView          = UILabel(frame: CGRectMake(60, CGFloat((70) * a), CGFloat(screenWidth-BtnMargin*2-60), 60))
        ScrollView.backgroundColor          = UIColor.whiteColor()
        ScrollStatusView.backgroundColor    = UIColor.whiteColor()
        ScrollView.text = editBox.text
        ScrollStatusView.text = statusBox.text
        ScrollView.textAlignment = NSTextAlignment.Right
        ScrollStatusView.textAlignment = NSTextAlignment.Center
        myScrollView.addSubview(ScrollView)
        myScrollView.addSubview(ScrollStatusView)
        
        myScrollView.contentSize = CGSizeMake(CGFloat(screenWidth-BtnMargin*2), CGFloat(70 * (a+1)))
        viewCount++
        
        if viewCount > 50 {
            
        }
    }
    
}

