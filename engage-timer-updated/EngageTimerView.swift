//  Created by Adam Reed on 2/6/20.
//  Copyright © 2020 rdConcepts. All rights reserved.

// need to create persistence for the data

import SwiftUI
import GoogleMobileAds
import IntentsUI

struct EngageTimerView: View {
//Properties
// =====================================================
@EnvironmentObject var engageTimer: EngageTimer
@State var timer = Timer.publish(every: 1, on: .main, in: .common)

// State variable to bring up editing view
@State var showSheet = false
@State var sheetSelection = 1
@State var textSize = CGFloat(70)
@State var firsTimeOnScreen = UserDefaults.standard.bool(forKey: "firsTimeOnScreen")
    
@Environment(\.presentationMode) var presentationMode
    
// Admob
var interstitial:Interstitial
init() { self.interstitial = Interstitial() }
@State var interstitialCount = 0

    
// User Interface Views
// ======================================================
var body: some View {
    NavigationView {
        
        ZStack {
            // Setup backgound Color
            Color(.systemGray6).edgesIgnoringSafeArea([.top,.bottom])
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                         // Rounds Stack
                         HStack {
                             Text("Round").font(.largeTitle)
                             Spacer()
                            Text("\(self.engageTimer.round)").font(.custom("DS-Digital", size: self.textSize))
                             Text("OF")
                            Text("\(self.engageTimer.totalRounds)").font(.custom("DS-Digital", size: self.textSize))
                         }.padding().frame(height: geometry.size.height / 7)
                                 
                         // Time Remaining Stack
                         HStack {
                             Text("Time").font(.largeTitle)
                             Spacer()
                             Text(String(format: "%01i:%02i", self.engageTimer.time / 60, self.engageTimer.time % 60))
                                .font(.custom("DS-Digital", size: self.textSize))
                         }.padding().frame(height: geometry.size.height / 7)
                                 
                        // Rest Stack
                        // ==========
                        HStack {
                            Text("Rest").font(.largeTitle)
                            Spacer()
                            Text(String(format: "%01i:%02i", self.engageTimer.rest / 60, self.engageTimer.rest % 60))
                                .font(.custom("DS-Digital", size: self.textSize))
                        }.padding().frame(height: geometry.size.height / 7)

                        // Random Noise Choice & Count
                        VStack {
                            if self.engageTimer.usingRandomNoise {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Engager On").font(.largeTitle)
                                        Text("\(self.engageTimer.lowerRange)-\(self.engageTimer.upperRange) second spacing")
                                        }
                                    Spacer()
                                    Text(String(self.engageTimer.randomCount)).font(.custom("DS-Digital", size: self.textSize))
                                }
                                
                                
                            } else {
                                Text("Engager is Off").font(.largeTitle)
                            }
                           
                        }.padding().frame(height: geometry.size.height / 7).padding(.bottom)
                            
                         // Engage Button Action & Design
                         VStack (alignment: .center) {
                             Button(action: {
                                 self.pressedEngageTimerButton()
                             })
                             { Text("\(self.engageTimer.buttonTitle)")
                                 .frame(minWidth: 0, maxWidth: .infinity)
                                 .contentShape(Rectangle())
                                 .font(.title)
                                 .padding()
                                 .background(Capsule().stroke(lineWidth: 2))
                                 .foregroundColor(.primary)
                    
                             }
                         }.padding().frame(height: geometry.size.height / 7)
                         
                         // Pause Button Action & Design
                         VStack {
                             Button(action: {
                                 self.pressedPauseButton()
                                 }
                             ) { Text("\(self.engageTimer.pauseButtonTitle)")
                                 .font(.title)
                                 .frame(minWidth: 0, maxWidth: .infinity)
                                 .padding()
                                 .background(Capsule().stroke(lineWidth: 2))
                                .foregroundColor(self.buttonColor) }
                         }
                             .padding().frame(height: geometry.size.height / 7)
                         .disabled(self.engageTimer.buttonTitle == "Engage")
                         
                         HStack{
                             Spacer()
                             BannerVC().frame(width: 320, height: 50, alignment: .center)
                             Spacer()
                         }.frame(height: 50)
                    }
                    
                        
                        }// Geometry Close
                     // Navigation Bar Layout and Design
                        .navigationBarTitle("Engage Timer")
                        .navigationBarItems(
                            leading: Button(action: {
                                self.sheetSelection = 1
                                self.showSheet = true
                            }) {
                                    Image(systemName: "questionmark.circle")
                                    Text("About")
                            }
                            ,trailing: Button(action: {
                                self.sheetSelection = 2
                                self.showSheet = true
                            }) {
                                Image(systemName: "slider.horizontal.3")
                                Text("Edit")
                            }
                            .disabled(self.engageTimer.buttonTitle != "Engage"))
                    
                    } // ZStack Close
                    .onReceive(self.timer) { _ in
                        self.runEngageTimer()
            }
                    .onAppear() {
                        // If the users first login, show the explantion screen
                        if self.firsTimeOnScreen == false {
                            UserDefaults.standard.set(true, forKey: "firsTimeOnScreen")
                            self.showSheet = true
                        }
                        
                        // Create random number array
                        self.engageTimer.createRandomNumberArray()
                        print(self.engageTimer.randomArray)
                        // Capture reset values if timer is starting
                        self.engageTimer.fillResetValues()
                }
                    
                    
              // Present options sheet using binded variable and pass environment object
            .sheet(isPresented: $showSheet) {
                if self.sheetSelection == 1 {
                    OnboardingScreenView()
                }
                if self.sheetSelection == 2 {
                    EditEngageTimerOptionsView().environmentObject(self.engageTimer)
                }
                }
        } // Navigation View Close
        
        

} // View Closure
     
