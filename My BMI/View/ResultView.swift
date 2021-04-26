//
//  ResultView.swift
//  My BMI
//
//  Created by Joshua on 2021-03-25.
//

import SwiftUI

struct ResultView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var bmi: BMICalculator
    @State var isHeightMetric = true
    @State var isWeightMetric = true
    @State var showModal = false
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                // Background
                Color(.black)
                    .edgesIgnoringSafeArea(.all)
                Color(bmi.getColor())
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                
                VStack {
                    
                    // Dismiss popover button
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "x.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .opacity(0.5)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: Value
                    Text("\(bmi.getBMIValue())")
                        .font(Font.system(size: 80, design: .rounded).weight(.heavy))
                        .foregroundColor(.white)
                    //                    Text("kg / m²")
                    //                        .font(.title)
                    //                        .fontWeight(.regular)
                    //                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    
                    // MARK: Indicator & Arrow
                    let customWidth = geo.size.width / 1.5
                    
                    ZStack(alignment: .leading) {
                        Rectangle().frame(width: customWidth, height: 20)
                            .foregroundColor(Color(.black).opacity(0.5))
                        Rectangle().frame(width: (40/50)*customWidth, height: 20)
                            .foregroundColor(.red)
                        Rectangle().frame(width: (30/50)*customWidth, height: 20)
                            .foregroundColor(.orange)
                        Rectangle().frame(width: (25/50)*customWidth, height: 20)
                            .foregroundColor(.green)
                        Rectangle().frame(width: (19/50)*customWidth, height: 20)
                            .foregroundColor(.blue)
                    }
                    .cornerRadius(45.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(Color.white, lineWidth: 4)
                    )
                    
                    if bmi.getBMIValue() < 50 {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.leading, bmi.getPadding(availableSpace: customWidth))
                            .frame(width: customWidth, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading) {
                        
                        // MARK: Description
                        HStack {
                            Image(systemName: bmi.getSymbol())
                                .font(.title)
                                .foregroundColor(.white)
                                .opacity(0.5)
                                .frame(width: 50)
                            Text(bmi.getAdvice())
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }.padding(.vertical)
                        
                        // MARK: Goal
                        if bmi.getClassification() != .healthy {
                            let targetWeight = bmi.determineTargetWeight()
                            HStack {
                                Image(systemName: "arrow.forward")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                                    .frame(width: 50)
                                Group {
                                    Text("\(targetWeight.type) ") +
                                        Text("\(getWeight(kg: targetWeight.healthyMinimum, isMetric: isWeightMetric, indicator: false))").bold() +
                                        Text(" to ") +
                                        Text("\(getWeight(kg: targetWeight.healthyMaximum, isMetric: isWeightMetric, indicator: true))").bold() +
                                        Text(".")
                                }.font(.title2)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            }.onTapGesture { isWeightMetric.toggle() }
                        }
                    }
                    
                    Spacer()
                    
                    Group {
                        
                        // MARK: My BMI Table Button
                        Button(action: {
                            self.showModal = true
                        }) {
                            ZStack {
                                Color(.white).opacity(0.25)
                                Text("View My BMI Table")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(maxWidth: 500, maxHeight: 70)
                            .cornerRadius(15.0)
                        }.sheet(isPresented: $showModal) {
                            DetailView(bmi: bmi)
                        }
                        
                        // MARK: Recalculate Button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            ZStack {
                                Color(.white).opacity(0.25)
                                Text("Recalculate")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .frame(maxWidth: 500, maxHeight: 70)
                            .cornerRadius(15.0)
                        }
                    }.padding(.bottom)
                }.padding()
            }
        }
    }
}

// MARK: Previews
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(bmi: BMICalculator(height: 120.0, weight: 150.0))
            .previewDevice("iPhone 12")
    }
}
