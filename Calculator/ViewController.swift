//
//  ViewController.swift
//  Calculator
//
//  Created by Brock D'Amico on 9/13/16.
//  Copyright © 2016 Brock D'Amico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    var brain = CalculatorBrain()
    var userIsInTheMiddleOfTypingANumber = false
    var operationSymbol = ""
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInTheMiddleOfTypingANumber)
        {
            if(digit == ".")
            {
                if(display.text! == ".")
                {
                    
                } else {
                    display.text = display.text! + digit
                }
            } else {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }else{
                displayValue = 0
                history.text = ""
            }
        }
    }
    
    @IBAction func mRead(sender: AnyObject) {
        if(brain.getMDisplay() == nil || brain.getMDisplay()!.isEmpty)
        {
            displayValue = brain.pushOperand("M")
        }
    }
    
    @IBAction func mSet(sender: AnyObject) {
        brain.saveToVariableValues("M", value: displayValue!)
    }
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        }else{
            displayValue = nil
        }
        userIsInTheMiddleOfTypingANumber = false
    }
    
    func multiply(num1: Double, num2:Double) -> Double
    {
        return num1 * num2
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue!)"
            if(!brain.description.isEmpty)
            {
                history.text = " \(brain.description) ="
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}