// Methods
// ======================================================
var buttonColor: Color {
    return self.engageTimer.buttonTitle == "Engage" ? .secondary : .primary
}

func runEngageTimer() {
    
    // Check to see if it is the last round, if yes, reduce rest count to 0 since the user is done.
    if self.engageTimer.round == self.engageTimer.totalRounds {
        self.engageTimer.rest = 0
    }
    
    // Start the countdown with the prep countdown
    if self.engageTimer.prepCountDown > 0 && self.engageTimer.usingPrepCountDown == true {
        // reduce the count by one
        self.engageTimer.prepCountDown -= 1
    }
        
    // Start the countdown for the time in that round
    else if self.engageTimer.time > 0 {
        // If this is the start of the round, sound the starting bell
        if self.engageTimer.time == self.engageTimer.timeReset {
            playSound(sound: "boxing-bell-1", type: "wav")
        }
        
        // Reduce time count by 1
        self.engageTimer.time -= 1

        // If this count is within the randomly generated array, sound the random noise that the user has input, IF the user if using the random count
        if self.engageTimer.randomArray.contains(self.engageTimer.time) && self.engageTimer.usingRandomNoise == true {
            playSound(sound: "\(self.engageTimer.noiseArray[engageTimer.noiseChoice])", type: "mp3")
            self.engageTimer.randomCount -= 1
        }

    } else if self.engageTimer.rest > 0 {
        // Play the boxing bell x 3 to indicate rest started
        if self.engageTimer.rest == self.engageTimer.restReset {
            playSound(sound: "boxing-bell-3", type: "wav")
        }
        self.engageTimer.rest -= 1

    } else if self.engageTimer.round < self.engageTimer.totalRounds {
        print("reset and start over")
        self.engageTimer.round += 1
        self.engageTimer.resetTimeAndRest()
        
        // need to also reset the random noise count
        // self.engageTimer.createRandomNumberArray()

    } else {
        print("ending timer")
        playSound(sound: "boxing-bell-3", type: "wav")
        // self.engageTimer.buttonTitle = "Engage"
        engageTimer.resetAllValues()
        self.cancelTimer()
        self.interstitial.showAd()
    }
}
    
