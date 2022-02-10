//
//  ViewController.swift
//  NotificationsHomeWork
//
//  Created by Сергей Матвеенко on 09.02.2022.
//

import UIKit

class FirstViewController: UIViewController {
    private let backgroundGradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    let switchButton = UISwitch()
    private let switchLabel = UILabel()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientViewSetup()
        switchButtonSetup()
        switchLabelSetup()


    }
//    настройка фона ввиде градиента
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
    
    private func switchButtonSetup() {
        let button = switchButton
        button.frame.origin = .init(x: 300, y: 158)
        button.addTarget(self, action: #selector(tapped), for: .valueChanged)
        view.addSubview(button)
    }
    
    private func switchLabelSetup() {
        let label = switchLabel
        label.frame.size = .init(width: 189, height: 29)
        label.frame.origin = .init(x: 48, y: switchButton.frame.origin.y)
        label.textColor = .white
        label.text = "Allow Notifications"
        label.font = .systemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
    }
    
    @objc func tapped() {
        let value = switchButton.isOn
        if value {
            print("ВКЛ")
        } else {
            print("ВЫКЛ")
        }
    }
    



}

