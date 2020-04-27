//
//  EditEngageTimerOptionsView.swift
//  engage-timer-updated
//
//  Created by Adam Reed on 4/26/20.
//  Copyright © 2020 rdConcepts. All rights reserved.
//

import SwiftUI

struct EditEngageTimerOptionsView: View {
    
    @EnvironmentObject var engageTimer: EngageTimer
    @State var round = 1
    
    var body: some View {
    NavigationView {
        VStack{
            Form {
                HStack {
                Text("Rounds")
                 Spacer()
                Text("\(self.engageTimer.round)")
                Stepper("", onIncrement: {
                                   self.engageTimer.round += 1
                                }, onDecrement: {
                                   self.engageTimer.round -= 1
                    }).labelsHidden().padding()
                }
                
                HStack {
                Text("Time")
                Spacer()
                    Text("\(self.engageTimer.timeStringDisplay)")
                Stepper("", onIncrement: {
                                   self.engageTimer.time += 1
                    self.engageTimer.timeStringDisplay = self.engageTimer.integerToString(number: self.engageTimer.time)
                                }, onDecrement: {
                                   self.engageTimer.time -= 1
                                    self.engageTimer.timeStringDisplay = self.engageTimer.integerToString(number: self.engageTimer.time)
                    }).labelsHidden().padding()
                    }
                
                HStack {
                Text("Rest")
                Spacer()
                    Text("\(self.engageTimer.restStringDisplay)")
                Stepper("", onIncrement: {
                                   self.engageTimer.rest += 1
                    self.engageTimer.restStringDisplay = self.engageTimer.integerToString(number: self.engageTimer.rest)
                                }, onDecrement: {
                                   self.engageTimer.rest -= 1
                                    self.engageTimer.restStringDisplay = self.engageTimer.integerToString(number: self.engageTimer.rest)
                    }).labelsHidden().padding()
                    }
                    
                HStack {
                Text("Noise Count")
                Spacer()
                    Text("\(self.engageTimer.noiseTotal)")
                Stepper("", onIncrement: {
                                   self.engageTimer.noiseTotal += 1
                                }, onDecrement: {
                                   self.engageTimer.noiseTotal -= 1
                    }).labelsHidden().padding()
                    }
                

            .navigationBarTitle("Edit Options")

        }
        Text("Swipe Down To Save").padding()
        } // Form Closure
        } // Main VStack Closure
    } // Nav CLosure
} // View Closure

struct EditEngageTimerOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        EditEngageTimerOptionsView().environmentObject(EngageTimer())
    }
}
