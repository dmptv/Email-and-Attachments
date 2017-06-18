//
//  AttachmentTableViewController.swift
//  Email and Attashments
//
//  Created by Kanat A on 18/06/2017.
//  Copyright © 2017 ak. All rights reserved.
//



import UIKit
import MessageUI

// Swift 4 , Xcode 9

class AttachmentTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    // MIME - типы данных которые могут быть переданы виа интернет
    enum MIMEType: String {
        case html = "text/html"
        case jpg = "image/jpeg"
        case ppt = "application/vnd.ms-powerpoint" // Майкрософт Powerpoint files
        case png = "image/png"
        case doc = "application/msword" // MS world
        
        // Универсальный констрктор для определения различных MIMEType's
        init?(type: String) {
            switch type.lowercased() {
            case "html": self = .html
            case "jpg": self = .jpg
            case "ppt": self = .ppt
            case "png": self = .png
            case "doc": self = .doc
            default: return nil
            }
        }
    }
    
    let filenames = ["camera-photo-tips.html", "foggy.jpg", "Hello World.ppt", "no more complaint.png", "Just Dev.doc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return filenames.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = filenames[indexPath.row]
        cell.imageView?.image = UIImage(named: "icon\(indexPath.row).png");
        
        return cell
    }
    
    func showEmail(attachmentFile: String) {
        // Проверка - поддерживает ли устройство отправку почты - те забита ли какоя то почта в наше устройство
        guard MFMailComposeViewController.canSendMail() else {return}
        
        let emailTitle = "Greate Photo and Doc"
        let messageBody = "hey Aroa Ramirez"
        let toRecipients = ["nvlldid@gmail.com"]
        
        // Create mail Composer
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        // Присоединяем файл к письму
        
        // Берем имя и расширение attachmentFile
        let fileparts = attachmentFile.components(separatedBy: ".")
        let filename = fileparts[0]
        let fileExtention = fileparts[1]
        
        // Get path of file
        guard let filePath = Bundle.main.path(forResource: filename, ofType: fileExtention) else {return}
        
        // Передадим файл как Data с расширением MIMEType в MFMailComposeViewController
        if let fileData = NSData(contentsOfFile: filePath), let mimeType = MIMEType(type: fileExtention) /* Определяем MIMEType согласно стандартам*/ {
            mailComposer.addAttachmentData(fileData as Data, mimeType: mimeType.rawValue /* реальный MIMEType */, fileName: filename)
            present(mailComposer, animated: true, completion: nil)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // Отслеживаем с каким результатом отправилось письмо - для отладки
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled") /* можно вывести Алерт*/
        case MFMailComposeResult.saved.rawValue:
            print("Caved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Failed")
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = filenames[indexPath.row]
        showEmail(attachmentFile: selectedFile)
    }

}
















