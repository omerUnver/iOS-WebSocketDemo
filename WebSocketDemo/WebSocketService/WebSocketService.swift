//
//  WebSocketService.swift
//  WebSocketDemo
//
//  Created by M.Ömer Ünver on 13.06.2024.
//

import Foundation

class WebSocketService : NSObject, ObservableObject {
    var webSocket : URLSessionWebSocketTask?
    @Published var randomData : [String] = []
    @Published var counter = 0
    @Published var counter2 = 0
    func startWebSocket(){
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue())
        let url = URL(string: "wss://free.blr2.piesocket.com/v3/1?api_key=")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }
    func counter1Send(){
        counter += 1
        send(message: "C1 : \(counter)")
    }
    func counter2Send(){
        counter2 += 1
        send(message: "C2 : \(counter2)")
    }
    
    func ping(){
        webSocket?.sendPing{ error in
            if let error = error {
                debugPrint("Ping Error : \(error)")
            }
        }
    }
    func close(){
        webSocket?.cancel(with: .goingAway, reason: "Demo Ended".data(using: .utf8))
    }
    func send(message : String){
        DispatchQueue.main.async {
            
            self.webSocket?.send(.string(message), completionHandler: { error in
                if let error = error {
                    debugPrint("Send Message Error : \(error)")
                }
            })
        }
        
       
    }
    func receive(){
        webSocket?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    debugPrint("Data : \(data)")
                case .string(let message):
                    debugPrint("String Data : \(message)")
                    self.randomData.append(message)
                @unknown default :
                    break
                }
            case .failure(let error):
                debugPrint("Receive error : \(error)")
            }
            self.receive()
        })
    }
}

extension WebSocketService :  URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
            debugPrint("did connect to Socket")
        ping()
        receive()
        
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        debugPrint("Did close connection with reason")
    }
}
