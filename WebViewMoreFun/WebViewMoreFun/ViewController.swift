//
//  ViewController.swift
//  WebViewMoreFun
//
//  Created by Annie Tung on 1/6/17.
//  Copyright © 2017 Annie Tung. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController , WKUIDelegate, WKScriptMessageHandler, UITextFieldDelegate { // handle messages coming from the webView
    
    // MARK: - Properties and outlets
    
    var webView: WKWebView!
    let divColors = ["pink", "teal", "purple", "yellow"]
    
    @IBOutlet weak var textField: UITextField!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        textField.delegate = self
        
        let path = Bundle.main.path(forResource: "embedded", ofType: "html")
        let dir = URL(fileURLWithPath: Bundle.main.bundlePath)
        // loading the file to the internet onto our webview
        let myURL = URL(fileURLWithPath: path!)
        webView.loadFileURL(myURL, allowingReadAccessTo: dir)
    }
    
    // MARK: - WebView
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        
        // self conforms to protocol WKScriptMessageHandler
        // runSwift is a message that is dynamically declared
        userContentController.add(self, name: "runSwift")
        
        webConfiguration.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        //webView.navigationDelegate = self
        
        if let containerView = view.viewWithTag(1) {
            containerView.addSubview(webView)
            
            webView.translatesAutoresizingMaskIntoConstraints = false
            let _ = [
                webView.topAnchor.constraint(equalTo: containerView.topAnchor),
                webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                webView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                webView.rightAnchor.constraint(equalTo: containerView.rightAnchor)
                ].map{$0.isActive = true}
        }
    }
    
    // MARK: - Segment Action
    
    @IBAction func colorChosen(_ sender: UISegmentedControl) {
        let color = divColors[sender.selectedSegmentIndex]
        // generating javascript in swift to return \(color):
        var js = "document.getElementById('box1').style.backgroundColor = '\(color)';";
        js += "document.getElementById('box1').innerHTML = '\(color)'"
        webView.evaluateJavaScript(js) { (ret, error) in
            print(ret ?? "whoops")
        }
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = textField.text {
            let js = "document.getElementById('box2').innerHTML = '\(textField)'"
            webView.evaluateJavaScript(js) { (ret, error) in
                print(ret ?? "womp womp womp")
            }
        }
        return true
    }
    
    // MARK: - Bar Button Action
    
    @IBAction func rewindButtonTapped(_ sender: AnyObject) {
        webView.goBack()
    }

    @IBAction func fastForwardButtonTapped(_ sender: AnyObject) {
        webView.goForward()
    }
    
    // MARK: - WKUserContentController
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Received message named: \(message.name)") // will receive runSwift message
        print(message.body)
        // cast the dictionary to do something with it:
        if let msg = message.body as? [String:Any] { // will get the dictionary in js
            print(msg["msg"] ?? "whoops")
        }
    }
    
    
    
    
    
    
    
    
}

