//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Brock D'Amico on 9/29/16.
//  Copyright © 2016 Brock D'Amico. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    var pastSymbol = ""
    var displayFinal = ""

    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case ClearOperation(String)
        case PiOperation((String))
        var description: String{
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .PiOperation:
                    return "⊓"
                case .ClearOperation:
                    return "C"
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    var variableValues = [String:Double]()
    
    init () {
        func learnOps(op: Op) {
            knownOps[op.description] = op
        }
        learnOps(Op.BinaryOperation("✖️", *))
        learnOps(Op.BinaryOperation("➗"){$1 / $0})
        learnOps(Op.BinaryOperation("➕", +))
        learnOps(Op.BinaryOperation("➖"){$1 - $0})
        learnOps(Op.UnaryOperation("cos", cos))
        learnOps(Op.UnaryOperation("sin", sin))
        learnOps(Op.UnaryOperation("√", sqrt))
        learnOps(Op.PiOperation("⊓"))
        learnOps(Op.ClearOperation("C"))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch(op) {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .PiOperation:
                return (M_PI, remainingOps)
            case .ClearOperation(_):
                clear()
            }
        }
        return (nil, ops)
    }
    
    private func history(current: String, ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch(op) {
            case .Operand(let operand):
                if(displayFinal.isEmpty)
                {
                    displayFinal = "\(operand)"
                }
                return (displayFinal, remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = evaluate(remainingOps)
                if operandEvaluation.result != nil {
                    displayFinal = "\(symbol)(\((displayFinal)))"
                    return (displayFinal, remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if op2Evaluation.result != nil {
                        displayFinal = "\(symbol) \(operand1)"
                        return (displayFinal, op2Evaluation.remainingOps)
                    }
                }
            case .PiOperation:
                return (displayFinal, remainingOps)
            case .ClearOperation(_):
                clear()
            }
        }
        return (nil, ops)
    }

    
    //save variables to variable stack
    func saveToVariableValues(name: String, value: Double)
    {
        variableValues[name] = value
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    var description: String {
         let (final, _) = history(String(), ops: opStack)
        if(final == nil)
        {
            return ""
        } else {
         return final!
        }
    }
    
    func pushOperand(operand: String) -> Double? {
           opStack.append(Op.Operand(variableValues[operand]!))
            return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func getMDisplay() -> String? {
        return "\(variableValues["M"])"
    }
 
    //function for clearing the console
    func clear() -> Double? {
        opStack.removeAll()
        displayFinal = ""
        return evaluate()
    }
}
