//
//  BMI.swift
//  BMI Calculator
//
//  Created by Joshua on 2021-01-28.
//  Inspired by Angela Yu from the London App Brewery
//  Link: https://www.google.com/ca
//

import UIKit

// Define a BMI struct with its values
struct BMI {
    let classification: WeightClass
    let value: Float
    let advice: String
    let symbol: String
    let color: UIColor
}

enum WeightClass {
    case underweight
    case healthy
    case overweight
    case obese
    case extremelyObese
    case unknown
}
