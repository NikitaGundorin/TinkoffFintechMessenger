//
//  ProfileViewController.swift
//  TinkoffFintechMessenger
//
//  Created by Nikita Gundorin on 13.09.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileImageView: ProfileImageView!
    @IBOutlet private weak var profileImageEditButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var userNameTextView: UITextView!
    @IBOutlet private weak var userDescriptionTextView: UITextView!
    
    // MARK: - Private properties
    
    private let dataProvider: DataProvider = DummyDataProvider()
    private lazy var person = dataProvider.getUser()
    private lazy var imagePickerDelegate =
        ImagePickerDelegate(errorHandler: { [weak self] in
            self?.showErrorAlert()
        }, imagePickedHandler: { [weak self] image in
            self?.setProfileImage(image: image)
        })
    private lazy var imagePickerController: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = imagePickerDelegate
        vc.mediaTypes = [kUTTypeImage as String]
        return vc
    }()
    
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.configure(with: person)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLayout()
    }

    // MARK: - IBActions
    
    @IBAction private func profileImageEditButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        var actions = [
            UIAlertAction(title: "Open Gallery", style: .default) { [weak self] _ in
                self?.presentImagePicker(sourceType: .photoLibrary)
            },
            UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                if CameraManager.checkCameraPermission() {
                    self?.presentImagePicker(sourceType: .camera)
                } else {
                    self?.showErrorAlert()
                }
            }]
        
        if (person.profileImage != nil) {
            actions.append(UIAlertAction(title: "Remove Photo", style: .destructive) { [unowned self] _ in
                self.setProfileImage(image: nil)
            })
        }
        
        actions.append(UIAlertAction(title: "Cancel", style: .cancel))
        actions.forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        toggleEditMode()
    }
    
    // MARK: - Private methods
    
    private func setupLayout() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        saveButton.layer.cornerRadius = Appearance.baseCornerRadius
        saveButton.backgroundColor = Appearance.grayColor
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancel))
        navigationItem.title = "My Profile"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .edit,
                                                  target: self,
                                                  action: #selector(edit))
        view.backgroundColor = Appearance.backgroundColor

        userNameTextView.layer.cornerRadius = Appearance.baseCornerRadius
        userDescriptionTextView.layer.cornerRadius = Appearance.baseCornerRadius
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            showErrorAlert()
            return
        }
        
        imagePickerController.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "This action is not allowed.", preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    private func setProfileImage(image: UIImage?) {
        person.profileImage = image
        profileImageView.configure(with: person)
    }
    
    private func toggleEditMode() {
        let backgroundColor = userNameTextView.isUserInteractionEnabled ? nil : Appearance.yellowSecondaryColor
        UIView.animate(withDuration: 0.3) {
            self.userNameTextView.backgroundColor = backgroundColor
            self.userDescriptionTextView.backgroundColor = backgroundColor
        }
        userNameTextView.isUserInteractionEnabled.toggle()
        userDescriptionTextView.isUserInteractionEnabled.toggle()
        navigationItem.rightBarButtonItem?.isEnabled.toggle()
        saveButton.isEnabled.toggle()
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func edit() {
        toggleEditMode()
    }
}
