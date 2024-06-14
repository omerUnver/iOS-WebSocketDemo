//
//  ContentView.swift
//  WebSocketDemo
//
//  Created by M.Ömer Ünver on 13.06.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var webSocketService = WebSocketService()
    @State var sendText = ""
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        webSocketService.ping()
                        webSocketService.counter1Send()
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 75, height: 75)
                                .foregroundColor(Color.orange)
                            Text("Tap")
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                        }
                    })
                    
                    
                    List(webSocketService.randomData, id: \.self) { index in
                        Text(index)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .background(Color.black)
                    Divider()
                        .foregroundColor(.black)
                        .frame(height: 100)
                    Button(action: {
                        webSocketService.ping()
                        webSocketService.counter2Send()
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 75, height: 75)
                                .foregroundColor(Color.orange)
                            Text("Tap")
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                        }
                    })
                    
                    
                    List(webSocketService.randomData, id: \.self) { index in
                        Text(index)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .background(Color.black)
                }
                
                
                
                
            }
            .background(Color.black)
            .padding()
            .onAppear(){
                webSocketService.startWebSocket()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
