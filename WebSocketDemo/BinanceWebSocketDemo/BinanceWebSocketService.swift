//
//  BinanceWebSocketService.swift
//  WebSocketDemo
//
//  Created by M.Ömer Ünver on 14.06.2024.
//

import Foundation
import UserNotifications
class BinanceWebSocketService : NSObject, ObservableObject {
    var webSocket : URLSessionWebSocketTask?
   @Published var binanceMarketPriceData : [BinanceMarketPriceModel] = []
    func startWebSocket(){
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        let url = URL(string: "wss://stream.binancefuture.com/stream?streams=!markPrice@arr")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }
    
    func ping(){
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                debugPrint("Ping Error : \(error)")
            }
        })
    }
    
    func receive(){
        webSocket?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.handleMessage(text)
                        
                    }
                case .string(let string):
                    self.handleMessage(string)
                @unknown default:
                    break
                }
            case .failure(let error):
                debugPrint("Receive Error : \(error)")
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                self.receive()
            }
            
        })
    }
    
    
    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        do {
            let update = try JSONDecoder().decode(BinanceMarketPrice.self, from: data)
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
                self.binanceMarketPriceData.append(contentsOf: update.data)
                print(self.binanceMarketPriceData)
                self.sendNotification(for: update.data)
            }
            
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }
    
    private func sendNotification(for updates: [BinanceMarketPriceModel]) {
           let content = UNMutableNotificationContent()
           content.title = "New Market Price Update"
           content.body = "Received \(updates.count) new updates."
            content.sound = .defaultRingtone

           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Failed to add notification request: \(error)")
               }
           }
       }
    
    
}

extension BinanceWebSocketService : URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        ping()
        receive()
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        debugPrint("Did close connection with reason")
    }
}
