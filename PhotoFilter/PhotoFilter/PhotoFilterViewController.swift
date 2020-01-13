import UIKit
import CoreImage
import Photos

class PhotoFilterViewController: UIViewController {

    var originalImage: UIImage? {
        didSet { updateImage() }
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

	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		presentImagePickerController()
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {

		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {
        updateImage()
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
        updateImage()
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
        updateImage()
	}

    private func updateImage() {
        imageView.image = filterImage(originalImage)
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
