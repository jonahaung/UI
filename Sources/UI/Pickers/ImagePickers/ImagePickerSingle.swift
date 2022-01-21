//
//  ImagePickerSingle.swift
//  MyBike
//
//  Created by Aung Ko Min on 16/11/21.
//

import SwiftUI

public struct ImagePickerSingle: UIViewControllerRepresentable {
    
    public typealias OnPick = (UIImage) -> Void
    private var autoDismiss = true
    private var onPick: OnPick
    
    @Environment(\.presentationMode) private var presentationMode
    
    public init(autoDismiss: Bool, onPick: @escaping OnPick) {
        self.autoDismiss = autoDismiss
        self.onPick = onPick
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_: UIImagePickerController, context _: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public  class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        private let parent: ImagePickerSingle
        
        public init(_ parent: ImagePickerSingle) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage ?? info[.editedImage] as? UIImage{
                self.parent.onPick(image)
                if self.parent.autoDismiss {
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
