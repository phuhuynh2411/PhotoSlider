import UIKit

// MARK: PhotoSliderView

class PhotoSliderView: UIView {
    
    // MARK: Properties
    private var circular: Bool = false
    var showPageIndicator: Bool = true {
        willSet{
            pageControl.isHidden = !newValue
        }
    }
 
    // MARK: Outlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!

    // MARK: Configure Methods
    
    func configure(with images: [UIImage], circular: Bool = false, timeInterval: Double? = nil) {
        
        // Do nothing if the images is empty.
        guard images.count > 0 else { return }
        
        // If circular is true, add the first image after the last image and add the last image before the first image
        var circularImages: [UIImage]?
        if circular {
            circularImages = []
            if let lastImage = images.last {
                circularImages?.append(lastImage)
            }
            circularImages?.append(contentsOf: images)
            if let firstImage = images.first {
                circularImages?.append(firstImage)
            }
        }
        self.circular = circular
        
        // Determine whether using the images or circular images
        let scrollImages = circular ? circularImages! : images
       
        // Get the scrollView width and height
        let scrollViewWidth: CGFloat = scrollView.frame.width
        let scrollViewHeight: CGFloat = scrollView.frame.height
        
        // Loop through all of the images and add them all to the scrollView
        for (index, image) in scrollImages.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: scrollViewWidth * CGFloat(index),
                                                      y: 0,
                                                      width: scrollViewWidth,
                                                      height: scrollViewHeight))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
        }
        
        // Set the scrollView contentSize
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(scrollImages.count),
                                        height: scrollView.frame.height)
        
        // Ensure that the pageControl knows the number of pages
        pageControl.numberOfPages = images.count
        
        pageControl.currentPage = 0
        // Set the current page to 0 or 1
        let firstPage = circularImages == nil ? 0 : 1
        scrollToIndex(index: firstPage, animated: false)
        
        // Auto go to the next page if the time interval is set
        guard timeInterval != nil else { return }
        
       
        Timer.scheduledTimer(withTimeInterval: timeInterval!, repeats: true) { (timer) in
            
            let nextPage = self.pageControl.currentPage + 1
            let goToPage = self.circular ? nextPage + 1 : nextPage
            self.scrollToIndex(index: goToPage)

            if nextPage >= self.pageControl.numberOfPages {
                self.pageControl.currentPage = 0

                // Reset the page after 1 second
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                    self.scrollToIndex(index: 1, animated: false)
                }
            } else {
                self.pageControl.currentPage = nextPage
            }
            
        }
        
    }
    
    // MARK: Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: PhotoSliderView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: Helper Methods
    
    @IBAction func pageControlTap(_ sender: Any?) {
        guard let pageControl: UIPageControl = sender as? UIPageControl else {
            return
        }
        
        scrollToIndex(index: pageControl.currentPage)
    }
    
    private func scrollToIndex(index: Int, animated: Bool = true) {
        
        let pageWidth: CGFloat = scrollView.frame.width
        let slideToX: CGFloat = CGFloat(index) * pageWidth
        
        scrollView.scrollRectToVisible(CGRect(x: slideToX, y:0, width:pageWidth, height:scrollView.frame.height), animated: animated)
    
    }
}

// MARK: UIScrollViewDelegate

extension PhotoSliderView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        pageControl.currentPage = Int(currentPage)
        
        // Only runs the code below if it is circular images
        guard circular else { return }
        
        // Reduce the current page number
        pageControl.currentPage = Int(currentPage) - 1
        
        let pageHeight = scrollView.frame.height
        // Go to the last image when it is at the first one, and the user keeps
        // swiping the left side of the screen.
        if scrollView.contentOffset.x == 0 {
            scrollView.scrollRectToVisible(CGRect(x: CGFloat(pageControl.numberOfPages) * pageWidth, y: 0, width: pageWidth, height: pageHeight), animated: false)
            // Set the current page to the last page
            pageControl.currentPage = pageControl.numberOfPages - 1
        }
        // Go to the first image when it is at the, and the user keeps
        // swiping to the right side of the screen.
        else if scrollView.contentOffset.x == CGFloat(pageControl.numberOfPages + 1) * pageWidth{
             scrollView.scrollRectToVisible(CGRect(x: pageWidth, y: 0, width: pageWidth, height: pageHeight), animated: false)
            // Set the current page to the first page
            pageControl.currentPage = 0
        }
        
    }
    
}
