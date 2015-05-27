//
//  DetailViewController.swift
//  SocketIOSample
//
//  Created by Ankit Thakur on 5/26/15.
//  Copyright (c) 2015 Ankit Thakur. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, NSURLSessionDelegate {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    let socket = SocketIOClient(socketURL: "http://localhost:5000");
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        socket.sessionDelegate = self;
        socket.on("connect") {data, ack in
            println("socket connected")
            println("data \(data)")
            println("ack -> \(ack)");
        }
        socket.emitWithAck("event", 2) (timeout: 0) {data in
            self.socket.emit("message", ["amount": 0 + 2.50])
            }
        
        socket.on("message") {data, ack in
            println("message data \(data)")
            println("message ack -> \(ack)");
            self.socket.emitWithAck("message", 200)(timeout: 0) {data in
                self.socket.emit("message", ["amount": 0 + 2.50])
            }
            
            ack?("Got your currentAmount", "dude")
        }
        
        socket.connect();
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        socket.on("disconnect") {data, ack in
            println("socket is disconnected")
        }
        super.viewWillDisappear(animated);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARKS:  NSURLSessionDelegate
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?){
        
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print(session);
    }
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        
    }
    
    
    
}

