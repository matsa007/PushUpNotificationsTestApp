//
//  SecondViewController.swift
//  NotificationsHomeWork
//
//  Created by Сергей Матвеенко on 09.02.2022.
//

import UIKit

class SecondViewController: UIViewController {
    private let backgroundGradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let textLabel = UILabel()
    private let settingWayButton = UIButton(type: .system)
    let vc = FirstViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientViewSetup()
        labelSetup()
        settingWayButtonSetup()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                DispatchQueue.main.async {
                    self.vc.modalPresentationStyle = .fullScreen
                    self.present(self.vc, animated: true, completion: nil)
                }
                print("User granted permission for notification")
            case .denied:
                print("User denied notification permission")
            case .notDetermined:
                print("Notification permission haven't been asked yet")
            case .provisional:
                print("The application is authorized to post non-interruptive user notifications.")
            case .ephemeral:
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Unknow Status")
            }
        })
    }
    
    private func backgroundGradientViewSetup() {
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [
            UIColor(red: 11/255, green: 15/255, blue: 50/255, alpha: 1).cgColor,
            UIColor(red: 165/255, green: 8/255, blue: 132/255, alpha: 1).cgColor
        ]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.addSublayer(gradientLayer)
        view.addSubview(backgroundGradientView)
    }
    
    private func labelSetup() {
        let label = textLabel
        label.text = "Notifications are disabled. Please enable them in settings"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.frame.size = .init(width: 286, height: 87)
        label.frame.origin = .init(x: (view.frame.width/2 - label.frame.width/2), y: (view.frame.height/2 - label.frame.height/2))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        view.addSubview(label)
    }
    
    private func settingWayButtonSetup() {
        let button = settingWayButton
        button.frame.size = .init(width: 297, height: 59)
        button.frame.origin = .init(x: (textLabel.frame.origin.x), y: (textLabel.frame.origin.y + textLabel.frame.height/2 + button.frame.height/2 + 66))
        button.clipsToBounds = true
        button.layer.cornerRadius = 30
        button.backgroundColor = .black
        button.attributedTitle(for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 21)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setTitle("Open\nSettings", for: .normal)
        button.addTarget(self, action: #selector(settingWayButtonTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
}

extension SecondViewController {
    @objc private func settingWayButtonTapped() {
        
        print(vc.switchButton.isOn)
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
