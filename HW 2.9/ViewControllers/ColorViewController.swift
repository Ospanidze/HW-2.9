//
//  ColorViewController.swift
//  HW 2.9
//
//  Created by Айдар Оспанов on 24.02.2023.
//

import UIKit

final class ColorViewController: UIViewController {
    
    //MARK: @IBOutlets
    
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    //MARK: Public Properties
    
    var color: UIColor!
    unowned var delegate: ColorViewControllerDelegate!
    
    //MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        colorView.layer.cornerRadius = 15
        colorView.backgroundColor = color
        
        setSliders()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: @IBActions
    
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        switch sender {
        case redSlider:
            redLabel.text = string(from: redSlider)
            redTextField.text = string(from: redSlider)
        case greenSlider:
            greenLabel.text = string(from: greenSlider)
            greenTextField.text = string(from: greenSlider)
        default:
            blueLabel.text = string(from: blueSlider)
            blueTextField.text = string(from: blueSlider)
        }
    }
    
    @IBAction func dobeButtonAction(_ sender: UIButton) {
        delegate.setup(color: colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    
    //MARK: Private Methods
    
    private func setColor() {
        colorView.backgroundColor  = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label {
            case redLabel:
                redLabel.text = string(from: redSlider)
            case greenLabel:
                greenLabel.text = string(from: greenSlider)
            default:
                blueLabel.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        let bar = UIToolbar()
        let done = UIBarButtonItem(title: "Done",
                                   style: .done,
                                   target: self,
                                   action: #selector(doneTapped))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        
        bar.items = [flexibleSpace, done]
        bar.sizeToFit()
        
        textFields.forEach { textField in
            textField.inputAccessoryView = bar
            
            switch textField {
            case redTextField:
                redTextField.text = string(from: redSlider)
            case greenTextField:
                greenTextField.text = string(from: greenSlider)
            default:
                blueTextField.text = string(from: blueSlider)
            }
        }
    }
    
    @objc private func doneTapped() {
        view.endEditing(true)
    }
    
    private func setSliders() {
        let ciColor = CIColor(color: color)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    
}

//MARK: ShowAlertController

extension ColorViewController {
    private func showAlertController(title: String, message: String) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}

//MARK: UITextFieldDelegate

extension ColorViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue),
              numberValue >= 0 && numberValue <= 1 else {
            showAlertController(title: "Error",
                                message: "Enter numbers from 0.00 to 1.00")
            return
        }
        switch textField {
        case redTextField:
            redSlider.setValue(numberValue, animated: true)
            setValue(for: redLabel)
        case greenTextField:
            greenSlider.setValue(numberValue, animated: true)
            setValue(for: greenLabel)
        default:
            blueSlider.setValue(numberValue, animated: true)
            setValue(for: blueLabel)
        }
        setColor()
    }
}

