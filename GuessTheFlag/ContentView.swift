
//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Adri on 24/1/23.
//

import SwiftUI

//Custom view
struct FlagImage: View {
    var imageUrl: String

    var body: some View {
        Image(imageUrl)
            .renderingMode(.original)
            .clipShape(Circle())
            .shadow(radius: 5)
    }
}


//Custom view modifier
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color.black)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingFinalMessage = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var roundsPlayed = 0
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: .mint, location: 0.3),
                .init(color: .indigo, location: 0.3),
            ], center: .top, startRadius: 100, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15){
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.black)
                    
                        Text(countries[correctAnswer])
                            .titleStyle()
                    }
                    .frame(maxWidth: 300)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageUrl: countries[number])
                        }
                        
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(currentScore)")
        }
        .alert("This is the end", isPresented: $showingFinalMessage) {
            Button("New game", action: resetGame)
        } message: {
            Text("Your final score is \(currentScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        roundsPlayed += 1
        if number == correctAnswer {
            currentScore += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong, thats the flag of \(countries[number])"
        }
        
        if roundsPlayed == 8 {
            showingFinalMessage = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        showingFinalMessage = false
        currentScore = 0
        roundsPlayed = 0
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
