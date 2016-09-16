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
    var userIsInTheMiddleOfTypingANumber = false
    var operationSymbol = ""
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInTheMiddleOfTypingANumber)
        {
            if(digit == ".")
            {
                if(display.text!.containsString((".")))
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
        let operation = sender.currentTitle!
        if(userIsInTheMiddleOfTypingANumber)
        {
            enter();
        }
        
        switch  operation{
            case "✖️":
                operationSymbol = "✖️"
                performOperation {$0 * $1}
                break
            case "➗":
                operationSymbol = "➗"
                performOperation {$0 / $1}
                break
            case "➕":
                operationSymbol = "➕"
                performOperation {$0 + $1}
                break
            case "➖":
                operationSymbol = "➖"
                performOperation {$0 - $1}
                break
            case "cos":
                operationSymbol = "cos"
                performOperationOneVariable {cos($0)}
                break
            case "sin":
                operationSymbol = "sin"
                performOperationOneVariable {sin($0)}
                break
            case "√":
                operationSymbol = "√"
                performOperationOneVariable {sqrt($0)}
                break
            case "C":
                displayValue = 0
                history.text = ""
                operandStack.removeAll()
                break
            case "⊓":
                operationSymbol = "⊓"
                displayValue = M_PI
                break
            default:
                break
        }
    }
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        historyValue = "\(displayValue)"
        operandStack.append(displayValue)
    }
    
    func multiply(num1: Double, num2:Double) -> Double
    {
        return num1 * num2
    }
    
    func performOperation(operation: (Double, Double) -> Double)
    {
        if(operandStack.count >= 2)
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast());
            historyValue = "\(operationSymbol) = "
            enter()
        }
    }
    
    func performOperationOneVariable(operation: Double -> Double)
    {
        if(operandStack.count >= 1)
        {
            displayValue = operation(operandStack.removeLast());
            historyValue = "\(operationSymbol) = "
            enter()
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    var historyValue: String {
        get {
            return history.text!
        }
        
        set {
            history.text = "\(history.text!) \(newValue)"
        }
    }
    
}