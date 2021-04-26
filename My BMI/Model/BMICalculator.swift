//
//  BMI Calculator
//  My BMI
//
//  Created by Joshua on 2021-01-28.
// 

import Foundation
import SwiftUI

struct BMICalculator {
    
    var height: Float = 0.0 // default: cm
    var weight: Float = 0.0 // default: kg
    var bmi: BMI?
    
    mutating func calculateBMI(height: Float, weight: Float) {
        
        let heightInMetres = height / 100
        let bmiValue = weight / (heightInMetres * heightInMetres)
        
        if bmiValue < 18.5 {
            bmi = BMI(
                classification: .underweight,
                value: bmiValue,
                advice: "You are underweight.",
                symbol: "exclamationmark.circle",
                color: .systemBlue)
        } else if bmiValue < 25 {
            bmi = BMI(
                classification: .healthy,
                value: bmiValue,
                advice: "You are in a healthy BMI range.",
                symbol: "checkmark.seal",
                color: .systemGreen)
        } else if bmiValue < 30 {
            bmi = BMI(
                classification: .overweight,
                value: bmiValue,
                advice: "You are overweight.",
                symbol: "exclamationmark.circle",
                color: .systemOrange)
        } else if bmiValue < 40 {
            bmi = BMI(
                classification: .obese,
                value: bmiValue,
                advice: "You are obese.",
                symbol: "exclamationmark.triangle",
                color: .systemRed)
        } else {
            bmi = BMI(
                classification: .extremelyObese,
                value: bmiValue,
                advice: "You are extremely obese!",
                symbol: "exclamationmark.octagon",
                color: .black)
        }
    }
    
    // Get BMI symbol as String system icon name
    func getClassification() -> WeightClass {
        return bmi?.classification ?? .unknown
    }
    
    // Return BMI as formatted String
    func getBMIValue() -> String {
        let bmiToDecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiToDecimalPlace
    }
    
    // Get BMI advice as String
    func getAdvice() -> String {
        return bmi?.advice ?? "Please enter your height and weight to get a BMI result."
    }
    
    // Get BMI feature color as UIColor
    func getColor() -> UIColor {
        return bmi?.color ?? UIColor.black
    }
    
    // Get BMI symbol as String system icon name
    func getSymbol() -> String {
        return bmi?.symbol ?? "questionmark"
    }
    
    // Get BMI as Int
    func getPadding(availableSpace: CGFloat) -> CGFloat {
        let leadingPadding = (CGFloat(bmi?.value ?? 0.0) / 50) * availableSpace
        return leadingPadding - 10
    }
    
    // Determine a weight loss/gain goal based on BMI
    func determineWeightLossGoal() -> (healthyMinimum: Float, healthyMaximum: Float, type: String) {
        var min: Float = 0.0
        var max: Float = 0.0
        var type = ""
        switch bmi?.classification {
        case .underweight:
            min = reverseBMI(targetBMI: 18.5) - weight
            max = reverseBMI(targetBMI: 24.9) - weight
            type = "Gain"
        default:
            min = weight - reverseBMI(targetBMI: 24.9)
            max = weight - reverseBMI(targetBMI: 18.5)
            type = "Lose"
        }
        return (min, max, type)
    }
    
    // Determine a target weight based on a given BMI value
    func reverseBMI(targetBMI: Float) -> Float {
        let heightInMetres = height / 100 // m
        let targetWeight = targetBMI * (heightInMetres * heightInMetres) // BMI * (height^2)
        return targetWeight // kg
    }
    
    func getBMIValue() -> Float {
        return bmi?.value ?? 0.0
    }
}

//var globalBMI = BMICalculator()
