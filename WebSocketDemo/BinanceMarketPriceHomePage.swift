//
//  BinanceMarketPriceHomePage.swift
//  WebSocketDemo
//
//  Created by M.Ömer Ünver on 14.06.2024.
//

import SwiftUI

struct BinanceMarketPriceHomePage: View {
    @ObservedObject var binanceWebSocketService = BinanceWebSocketService()
    var body: some View {
        VStack(alignment: .leading) {
            List(binanceWebSocketService.binanceMarketPriceData, id: \.id) { price in
                HStack {
                    Text("Name: \(price.s)")
                        .foregroundColor(.orange)
                    Text("Price: \(formatPrice(price.P))")
                        .foregroundStyle(.orange)
                }
            }
            
        }
        .onAppear() {
            binanceWebSocketService.startWebSocket()
        }
    }
    private func formatPrice(_ price: String) -> String {
           if let doubleValue = Double(price) {
               return String(format: "%.2f", doubleValue)
           } else {
               return price
           }
       }
}

#Preview {
    BinanceMarketPriceHomePage()
}
