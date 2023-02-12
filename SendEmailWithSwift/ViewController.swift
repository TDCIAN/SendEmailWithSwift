//
//  ViewController.swift
//  SendEmailWithSwift
//
//  Created by JeongminKim on 2023/02/06.
//

import UIKit
import SwiftUI
import MessageUI // MARK: You should import MessageUI to send email.

class ViewController: UIViewController {
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("SEND EMAIL", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        button.layer.cornerRadius = 16
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.widthAnchor.constraint(equalToConstant: 150),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func didTapSendButton() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            // Set recipients list
            mailComposeVC.setToRecipients([
                "recipient1@somewhere.com",
                "recipient2@somewhere.com",
                "recipient3@somewhere.com"
            ])
            
            // Set email title
            mailComposeVC.setSubject("Input mail title!")
            
            // Set email contents
            mailComposeVC.setMessageBody(
                "Hello, it's me... I was wondering if after all these years you'd like to meet",
                isHTML: false
            )
            
            // Set delegate
            mailComposeVC.mailComposeDelegate = self
            
            // MARK: If you want attach text file
            
            // (1) Make text file
            let text: String = "Lorem ipsum"
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let newFileName = "text_file.txt"
            let filename = path.appendingPathComponent(newFileName)
            do {
                try text.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("Failed to make text file with error - \(error)")
            }
            
            // (2) Find text file you made
            let filePath = path.appendingPathComponent(newFileName)
            do {
                let data = try Data(contentsOf: filePath)
                // (3) Attach text file to email
                mailComposeVC.addAttachmentData(data as Data, mimeType: "application/json", fileName: newFileName)
            } catch {
                print("Failed to find text file with error - \(error)")
            }
            
            // MARK: Finally, you should present mail compose view controller
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            // MARK: You should set email address for 'Mail' application(iOS basic application) to use MFMailComposeViewController
            print("Please set your email address for 'Mail' application.")
        }
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    // MARK: You can check the results.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Cancelled to send email")
        case .saved:
            print("Saved")
        case .sent:
            print("Sent successfully")
        case .failed:
            print("Failed to send email")
        @unknown default:
            print("Unknown")
        }
    }
}
