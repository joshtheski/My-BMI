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
                    
                    Spacer()
                    
                    
                    // MARK: Visual Representation
                    let customWidth = geo.size.width / 1.5
                    
                    // Progress bar with colors
                    ZStack(alignment: .leading) {
                        Rectangle().frame(width: customWidth, height: 20)
                            .foregroundColor(Color(.black).opacity(0.5))
                        Rectangle().frame(width: (40/50)*customWidth, height: 20)
                            .foregroundColor(.red)
                        Rectangle().frame(width: (30/50)*customWidth, height: 20)
                            .foregroundColor(.orange)
                        Rectangle().frame(width: (25/50)*customWidth, height: 20)
                            .foregroundColor(.green)
                        Rectangle().frame(width: (18.5/50)*customWidth, height: 20)
                            .foregroundColor(.blue)
                    }
                    .cornerRadius(45.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 45)
                            .stroke(Color.white, lineWidth: 4)
                    )
                    
                    // Arrow idicator
                    if bmi.getBMIValue() < 50 {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.leading, bmi.getPadding(availableSpace: customWidth))
                            .frame(width: customWidth, alignment: .leading)
                    }
                    
                    // MARK: Description
                    VStack(alignment: .leading) {
                        
                        // Advice
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
                        
                        // Weight goal
                        if bmi.getClassification() != .healthy {
                            let goal = bmi.determineWeightLossGoal()
                            HStack {
                                Image(systemName: "arrow.forward")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .opacity(0.5)
                                    .frame(width: 50)
                                Group {
                                    Text("\(goal.type) at least ") +
                                    Text("\(getWeight(kg: goal.healthyMinimum, isMetric: isWeightMetric, indicator: true))").bold() +
                                    Text(".")
                                }.font(.title2)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            }.onTapGesture { isWeightMetric.toggle() }
                        }
                    }
                    
                    // MARK: View BMI Table
                    Button(action: {
                        self.showModal = true
                    }) {
                        HStack {
                            Image(systemName: "tablecells.badge.ellipsis")
                                .font(.title3)
                            Text("My BMI Table")
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    .sheet(isPresented: $showModal) {
                        DetailView(bmi: bmi, isHeightMetric: isHeightMetric, isWeightMetric: isWeightMetric)
                    }
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.25))
                    )
                    .padding()
                    
                    Spacer()
                    
                        
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
