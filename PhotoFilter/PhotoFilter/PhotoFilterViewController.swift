import UIKit
import CoreImage
import Photos

class PhotoFilterViewController: UIViewController {

    var originalImage: UIImage? {
        didSet {

        }
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

    private func filterImage(_ image: UIImage) -> UIImage {
        // TODO: return the filtered image
        return image
    }

	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// TODO: show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {

		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {

	}
	
	@IBAction func contrastChanged(_ sender: Any) {

	}
	
	@IBAction func saturationChanged(_ sender: Any) {

	}
}
