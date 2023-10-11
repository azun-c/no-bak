//
//  ViewController.swift
//  no-bak
//
//  Created by azun on 06/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadingInterval) {
            self.stopMainIndicator()
            self.detectTerminalIDFile()
        }
    }
    
    private lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var statusNo = 1
}

// MARK: - Private
private extension ViewController {
    enum Constants {
        static let waitingInterval = Double(0.5)
        static let loadingInterval = Double(2)
        static let displayingDuration = Double(0.3)
        static let topMargin = Double(40)
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollview)
        NSLayoutConstraint.activate([
            scrollview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func detectTerminalIDFile() {
        let checkingFileStatus = StatusView()
        let msg = "Looking for TerminalID.txt under Documents folder"
        checkingFileStatus.configure(with: formatMessage(input: msg))
        stackToScrollView(with: checkingFileStatus)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadingInterval) {
            self.detectingTerminalIDFile(for: checkingFileStatus)
        }
    }
    
    func stopMainIndicator() {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
    
    func detectingTerminalIDFile(for statusView: StatusView) {
        statusView.setDone()
        
        let isExisting = FileManager.readTerminalID() != nil
        
        let checkingFileResultStatus = StatusView()
        let msg: String
        if isExisting {
            msg = "Found the TerminalID.txt under Documents folder"
        }
        else {
            msg = "NO TerminalID.txt found under Documents folder"
        }
        checkingFileResultStatus.configure(with: formatMessage(input: msg))
        checkingFileResultStatus.alpha = 0
        stackToScrollView(with: checkingFileResultStatus)
        UIView.animate(withDuration: Constants.displayingDuration,
                       animations: {
            checkingFileResultStatus.alpha = 1
        }) { _ in
            checkingFileResultStatus.setDone()
            self.detectedTerminalIDFile(isExisting: isExisting)
        }
    }
    
    func detectedTerminalIDFile(isExisting: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.waitingInterval) {
            if isExisting {
                self.showStoredTerminalID()
            }
            else {
                self.createNewTerminialIDFile()
            }
        }
    }
    
    func showStoredTerminalID() {
        let terminalIDStatus = StatusView()
        let msg: String
        if let terminalID =  FileManager.readTerminalID() {
            msg = "TerminalID - (\(terminalID))"
        }
        else {
            msg = "Could not read TerminalID.txt file"
        }
        terminalIDStatus.configure(with: formatMessage(input: msg))
        terminalIDStatus.alpha = 0
        stackToScrollView(with: terminalIDStatus)
        terminalIDStatus.setDone()
        UIView.animate(withDuration: Constants.displayingDuration,
                       animations: {
            terminalIDStatus.alpha = 1
        })
    }
    
    func createNewTerminialIDFile() {
        let creatingFileStatus = StatusView()
        let msg = "Creating TerminalID.txt under Documents folder"
        creatingFileStatus.configure(with: formatMessage(input: msg))
        stackToScrollView(with: creatingFileStatus)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.loadingInterval) {
            self.creatingNewTerminialIDFile(for: creatingFileStatus)
        }
    }
    
    func creatingNewTerminialIDFile(for statusView: StatusView) {
        let terminalID = FileManager.createTerminalIDFile()
        statusView.setDone()
        
        let terminalIDStatus = StatusView()
        let msg: String
        if let terminalID {
            msg = "Terminal ID has been created - (\(terminalID))"
        }
        else {
            msg = "Could not create TerminalID.txt file"
        }
        terminalIDStatus.configure(with: formatMessage(input: msg))
        terminalIDStatus.alpha = 0
        stackToScrollView(with: terminalIDStatus)
        terminalIDStatus.setDone()
        UIView.animate(withDuration: Constants.displayingDuration,
                       animations: {
            terminalIDStatus.alpha = 1
        })
    }
    
    func stackToScrollView(with newView: StatusView) {
        let statusSubviews = scrollview.subviews.filter({ $0 is StatusView })
        let hasSubviews = statusSubviews.count > 0
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(newView)
        if hasSubviews, let currentLastView = statusSubviews.last {
            NSLayoutConstraint.activate([
                newView.topAnchor.constraint(equalTo: currentLastView.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                newView.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: Constants.topMargin)
            ])
        }
        
        NSLayoutConstraint.activate([
            newView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            newView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newView.bottomAnchor.constraint(lessThanOrEqualTo: scrollview.bottomAnchor)
        ])
    }
    
    func formatMessage(input: String) -> String {
        let output = "\(statusNo). \(input)"
        statusNo += 1
        return output
    }
}
