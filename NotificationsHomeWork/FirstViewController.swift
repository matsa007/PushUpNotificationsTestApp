//
//  FirstViewController.swift
//  NotificationsHomeWork
//
//  Created by Сергей Матвеенко on 09.02.2022.
//

import UIKit
import UserNotifications

class FirstViewController: UIViewController, UNUserNotificationCenterDelegate {
    let authorizedView = UIView()
    let unAuthorizedView = UIView()
    let authorizedGradientLayer = CAGradientLayer()
    let unAuthorizedGradientLayer = CAGradientLayer()
    let authorizedBackgroundGradientView = UIView()
    let unAuthorizedBackgroundGradientView = UIView()
    let switchLabel = UILabel()
    let switchButton = UISwitch()
    let timeLabel = UILabel()
    let timePicker = UIDatePicker()
    let titleTextField = UITextField()
    let subtitleTextField = UITextField()
    let applyButton = UIButton(type: .system)
    let textLabel = UILabel()
    let settingWayButton = UIButton(type: .system)
    lazy var languagesSet = ["English","Deutch"]
    let pickerView = UIPickerView()
    var languageOfApp = MemoryManager().loadlanguage() {
        didSet {
            localiztionOfApp()
            MemoryManager().savelanguage(languageOfApp)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        UNUserNotificationCenter.current().delegate = self
        authorizedViewSetup()
        unAuthorizedViewSetup()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForAuthorization()
    }
    //    MARK: - View setup
    
    //    настройка authorizedView
    func authorizedViewSetup() {
        let aView = authorizedView
        aView.frame = view.bounds
        view.addSubview(aView)
        authorisedBackgroundGradientViewSetup()
        switchLabelSetup()
        switchButtonSetup()
        timeLabelSetup()
        timePickerSetup()
        titleTextFieldSetup()
        subtitleTextFieldSetup()
        applyButtonSetup()
        pickerViewSetup()
    }
    
    //    настройка unAuthorizedView
    func unAuthorizedViewSetup() {
        let unView = unAuthorizedView
        unView.frame = view.bounds
        view.addSubview(unView)
        unAuthorisedBackgroundGradientViewSetup()
        labelSetup()
        settingWayButtonSetup()
        
    }
    
    //  функция добавления градиента на задний фон
    func gradientForBackgroundView(layer: CAGradientLayer, gradientView: UIView, activeView: UIView) {
        layer.frame = view.bounds
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.colors = [
            UIColor(red: 11/255, green: 15/255, blue: 50/255, alpha: 1).cgColor,
            UIColor(red: 165/255, green: 8/255, blue: 132/255, alpha: 1).cgColor
        ]
        layer.shouldRasterize = true
        gradientView.layer.addSublayer(layer)
        activeView.addSubview(gradientView)
    }
    
    //    настройка фона ввиде градиента для authorizedView
    func authorisedBackgroundGradientViewSetup() {
        gradientForBackgroundView(layer: authorizedGradientLayer, gradientView: authorizedBackgroundGradientView, activeView: authorizedView)
    }
    //    настройка фона ввиде градиента для unAuthorizedView
    func unAuthorisedBackgroundGradientViewSetup () {
        gradientForBackgroundView(layer: unAuthorizedGradientLayer, gradientView: unAuthorizedBackgroundGradientView, activeView: unAuthorizedView)
    }
    
    // настройка лейбы для unAuthorizedView
    func labelSetup() {
        let label = textLabel
        label.text = String(localized: "notification_label").localized(locale: languageOfApp)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.frame.size = .init(width: 286, height: 87)
        label.frame.origin = .init(x: (view.frame.width/2 - label.frame.width/2), y: (view.frame.height/2 - label.frame.height/2))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        unAuthorizedView.addSubview(label)
    }
    
    func settingWayButtonSetup() {
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
        button.setTitle(String(localized: "setup_button").localized(locale: languageOfApp), for: .normal)
        button.addTarget(self, action: #selector(settingWayButtonTapped), for: .touchUpInside)
        unAuthorizedView.addSubview(button)
    }
    
    // настройка view лейбы переключателя Allow Notifications
    func switchLabelSetup() {
        let label = switchLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = String(localized: "switch_label").localized(locale: languageOfApp)
        label.font = .systemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        authorizedView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150)
        ])
    }
    
    // настройка view переключателя
    func switchButtonSetup() {
        let button = switchButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(switchButtonTapped), for: .valueChanged)
        button.isOn = true
        authorizedView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    // настройка view лейбы Notification Time
    func timeLabelSetup() {
        let label = timeLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = String(localized: "time_label").localized(locale: languageOfApp)
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        authorizedView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: switchLabel.topAnchor, constant: 70),
            label.leadingAnchor.constraint(equalTo: switchLabel.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: 70),
            label.trailingAnchor.constraint(equalTo: switchLabel.trailingAnchor)
        ])
    }
    
    // настройка view ввода времени
    func timePickerSetup() {
        let picker = timePicker
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.backgroundColor = .clear
        picker.locale = .init(identifier: "ru_RU")
        authorizedView.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            picker.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 50),
            picker.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0),
            picker.trailingAnchor.constraint(equalTo: switchButton.trailingAnchor, constant: 0)
        ])
    }
    // настройка view text field для ввода title для уведомления
    func titleTextFieldSetup() {
        let tf = titleTextField
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.clearButtonMode = .whileEditing
        tf.font = .systemFont(ofSize: 24)
        tf.attributedPlaceholder = NSAttributedString(
            string: String(localized: "title_placeholder").localized(locale: languageOfApp),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        )
        tf.textAlignment = .left
        tf.textColor = .white
        tf.tintColor = .white
        authorizedView.addSubview(tf)
        NSLayoutConstraint.activate([
            tf.topAnchor.constraint(equalTo: switchLabel.topAnchor, constant: 170),
            tf.leadingAnchor.constraint(equalTo: switchLabel.leadingAnchor),
            tf.bottomAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: 170),
            tf.trailingAnchor.constraint(equalTo: timePicker.trailingAnchor)
        ])
    }
    
    // настройка view text field для ввода subtitle для уведомления
    func subtitleTextFieldSetup() {
        let tf = subtitleTextField
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .clear
        tf.clearButtonMode = .whileEditing
        tf.font = .systemFont(ofSize: 24)
        tf.attributedPlaceholder = NSAttributedString(
            string: String(localized: "subtitle_placeholder").localized(locale: languageOfApp),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
        )
        tf.textAlignment = .left
        tf.textColor = .white
        tf.tintColor = .white
        authorizedView.addSubview(tf)
        NSLayoutConstraint.activate([
            tf.topAnchor.constraint(equalTo: switchLabel.topAnchor, constant: 240),
            tf.leadingAnchor.constraint(equalTo: switchLabel.leadingAnchor),
            tf.bottomAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: 240),
            tf.trailingAnchor.constraint(equalTo: timePicker.trailingAnchor)
        ])
    }
    
    // настройка пикера для выбора языка
    func pickerViewSetup() {
        let picker = pickerView
        picker.translatesAutoresizingMaskIntoConstraints = false
        authorizedView.addSubview(picker)
        picker.centerXAnchor.constraint(equalTo: authorizedView.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: authorizedView.centerYAnchor, constant: 50).isActive = true
    }
    
    // настройка кнопки добавления уведомления
    func applyButtonSetup() {
        let button = applyButton
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "apply_button").localized(locale: languageOfApp), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .systemGreen
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        authorizedView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 150),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150)
        ])
    }
    
    // функция проверки состояния центра уведомлений и подмена view на его основе
    func checkForAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                DispatchQueue.main.async {
                    self.authorizedView.isHidden = false
                    self.switchButton.isOn = true
                    self.unAuthorizedView.isHidden = true
                    self.timeLabel.isHidden = false
                    self.timePicker.isHidden = false
                    self.titleTextField.isHidden = false
                    self.subtitleTextField.isHidden = false
                    self.pickerView.isHidden = false
                    self.applyButton.isHidden = false
                }
                print("User granted permission for notification")
            case .denied:
                DispatchQueue.main.async {
                    self.authorizedView.isHidden = true
                    self.unAuthorizedView.isHidden = false
                }
                print("User denied notification permission")
            case .notDetermined:
                DispatchQueue.main.async {
                    self.authorizedView.isHidden = false
                    self.switchButton.isOn = false
                    self.unAuthorizedView.isHidden = true
                    self.timeLabel.isHidden = true
                    self.timePicker.isHidden = true
                    self.titleTextField.isHidden = true
                    self.subtitleTextField.isHidden = true
                    self.pickerView.isHidden = true
                    self.applyButton.isHidden = true
                }
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

    // жест tap на вьюхе который дергает функцию dismissKeyboard() для убора клавиатуры
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    //    MARK: - IBActions
    
    // функция вызываемая при нажатии на свитч
    @objc func switchButtonTapped() {
        NotificationManager.requestNotificationAuthorization()
        if switchButton.isOn == false {
            self.timeLabel.isHidden = true
            self.timePicker.isHidden = true
            self.titleTextField.isHidden = true
            self.subtitleTextField.isHidden = true
            self.pickerView.isHidden = true
            self.applyButton.isHidden = true
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            print("Notifications is removed")
        } else {
            self.timeLabel.isHidden = false
            self.timePicker.isHidden = false
            self.titleTextField.isHidden = false
            self.subtitleTextField.isHidden = false
            self.pickerView.isHidden = false
            self.applyButton.isHidden = false
            
        }
    }
    
    @objc func applyButtonTapped() {
        // включение оповещения
        let notificationManger = NotificationManager()
        notificationManger.alarmDate = timePicker.date
        notificationManger.titleText = titleTextField.text ?? "Title not entered"
        notificationManger.subtitleText = subtitleTextField.text ?? "Subtitle not entered"
        notificationManger.applyNotification()
        //        проверка на пустые поля
        if titleTextField.text!.isEmpty {
            titleTextField.shake()
        }
        
        if subtitleTextField.text!.isEmpty {
            subtitleTextField.shake()
        }
    }
    
    // убирает клавиатуру
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //    переход в настройки приложения в телефоне
    @objc func settingWayButtonTapped() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
}

