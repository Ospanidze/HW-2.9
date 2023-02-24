//
//  MainViewController.swift
//  HW 2.4
//
// Created by Айдар Оспанов on 24.02.2023.
//

import UIKit

//MARK: Protocol ColorViewControllerDelegate

protocol ColorViewControllerDelegate: AnyObject {
    func setup(color: UIColor)
}

final class MainViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingVC = segue.destination as? ColorViewController else { return }
        settingVC.color = view.backgroundColor
        settingVC.delegate = self
    }

}

//MARK: ColorViewControllerDelegate

extension MainViewController: ColorViewControllerDelegate {
    func setup(color: UIColor) {
        view.backgroundColor = color
    }
}

