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
    private let timeLabel = UILabel()
    private let timePicker = UIDatePicker()
    private let titleTextField = UITextField()
    private let subtitleTextField = UITextField()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundGradientViewSetup()
        switchButtonSetup()
        switchLabelSetup()
        timeLabelSetup()
        timePickerSetup()
        titleTextFieldSetup()
        subtitleTextFieldSetup()
    }
    // проверка на вкл/выкл и соответственно от этого видимость/невидимость остальных элементов
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForOnOff()
    }
    //    MARK: - View setup
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
    // настройка view переключателя
    private func switchButtonSetup() {
        let button = switchButton
        button.frame.origin = .init(x: 300, y: 158)
        button.addTarget(self, action: #selector(tapped), for: .valueChanged)
        view.addSubview(button)
    }
    // настройка view лейбы переключателя Allow Notifications
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
    // настройка view лейбы Notification Time
    private func timeLabelSetup() {
        let label = timeLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notification Time"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 266),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -517),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -155)
        ])
    }
    // настройка view ввода времени
    private func timePickerSetup() {
        let picker = timePicker
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.backgroundColor = .white
        picker.layer.borderWidth = 10
        picker.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: view.topAnchor, constant: 271),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 271),
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -524),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ])
    }
    // настройка view text field для ввода title для уведомления
    private func titleTextFieldSetup() {
        let tf = titleTextField
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.clearButtonMode = .whileEditing
        tf.font = .systemFont(ofSize: 24)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Enter Title Text ...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        )
        tf.textAlignment = .left
        tf.textColor = .white
        view.addSubview(tf)
        NSLayoutConstraint.activate([
            tf.topAnchor.constraint(equalTo: view.topAnchor, constant: 336),
            tf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            tf.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -447),
            tf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])
    }
    // настройка view text field для ввода subtitle для уведомления
    private func subtitleTextFieldSetup() {
        let tf = subtitleTextField
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.clearButtonMode = .whileEditing
        tf.font = .systemFont(ofSize: 24)
        tf.attributedPlaceholder = NSAttributedString(
            string: "Enter Subtitle Text ...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        )
        tf.textAlignment = .left
        tf.textColor = .white
        view.addSubview(tf)
        NSLayoutConstraint.activate([
            tf.topAnchor.constraint(equalTo: view.topAnchor, constant: 385),
            tf.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            tf.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -398),
            tf.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48)
        ])
    }
// функция проверки вкл/выкл кнопки свитча и от этого видимость/невидимость остальных элементов
    private func checkForOnOff() {
        if switchButton.isOn {
            timeLabel.isHidden = false
            timePicker.isHidden = false
            titleTextField.isHidden = false
            subtitleTextField.isHidden = false
        } else {
            timeLabel.isHidden = true
            timePicker.isHidden = true
            titleTextField.isHidden = true
            subtitleTextField.isHidden = true
        }
    }
    
    
}

extension FirstViewController {
    //    MARK: - IBActions
    // функция вызываемая при нажатии на свитч
    @objc func tapped() {
        checkForOnOff()
        print(timePicker.date)
        
        //        let value = switchButton.isOn
        //        let svc = SecondViewController()
        //        if value {
        //            present(svc, animated: true, completion: nil)
        //        } else {
        //            print("ВЫКЛ")
        //        }
    }
}

