//
//  DetailView.swift
//  My BMI
//
//  Created by Joshua on 2021-04-23.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var bmi: BMICalculator
    @State var isHeightMetric = true
    @State var isWeightMetric = true
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                // Background
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    
                    // Dismiss popover button
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "x.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: Heading
                    VStack(alignment: .leading) {
                        Text("Your BMI Table")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        // MARK: Your Overview
                        HStack {
                            
                            VStack(alignment: .leading) {
                                Image(systemName: "arrow.up.and.down")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .opacity(0.5)
                                    Text("HEIGHT")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("\(getHeight(cm: bmi.height, isMetric: isHeightMetric))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            }
                            .onTapGesture { isHeightMetric.toggle() }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Image(systemName: "scalemass")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .opacity(0.5)
                                    Text("WEIGHT")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                Text("\(getWeight(kg: bmi.weight, isMetric: isWeightMetric, indicator: true))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            }
                            .onTapGesture { isWeightMetric.toggle() }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Image(systemName: "figure.stand")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .opacity(0.5)
                                    Text("BMI")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                Text("\(bmi.getBMIValue())")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(getColor()))
                            }
                        }.padding(.vertical)
                    }
                    
                    Spacer()
                    
                    Group {
                        VStack(alignment: .leading) {
                            Text("UNDERWEIGHT")
                                .font(.headline)
                                .foregroundColor(Color(UIColor.systemBlue))
                            Text("Below \(getWeight(kg: bmi.reverseBMI(targetBMI: 18.5), isMetric: isWeightMetric, indicator: true))")
                                .font(.title3)
                                .foregroundColor(Color(UIColor.systemBlue))
                        }.padding(.vertical, 5)
                        VStack(alignment: .leading) {
                            Text("HEALTHY")
                                .font(.headline)
                                .foregroundColor(Color(UIColor.systemGreen))
                            Text("Between \(getWeight(kg: bmi.reverseBMI(targetBMI: 18.5), isMetric: isWeightMetric, indicator: false)) and \(getWeight(kg: bmi.reverseBMI(targetBMI: 25), isMetric: isWeightMetric, indicator: true))")
                                .font(.title3)
                                .foregroundColor(Color(UIColor.systemGreen))
                        }.padding(.vertical, 5)
                        VStack(alignment: .leading) {
                            Text("OVERWEIGHT")
                                .font(.headline)
                                .foregroundColor(Color(UIColor.systemOrange))
                            Text("Between \(getWeight(kg: bmi.reverseBMI(targetBMI: 25), isMetric: isWeightMetric, indicator: false)) and \(getWeight(kg: bmi.reverseBMI(targetBMI: 30), isMetric: isWeightMetric, indicator: true))")
                                .font(.title3)
                                .foregroundColor(Color(UIColor.systemOrange))
                        }.padding(.vertical, 5)
                        VStack(alignment: .leading) {
                            Text("OBESE")
                                .font(.headline)
                                .foregroundColor(Color(UIColor.systemRed))
                            Text("Between \(getWeight(kg: bmi.reverseBMI(targetBMI: 30), isMetric: isWeightMetric, indicator: false)) and \(getWeight(kg: bmi.reverseBMI(targetBMI: 40), isMetric: isWeightMetric, indicator: true))")
                                .font(.title3)
                                .foregroundColor(Color(UIColor.systemRed))
                        }.padding(.vertical, 5)
                        VStack(alignment: .leading) {
                            Text("EXTREMELY OBESE")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Over \(getWeight(kg: bmi.reverseBMI(targetBMI: 40), isMetric: isWeightMetric, indicator: true))")
                                .font(.title3)
                                .foregroundColor(.gray)
                        }.padding(.vertical, 5)
                    }.onTapGesture { isWeightMetric.toggle() }
                    
                    Spacer()
                    
                }.padding(.all, 30)
            }
        }
    }
    
    func getColor() -> UIColor {
        var color = bmi.getColor()
        if color == .black { color = .white }
        return color
    }
}

// MARK: Previews
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(bmi: BMICalculator(height: 120.0, weight: 150.0))
            .previewDevice("iPhone 12")
    }
}
