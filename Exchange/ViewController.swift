//
//  ViewController.swift
//  Exchange
//
//  Created by Damir Zaripov on 04.05.2023.
//

import UIKit

class ViewController: UIViewController  {
    
    //MARK: - Delegates
    
    var coinManager = CoinManager()
    //MARK: - Elements
    
    private lazy var bitcoinTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        
        let bitcoinImage = UIImageView()
        bitcoinImage.image = UIImage(systemName: "bitcoinsign.circle.fill")
        bitcoinImage.tintColor = UIColor(named: "Icon Color")
        bitcoinImage.translatesAutoresizingMaskIntoConstraints = false
        
        let bitcoinLabel = UILabel()
        bitcoinLabel.text = "..."
        bitcoinLabel.font = UIFont.boldSystemFont(ofSize: 25)
        bitcoinLabel.textAlignment = .right
        bitcoinLabel.textColor = .white
        bitcoinLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let currencyLabel = UILabel()
        currencyLabel.text = "USD"
        currencyLabel.font = UIFont.boldSystemFont(ofSize: 25)
        currencyLabel.textAlignment = .center
        currencyLabel.textColor = .white
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stackView = UIStackView(arrangedSubviews: [bitcoinImage, bitcoinLabel, currencyLabel])
        stackView.backgroundColor = .tertiaryLabel
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        bitcoinImage.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        bitcoinImage.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        bitcoinImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        bitcoinLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 25).isActive = true
        bitcoinLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -25).isActive = true
        bitcoinLabel.leadingAnchor.constraint(equalTo: bitcoinImage.trailingAnchor, constant: 10).isActive = true
        bitcoinLabel.trailingAnchor.constraint(equalTo: currencyLabel.leadingAnchor, constant: -10).isActive = true
        
        currencyLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 25).isActive = true
        currencyLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -25).isActive = true
        currencyLabel.leadingAnchor.constraint(equalTo: bitcoinLabel.trailingAnchor, constant: 10).isActive = true
        
        return stackView
    }()
    
    private lazy var currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    
    //MARK: - Methods
    private func setupView() {
        view.addSubview(bitcoinTitleLabel)
        view.addSubview(stackView)
        view.addSubview(currencyPicker)
    }
    //MARK: - Constraints
    private func setConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            bitcoinTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            bitcoinTitleLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: bitcoinTitleLabel.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 80),
            
            currencyPicker.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            currencyPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            currencyPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            currencyPicker.heightAnchor.constraint(equalToConstant: 220),
            
            
        ])
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background Color")
        setupView()
        setConstraints()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
}

//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didUpdateExchange(price: String, currency: String) {
        DispatchQueue.main.async {
            if let label = self.stackView.arrangedSubviews[1] as? UILabel {
                label.text = price
            }
            if let label = self.stackView.arrangedSubviews[2] as? UILabel {
                label.text = currency
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedValue)
    }}

