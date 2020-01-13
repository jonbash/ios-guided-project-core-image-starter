import UIKit
import CoreImage
import Photos

class PhotoFilterViewController: UIViewController {

    var originalImage: UIImage? {
        didSet { scaledImage = scaleImage(originalImage) }
    }

    var scaledImage: UIImage? {
        didSet { updateImageView() }
    }

    private var filter = CIFilter(name: "CIColorControls")!
    private var context = CIContext(options: nil)

	@IBOutlet var brightnessSlider: UISlider!
	@IBOutlet var contrastSlider: UISlider!
	@IBOutlet var saturationSlider: UISlider!
	@IBOutlet var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

        originalImage = imageView.image
	}

    private func filterImage(_ image: UIImage?) -> UIImage? {
        guard
            let thisImage = image,
            let cgImage = thisImage.cgImage else { return image } // CGImage = pixel/bitmap data
        let ciImage = CIImage(cgImage: cgImage)

        // set up filter
        filter.setValuesForKeys([
            kCIInputImageKey: ciImage,
            kCIInputBrightnessKey: brightnessSlider.value,
            kCIInputContrastKey: contrastSlider.value,
            kCIInputSaturationKey: saturationSlider.value
        ])

        guard
            let outputCIImage = filter.outputImage,     // get output
            let outputCGImage = context.createCGImage(  // render image
                outputCIImage,
                from: CGRect(origin: CGPoint.zero,
                             size: thisImage.size))
            else { return thisImage }

        return UIImage(cgImage: outputCGImage)          // convert to uiimage
    }

    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("photo library not available")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }

    private func scaleImage(_ image: UIImage?) -> UIImage? {
        // Height and width
        var scaledSize = imageView.bounds.size
        // 1x, 2x, or 3x
        let scale = UIScreen.main.scale
        scaledSize = CGSize(width: scaledSize.width * scale, height: scaledSize.height * scale)
        return image?.imageByScaling(toSize: scaledSize)
    }

    func saveFilteredImage() {
        guard
            let processedImage = filterImage(originalImage?.flattened)
            else { return }

        PHPhotoLibrary.requestAuthorization { (status) in
            guard status == .authorized else { return }
            // Let the library know we are going to make changes
            PHPhotoLibrary.shared().performChanges({
                // Make a new photo creation request
                PHAssetCreationRequest.creationRequestForAsset(from: processedImage)
            }, completionHandler: { (success, error) in
                if let error = error {
                    NSLog("Error saving photo: \(error)")
                    return
                }
                DispatchQueue.main.async {
                    print("Saved image!")
                }
            })
        }
    }

	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		presentImagePickerController()
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
        saveFilteredImage()
    }

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {
        updateImageView()
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
        updateImageView()
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
        updateImageView()
	}

    private func updateImageView() {
        imageView.image = filterImage(scaledImage)
    }
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        // use edited image if exists; if not, use original image
        if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
            originalImage = image.flattened
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotoFilterViewController: UINavigationControllerDelegate {

}
