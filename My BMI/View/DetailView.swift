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
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .opacity(0.5)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Title
                    VStack(alignment: .leading) {
                        Text("Your BMI Table")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        
                        // Height, Weight, BMI overview
                        HStack {
                            VStack(alignment: .leading) {
                                Image(systemName: "arrow.up.and.down")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    Text("HEIGHT")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("\(getHeight(cm: bmi.height, isMetric: isHeightMetric))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            }.onTapGesture { isHeightMetric.toggle() }
                            Spacer()
                            VStack(alignment: .leading) {
                                Image(systemName: "scalemass")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    Text("WEIGHT")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                Text("\(getWeight(kg: bmi.weight, isMetric: isWeightMetric, indicator: true))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                            }.onTapGesture { isWeightMetric.toggle() }
                            Spacer()
                            VStack(alignment: .leading) {
                                Image(systemName: "figure.stand")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    Text("BMI")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                Text("\(bmi.getBMIValue())")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(getColor()))
                                        .onTapGesture {
                                            isHeightMetric.toggle()
                                        }
                            }
                        }.padding(.vertical)
                    }
                    
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
