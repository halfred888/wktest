import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do
        {
            let testHTML = Bundle.main.path(forResource: "test", ofType: "html")
            let contents = try NSString(contentsOfFile: testHTML!, encoding: String.Encoding.utf8.rawValue)
            let baseUrl = NSURL(fileURLWithPath: testHTML!)
            webView.loadHTMLString(contents as String, baseURL: baseUrl as URL)
        } catch {
             print("Unexpected error: \(error).")
        }
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowOrHide(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowOrHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc
    func keyboardWillShowOrHide(notification: NSNotification) {
        
        let userInfo = notification.userInfo
        let endValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        let scrollView = webView.scrollView
        let durationValue = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curveValue = userInfo![UIKeyboardAnimationCurveUserInfoKey] as! Int
        // Pull a bunch of info out of the notification
        
        // Transform the keyboard's frame into our view's coordinate system
        let endRect = view.convert(endValue, from: view.window)
        // Transform the keyboard's frame into our view's coordinate system
        // let endRect = view.convertRect(endValue.CGRectValue, fromView: view.window)
        
        // Find out how much the keyboard overlaps the scroll view
        // We can do this because our scroll view's frame is already in our view's coordinate system
        let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
        
        // Set the scroll view's content inset to avoid the keyboard
        // Don't forget the scroll indicator too!
        scrollView.contentInset.bottom = keyboardOverlap
        scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
        
        let duration = durationValue
        let options = UIViewAnimationOptions(rawValue: UInt(curveValue << 16))
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

