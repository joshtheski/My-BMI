//
//  ContentView.swift
//  My BMI
//
//  Created by Joshua on 2021-03-23.
//

import SwiftUI

struct BMIView: View {
    
    @State var bmi = BMICalculator(height: 0.0, weight: 0.0)
    @State var isHeightMetric = true
    @State var isWeightMetric = true
    @State var isPopoverPresented = false
    @State var isChanged = false
    
    var body: some View {
        
        ZStack {
            
            // MARK: Background
            Color(.black)
                .edgesIgnoringSafeArea(.all)
            AnimatedBackground()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 25)
                .scaleEffect(1.2)
                .opacity(0.9) // slightly dim to improve contrast with text
            
            VStack {
                
                Spacer()
                
                // MARK: Top Heading
                // When app opens up...
                if !isChanged {
                Text("Calculate Your BMI")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("For best results, please be\nas accurate as possible.")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
                    .padding()
                }
                // As soon as you move a slider...
                else if isChanged {
                    // Dynamic person icon
                    Image(systemName: "figure.stand")
                        .font(.system(size: determineHeight(), weight: determineWeight()))
                        .frame(width: 200, height: 200, alignment: .bottom)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // MARK: Height Slider
                VStack {
                    
                    HStack {
                        Text("Height")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        Spacer()
                        Text("\(getHeight(cm: bmi.height, isMetric: isHeightMetric))")
                            .font(Font.system(.largeTitle, design: .rounded).weight(.heavy))
                            .foregroundColor(.white)
                            .onTapGesture { isHeightMetric.toggle() } // tap to change
                    }.padding(.horizontal)
                    
                    Slider(value: $bmi.height, in: 120...220, onEditingChanged: { _ in
                        if self.isChanged == false { self.isChanged = true }
                    })
                        .accentColor(Color("purpleHighlight"))
                        .padding()
                        .onTapGesture { isChanged = true }
                        .onAppear {
                            if(self.bmi.height < 1) {
                                self.bmi.height = 170
                            }
                        }
                }
                
                // MARK: Weight Slider
                VStack {
                    
                    HStack {
                        Text("Weight")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        Spacer()
                        Text("\(getWeight(kg: bmi.weight, isMetric: isWeightMetric, indicator: true))")
                            .font(Font.system(.largeTitle, design: .rounded).weight(.heavy))
                            .foregroundColor(.white)
                            .onTapGesture { isWeightMetric.toggle() } // tap to change
                    }.padding(.horizontal)
                    
                    Slider(value: $bmi.weight, in: 20...150, onEditingChanged: { _ in
                        if self.isChanged == false { self.isChanged = true }
                    })
                        .accentColor(Color("purpleHighlight"))
                        .padding()
                        .onAppear {
                            if(self.bmi.weight < 1) {
                                self.bmi.weight = 85
                            }
                        }
                }
                
                // MARK: Calculate Button
                Button(action: {
                    bmi.calculateBMI(height: bmi.height, weight: bmi.weight)
                    self.isPopoverPresented.toggle()
                }) {
                    ZStack {
                        Color("purpleHighlight")
                            .opacity(0.8)
                        Text("Calculate")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(maxWidth: 500, maxHeight: 70)
                    .cornerRadius(15.0)
                    .padding(.vertical)
                }
                .sheet(isPresented: $isPopoverPresented, content: {
                    ResultView(bmi: bmi, isHeightMetric: isHeightMetric, isWeightMetric: isWeightMetric)
                })
            }.padding()
        }
    }
    
    // Dynamically determine height of symbol based on height slider
    func determineHeight() -> CGFloat {
        return CGFloat(self.bmi.height / 1.2) // fluid transition
    }
    
    // Dynamically determine weight of symbol based on weight slider
    func determineWeight() -> Font.Weight {
        switch self.bmi.weight {
        case 0 ..< 30:
            return .ultraLight
        case 30 ..< 45:
            return .thin
        case 45 ..< 60:
            return .light
        case 60 ..< 75:
            return .regular
        case 75 ..< 90:
            return .medium
        case 90 ..< 105:
            return .semibold
        case 105 ..< 120:
            return .bold
        case 120 ..< 135:
            return .heavy
        default:
            return .black
        }
    }
}

// Custom animated background
struct AnimatedBackground: View {
    
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color(.black), Color(.black), Color("purpleDark"), Color("purpleLight"), Color("purpleHighlight")]
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 10).repeatForever())
            .onReceive(timer, perform: { _ in
                self.start = UnitPoint(x: 4, y: 0)
                self.end = UnitPoint(x: 0, y: 2)
                self.start = UnitPoint(x: -4, y: 20)
                self.start = UnitPoint(x: 4, y: 0)
            })
    }
}

// Get height in centimetres or feet and inches
func getHeight(cm: Float, isMetric: Bool) -> String {
    if isMetric {
        return "\(String(format: "%.0f", cm)) cm"
    } else {
        let feet = cm * 0.0328084
        let feetDisplay = Int(floor(feet))
        let feetRemainder: Float = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRemainder * 12))
        return "\(feetDisplay)' \(inches)\""
    }
}

// Get weight in kilograms or pounds
func getWeight(kg: Float, isMetric: Bool, indicator: Bool) -> String {
    var weightString: String
    if isMetric {
        weightString = String(format: "%.0f", kg)
        if indicator { weightString += " kg" }
    } else {
        let lbs = kg * 2.205
        weightString = String(format: "%.0f", lbs)
        if indicator { weightString += " lbs" }
    }
    return weightString
}

// MARK: Previews
struct BMIView_Previews: PreviewProvider {
    static var previews: some View {
        BMIView()
            .previewDevice("iPhone 12")
    }
}
