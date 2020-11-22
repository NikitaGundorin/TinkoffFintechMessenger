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
    
    // MARK: - Public properties
    
    var profileDataUpdatedHandler: (() -> Void)?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var profileImageView: ProfileImageView!
    @IBOutlet private weak var profileImageEditButton: UIButton!
    @IBOutlet private weak var gcdSaveButton: UIButton!
    @IBOutlet private weak var operationSaveButton: UIButton!
    @IBOutlet private weak var userNameTextView: UITextView!
    @IBOutlet private weak var userDescriptionTextView: UITextView!
    @IBOutlet private weak var userDescriptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userNameBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private properties
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    private let gcdDataManager: DataManager = GCDDataManager()
    private let operationDataManager: DataManager = OperationDataManager()
    private var person: PersonViewModel?
    private var personModel: PersonViewModel {
        .init(fullName: userNameTextView.text,
              description: userDescriptionTextView.text,
              profileImage: person?.profileImage)
    }
    private var originalUserImage: UIImage?
    private lazy var imagePickerDelegate =
        ImagePickerDelegate(errorHandler: { [weak self] in
            AlertHelper().presentErrorAlert(vc: self)
        }, imagePickedHandler: { [weak self] image in
            var imageChanged = !(self?.originalUserImage?.isEqual(to: image) ?? false)
            self?.imageChanged = imageChanged
            self?.setSaveButtonsEnabled(imageChanged || self?.nameChanged ?? true || self?.descriptionChanged ?? true)
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
    private lazy var nameTextViewDelegate = TextViewDelegate(textViewType: .nameTextView) { [weak self] in
        var textChanged = self?.person?.fullName != self?.userNameTextView.text
        self?.nameChanged = textChanged
        self?.setSaveButtonsEnabled(textChanged || self?.imageChanged ?? true || self?.descriptionChanged ?? true)
    }
    private lazy var descriptionTextViewDelegate = TextViewDelegate(textViewType: .descriptionTextView) { [weak self] in
        var textChanged = self?.person?.description != self?.userDescriptionTextView.text
        self?.descriptionChanged = textChanged
        self?.setSaveButtonsEnabled(textChanged || self?.imageChanged ?? true || self?.nameChanged ?? true)
    }
    private let lowPriority = UILayoutPriority(rawValue: 249)
    private var nameChanged = false
    private var descriptionChanged = false
    private var imageChanged = false
    
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
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
                    AlertHelper().presentErrorAlert(vc: self)
                }
            }]
        
        if person?.profileImage != nil {
            actions.append(UIAlertAction(title: "Remove Photo", style: .destructive) { [weak self] _ in
                self?.setProfileImage(image: nil)
                let imageChanged = self?.originalUserImage != nil
                self?.imageChanged = imageChanged
                self?.setSaveButtonsEnabled(imageChanged || self?.nameChanged ?? true || self?.descriptionChanged ?? true)
            })
        }
        
        actions.append(UIAlertAction(title: "Cancel", style: .cancel))
        actions.forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func gcdSaveButtonPressed(_ sender: Any) {
        saveButtonPressed(dataManager: gcdDataManager)
    }
    
    @IBAction private func operationButtonPressed(_ sender: Any) {
        saveButtonPressed(dataManager: operationDataManager)
    }
    
    // MARK: - Private methods
    
    private func loadData() {
        activityIndicator.startAnimating()
        let dataManager = gcdDataManager
        //let dataManager = operationDataManager
        
        dataManager.loadPersonData { [weak self] personViewModel in
            guard let person = personViewModel else {
                AlertHelper().presentAlert(vc: self,
                                           title: "Error",
                                           message: "Failed to load data",
                                           additionalActions: [.init(title: "Try again", style: .default) { [weak self] _ in
                                        self?.loadData()
                                    }]) { [weak self] _ in
                    self?.cancel()
                }
                return
            }
            
            self?.person = person
            self?.originalUserImage = person.profileImage
            
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.setupTextViews()
                self?.setProfileImage(image: person.profileImage)
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    private func setupLayout() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        gcdSaveButton.layer.cornerRadius = Appearance.baseCornerRadius
        gcdSaveButton.backgroundColor = Appearance.grayColor
        operationSaveButton.layer.cornerRadius = Appearance.baseCornerRadius
        operationSaveButton.backgroundColor = Appearance.grayColor
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel,
                                                  target: self,
                                                  action: #selector(cancel))
        navigationItem.title = "My Profile"
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .edit,
                                                  target: self,
                                                  action: #selector(toggleEditMode))
        view.backgroundColor = Appearance.backgroundColor

        userNameTextView.layer.cornerRadius = Appearance.baseCornerRadius
        userDescriptionTextView.layer.cornerRadius = Appearance.baseCornerRadius
        
        view.addSubview(activityIndicator)
        activityIndicator.backgroundColor = Appearance.selectionColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTextViews() {
        userNameTextView.text = person?.fullName
        userDescriptionTextView.text = person?.description
        userNameTextView.delegate = nameTextViewDelegate
        userDescriptionTextView.delegate = descriptionTextViewDelegate
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func saveButtonPressed(dataManager: DataManager) {
        exitEditMode()
        activityIndicator.startAnimating()
        dataManager.savePersonData(personModel) { [weak self] (isSuccessful: Bool) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            if isSuccessful {
                if let profileDataUpdatedHandler = self?.profileDataUpdatedHandler {
                    profileDataUpdatedHandler()
                }

                DispatchQueue.main.async {
                    if self?.profileImageView.profileImage == nil {
                        self?.setProfileImage(image: nil)
                    }
                    self?.originalUserImage = self?.person?.profileImage
                    self?.imageChanged = false
                    self?.nameChanged = false
                    self?.descriptionChanged = false
                    AlertHelper().presentAlert(vc: self, title: "Success", message: "Data saved successfully")
                }
            } else {
                AlertHelper().presentAlert(vc: self,
                                           title: "Error",
                                           message: "Failed to save data",
                                           additionalActions: [
                                            .init(title: "Try again", style: .default) { [weak self] _ in
                                                self?.saveButtonPressed(dataManager: dataManager)
                                            }]) { [weak self] _ in
                                                self?.setSaveButtonsEnabled(true)
                }
            }
        }
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            AlertHelper().presentErrorAlert(vc: self)
            return
        }
        
        imagePickerController.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePickerController, animated: true)
        }
    }
    
    private func setProfileImage(image: UIImage?) {
        person?.profileImage = image
        profileImageView.configure(with: personModel)
    }
    
    private func exitEditMode() {
        if userNameTextView.isUserInteractionEnabled {
            toggleEditMode()
        }
        setSaveButtonsEnabled(false)
    }
    
    private func setSaveButtonsEnabled(_ isEnabled: Bool) {
        gcdSaveButton.isEnabled = isEnabled
        operationSaveButton.isEnabled = isEnabled
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(false)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            keyboardSize.height > 0 {
            if userNameTextView.isFirstResponder {
                userNameBottomConstraint.constant = keyboardSize.height
                userNameBottomConstraint.priority = .required
                userDescriptionBottomConstraint.constant = 0
                userDescriptionBottomConstraint.priority = lowPriority
            } else if userDescriptionTextView.isFirstResponder {
                userDescriptionBottomConstraint.constant = keyboardSize.height
                userDescriptionBottomConstraint.priority = .required
                userNameBottomConstraint.constant = 0
                userNameBottomConstraint.priority = lowPriority
            }
            
            UIView.animate(withDuration: Appearance.defaultAnimationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        userNameBottomConstraint.constant = 0
        userNameBottomConstraint.priority = lowPriority
        userDescriptionBottomConstraint.constant = 0
        userDescriptionBottomConstraint.priority = lowPriority
        
        UIView.animate(withDuration: Appearance.defaultAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func toggleEditMode() {
        let backgroundColor = userNameTextView.isUserInteractionEnabled ? nil : Appearance.yellowSecondaryColor
        UIView.animate(withDuration: Appearance.defaultAnimationDuration) {
            self.userNameTextView.backgroundColor = backgroundColor
            self.userDescriptionTextView.backgroundColor = backgroundColor
        }
        userNameTextView.isUserInteractionEnabled.toggle()
        userDescriptionTextView.isUserInteractionEnabled.toggle()
    }
}
