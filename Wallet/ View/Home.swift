//
//  Home.swift
//  Wallet App
//
//  Created by Rustam Manafli on 12.03.22.
//

import SwiftUI

struct Home: View {
    // Animation Properties
    @State var expandCards: Bool = false
    // Detail View Properties
    @State var currentCard: Card?
    @State var showDetailCard: Bool = false
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 0){
            
            Text("Wallet")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: expandCards ? .leading : .center)
                .overlay(alignment: .trailing) {
                    
                    // Close button
                    
                    Button{
                        
                        // Closing Cards
                        withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.7, blendDuration: 0.7)){
                            expandCards = false
                        }
                        
                    } label: {
                        
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(.blue, in: Circle())
                    }
                    .rotationEffect(.init(degrees: expandCards ? 45 : 0))
                    .offset(x: expandCards ? 10 : 15)
                    .opacity(expandCards ? 1 : 0)
                    
                }
                .padding(.horizontal, 15)
                .padding(.bottom,10)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 0){
                    
                    // Cards
                    ForEach(cards){card in
                        Group{
                            CardView(card: card)
                                .matchedGeometryEffect(id: card.id, in: animation)
                        }
                            .onTapGesture{
                                withAnimation(.easeInOut(duration: 0.35)){
                                    currentCard = card
                                    showDetailCard = true
                            
                                }
                                
                            }
                    }
                }
                .overlay{
                    Rectangle()
                        .fill(.black.opacity(expandCards ? 0 : 0.01))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)){
                                expandCards = true
                            }
                        }
                }
                .padding(.top, expandCards ? 30 : 0)
            }
            .coordinateSpace(name: "SCROLL")
            .offset(y: expandCards ? 0 : 30)
            
            // Add button
            Button{
                
            } label: {
                
                
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(.blue, in: Circle())
                    
              
              
            }
            
            .rotationEffect(.init(degrees: expandCards ? 180 : 0))
            .scaleEffect(expandCards ? 0.01 : 1)
            .opacity(!expandCards ? 1 : 0)
            .frame(height: expandCards ? 0 : nil)
            .padding(.bottom, expandCards ? 0 : 30)
            
            
        }
        .padding([.horizontal, .top])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay{
            if let currentCard = currentCard,showDetailCard{
                DetailView(currentCard: currentCard, showDetailCard: $showDetailCard, animation: animation)
            }
        }
        
    }
    
    // Card View
    
    @ViewBuilder
    func CardView(card: Card) -> some View{
        GeometryReader{proxy in
            
            let rect = proxy.frame(in: .named("SCROLL"))
            let offset = CGFloat(getIndex(Card: card) * (expandCards ? 10 : 70))
                
            
            ZStack(alignment: .bottomLeading) {
                
                Image(card.CardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

            
            // Card Details
            VStack(alignment: .leading, spacing: 10) {
                Text(card.name)
                    .fontWeight(.bold)
                
                Text(customizedCardNumber(number: card.CardNumber))
                    .font(.callout)
                    .fontWeight(.bold)
            }
            .padding()
            .padding(.bottom, 10)
            .foregroundColor(.white)
                
            }
            .offset(y: expandCards ? offset : -rect.minY +  offset)
        }
        // Max size
        .frame(height: 240)
       
}
    func getIndex(Card: Card)-> Int{
        return cards.firstIndex { currentCard in
            return currentCard.id == Card.id
            
        } ?? 0
        
    }

}
// Hiding all number without last 4 digit
// Global Method
func customizedCardNumber(number: String)-> String{
    var newValue: String = ""
    let maxCount = number.count - 4
    number.enumerated().forEach { value in
        if value.offset >= maxCount{
            
            let string = String(value.element)
            newValue.append(contentsOf: string)
            
        }
        else{
            let string = String(value.element)
            if string == "" {
                newValue.append(contentsOf: "")
            }
            else{
                newValue.append(contentsOf: "*")
            }
            
        }
    }
    
    return newValue
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

// Detail View
struct DetailView: View{
    var currentCard: Card
    @Binding var showDetailCard: Bool
    // Geometry effect
    var animation: Namespace.ID
    
    @State var showExpenceView: Bool = false
    
    var body: some View{
        
        VStack{
            CardView()
                .matchedGeometryEffect(id: currentCard.id, in: animation)
                .frame(height: 200)
                .onTapGesture {
                    withAnimation(.easeInOut){
                        showExpenceView = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                      
                        withAnimation(.easeInOut(duration: 0.35)){
                            showDetailCard = false
                    }
                    
                    }
                
                   
                }
                .zIndex(10)
            GeometryReader{ proxy in
                let height = proxy.size.height + 50
                
                ScrollView(.vertical, showsIndicators: false){
                   
                    VStack(spacing: 20){
                      
                        //Expence
                        ForEach(expences){expence in
                            //Card View
                            expenceCartView(expence: expence)
                            
                        }
                       
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .background(Color.white.clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .ignoresSafeArea())
                    .offset(y: showExpenceView ? 0 : height)
                
            }
            .padding([.horizontal, .top])
            .zIndex(-10)
            
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.gray.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeInOut.delay(0.1)){
            showExpenceView = true
            }
            
        }
    }
    
    
    @ViewBuilder
    func CardView()-> some View{
        ZStack(alignment: .bottomLeading) {
            
            Image(currentCard.CardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)

        
        // Card Details
        VStack(alignment: .leading, spacing: 10) {
            Text(currentCard.name)
                .fontWeight(.bold)
            
            Text(customizedCardNumber(number: currentCard.CardNumber))
                .font(.callout)
                .fontWeight(.bold)
        }
        .padding()
        .padding(.bottom, 10)
        .foregroundColor(.white)
    }
}
    
}
struct expenceCartView: View{
    
    var expence: Expence
    
    @State var showView: Bool = false
    

    var body: some View{
        HStack(spacing: 14){
            Image(expence.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 8){
                
                Text(expence.product)
                    .fontWeight(.bold)
                
                Text(expence.spendType)
                    .font(.caption)
                    .foregroundColor(.gray)
            
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8){
                Text(expence.amountSpend)
                    .fontWeight(.bold)
                
                // show today's date
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
            .opacity(showView ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    
                    withAnimation(.easeInOut(duration: 0.3).delay(Double(getIndex()) * 0.1)){
                        showView = true
                    }
                
            }
        }
    }
    
    func getIndex()-> Int{
        return expences.firstIndex { currentExpence in
            return expence.id == currentExpence.id
            
        } ?? 0
    }
}