extension FirstViewController: UIPickerViewDataSource, UIPickerViewDelegate  {
    //  срабатывает перед уведомлением
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .badge])
        print(#function )
    }
    //  срабатывает при нажатии на уведомление
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        applyButton.tintColor = .red
        print(#function )
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languagesSet.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        languagesSet[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            languageOfApp = "en"
        case 1:
            languageOfApp = "de"
        default:
            languageOfApp = "en"
        }
        print("current = \(languageOfApp)")
    }
    
    func localiztionOfApp() {
        switchLabel.text = "switch_label".localized(locale: languageOfApp)
        timeLabel.text = "time_label".localized(locale: languageOfApp)
        titleTextField.placeholder = "title_placeholder".localized(locale: languageOfApp)
        subtitleTextField.placeholder = "subtitle_placeholder".localized(locale: languageOfApp)
        applyButton.setTitle("apply_button".localized(locale: languageOfApp), for: .normal)
    }
}

extension UIView {
    // функция анимации "перетряхивания" объекта
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension String {
    func localized(locale: String) -> String {
        if let path = Bundle.main.path(forResource: locale, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self,
                                     tableName: "Localizable",
                                     bundle: bundle,
                                     value: self,
                                     comment: self)
        } else {
            return NSLocalizedString("", comment: self)
        }
    }
}





