//
//  OnboardingScreenView.swift
//  engage-timer-updated
//
//  Created by Adam Reed on 5/26/20.
//  Copyright © 2020 rdConcepts. All rights reserved.
//

import SwiftUI

struct OnboardingScreenView: View {
    
    @State var step = 1
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea([.top,.bottom])
            
            // Main Body for Onboarding Screen
            VStack {
                Text("Thanks for downloading").padding(.top)
                Text("The Engage Timer").font(.title)
                    
                GeometryReader { gr in
                    HStack {
                        // 1st Explanation Body
                       VStack() {
                           Image("engage-icon-transparent").padding()
                        Text("Are you ready to get engaged with your workouts? The Engage Timer is a round timer that can simulate having a coach with you anywhere you go.")
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: gr.frame(in: .global).width - 40)
                            
                       }.frame(width: gr.frame(in: .global).width)
                        .animation(Animation.interpolatingSpring(stiffness: 40, damping: 10).delay(0.05))
                   
                   // 2nd Explanation Body
                       VStack(alignment: .center, spacing: 10) {
                        Image("gear")
                        Text("Rounds, Time & Rest").bold()
                        Text("Adjust the fully functional round timer to your number of rounds, time and rest.")
                            .fixedSize(horizontal: false, vertical: true)
                        Text("Random Element, Noise and Frequency").bold()
                        Text("To help create the feeling of engagement, adjust the random count total and interval, adjusting the min amount of time between counts. The Engage Timer randomizes this count between rounds.")
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: gr.frame(in: .global).width - 40)
            
                       }.frame(width: gr.frame(in: .global).width - 13)
                        .animation(Animation.interpolatingSpring(stiffness: 40, damping: 10).delay(0.05))
                       
                   // 3rd Explanation Body
                       VStack(alignment: .center) {
                        Text("Examples for Use").font(.title).bold()
                        Text("When the Engager Sounds Change From...")
                        HStack{
                            VStack {
                                Image("jumprope")
                                Text("Double jump during jump roping").fixedSize(horizontal: false, vertical: true)
                            }
                            VStack {
                                Image("running")
                                Text("Switch from sprinting to jogging.").fixedSize(horizontal: false, vertical: true)
                            }
                         VStack {
                             Image("shadowboxing")
                             Text("On the count block or strike").fixedSize(horizontal: false, vertical: true)
                         }
                            
                        }
                           
                        .animation(Animation.interpolatingSpring(stiffness: 40, damping: 10).delay(0.05))
                       }.frame(width: gr.frame(in: .global).width)
                        
                    } // Close HStack Group
                        // Formatting the main HStack Group
                        .multilineTextAlignment(.center)
                        // Controls placement of each group based on step variable
                        .frame(width: gr.frame(in: .global).width * 3)
                        //.frame(maxHeight: .infinity)
                        .offset(x: self.step == 1 ? gr.frame(in: .global).width : self.step == 2 ? 0 : -gr.frame(in: .global).width)
                    .animation(Animation.interpolatingSpring(stiffness: 40, damping: 10))
                }.edgesIgnoringSafeArea([.top, .bottom])
                .padding()
                
                    
                // Icons at bottom of page for scrolling instructions
                    HStack {
                        Button(action: {
                            self.step = 1
                        }) {
                            Image(systemName: "1.circle")
                                .padding()
                                .foregroundColor(.primary)
                                .scaleEffect(step == 1 ? 2 : 1.6)
                        }
                        
                        Button(action: {
                            self.step = 2
                        }) {
                            Image(systemName: "2.circle")
                                .padding()
                                .foregroundColor(.primary)
                                .scaleEffect(step == 2 ? 2 : 1.6)
                        }
                        
                        Button(action: {
                            self.step = 3
                        }) {
                            Image(systemName: "3.circle")
                                .padding()
                                .foregroundColor(.primary)
                                .scaleEffect(step == 3 ? 2 : 1.6)
                        }
                        

                    }
                
                // Button to close onboarding and get to the App.
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    print("Pressed Button")
                }) {
                    Text("Let's Go Already!")
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Capsule().stroke(lineWidth: 2))
                    .foregroundColor(.primary)
                }.padding()
                
            } // Close Main V-Stack
        } // Close Z-Stack
    } // Close Body View

} // Close OnboardingScreenView



struct OnboardingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreenView()
    }
}