func pressedEngageTimerButton() {
    // Check the status of the timer
    if self.engageTimer.timerIsRunning == false && self.engageTimer.pauseButtonIsPressed == false {
        // reflect that the timer is running
        self.engageTimer.timerIsRunning = true
        // Start the timer
        UIApplication.shared.isIdleTimerDisabled = true
//        // Create random number array
//        self.engageTimer.createRandomNumberArray()
//        // Capture reset values if timer is starting
//        self.engageTimer.fillResetValues()
        // Create new timer
        self.instanstiateTimer()
        // Start running the new timer (Uses func runEngageTimer)
        self.timer.connect()
        // Play the sound that matches the starting button
        playSound(sound: "start-button", type: "wav")
    } else {
        // Stop the Timer
        self.engageTimer.timerIsRunning = false
        self.engageTimer.pauseButtonIsPressed = false
        self.cancelTimer()
        self.engageTimer.resetAllValues()
        playSound(sound: "stop-button", type: "wav")
    }
    
     setButtonTitles()
}
    
func pressedPauseButton() {
    // Check to see if the timer is running
    if self.engageTimer.timerIsRunning == true && self.engageTimer.pauseButtonIsPressed == false {
        // If yes, Pause the Timer
        self.cancelTimer()
        // Play the pause sound
        playSound(sound: "pause", type: "wav")
        self.engageTimer.pauseButtonIsPressed = true

   } else {
        // Restart the Timer
        playSound(sound: "pause", type: "wav")
        self.instanstiateTimer()
        self.timer.connect()
        
        self.engageTimer.pauseButtonIsPressed = false
     }
    
    setButtonTitles()
}
    
    func setButtonTitles() {
        if self.engageTimer.timerIsRunning == false && self.engageTimer.pauseButtonIsPressed == false {
            self.engageTimer.buttonTitle = "Engage"
        } else {
            self.engageTimer.buttonTitle = "Reset"
        }
        
        if self.engageTimer.pauseButtonIsPressed == true {
            self.engageTimer.pauseButtonTitle = "Resume"
        } else {
            self.engageTimer.pauseButtonTitle = "Pause"
        }
    }
    
    
func instanstiateTimer() {
    self.engageTimer.timerIsRunning = true
    timer = Timer.publish(every: 1, on: .main, in: .common)
    return
}

func cancelTimer() {
    timer.connect().cancel()
    self.engageTimer.timerIsRunning = false
}
    
// Google ADMOB
// ================================================================
final private class BannerVC: UIViewControllerRepresentable  {

     func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        // Real Mob
        // view.adUnitID = "ca-app-pub-4186253562269967/1729357442"
        // Fake Mob
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
         view.rootViewController = viewController
         viewController.view.addSubview(view)
         viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
         view.load(GADRequest())

         return viewController
     }

     func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
 }
    
final class Interstitial:NSObject, GADInterstitialDelegate{
    // Real Mob
    // var interstitial:GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-4186253562269967/5998934622")
    // FakeMob
    var interstitial:GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    
    override init() {
        super.init()
        LoadInterstitial()
    }
    
    func LoadInterstitial(){
        let req = GADRequest()
        self.interstitial.load(req)
        self.interstitial.delegate = self
    }
    
    func showAd(){
        if self.interstitial.isReady{
           let root = UIApplication.shared.windows.first?.rootViewController
           self.interstitial.present(fromRootViewController: root!)
        }
       else{
           print("Not Ready")
       }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // Real Mob
        // self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-4186253562269967/5998934622")
        // Fake Mob
        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        LoadInterstitial()
    }
}
    
func checkInterstitialCount() {
    self.interstitialCount += 1
    if self.interstitialCount == 3 {
        self.interstitial.showAd()
        print("Interstital is Playing Meow")
        self.interstitialCount = 0
    }
}
    
//Preview Provider
// =====================================================================
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EngageTimerView().environmentObject(EngageTimer())
            .colorScheme(.dark)
    }
}
    
} // Overall EngageTimer Struct view closeure
