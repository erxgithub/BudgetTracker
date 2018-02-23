// Copyright (c) 2017 Lighthouse Labs. All rights reserved.
// 
// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
// distribute, sublicense, create a derivative work, and/or sell copies of the
// Software in any work that is designed, intended, or marketed for pedagogical or
// instructional purposes related to programming, coding, application development,
// or information technology.  Permission for such use, copying, modification,
// merger, publication, distribution, sublicensing, creation of derivative works,
// or sale is expressly withheld.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class AllTransactionsViewController: UIViewController {
  
  var dataManager: DataManager!
  var data: [[String: Any]]?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      data = dataManager.getAllTransactions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func backButton(_ sender: UIButton) {
      navigationController?.popViewController(animated: true)
      dismiss(animated: true, completion: nil)
    }
}

extension AllTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data!.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell  else {
      fatalError("The dequeued cell is not an instance of UITableViewCell.")
    }

    if indexPath.row == 0 {
      cell.amountLabel.text = "Amount"
      cell.timeStampLabel.text = "Date"
      
      return cell
    }
    
    let transaction = data![indexPath.row - 1]
    let amount = transaction["amount"] as! Int32
    let timestamp = transaction["timestamp"] as! Int32
    
    let dateTime = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
    //dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let transactionDate = dateFormatter.string(from: dateTime)
    
    cell.amountLabel.text = "$\(amount)"
    cell.amountLabel.sizeToFit()
    
    cell.timeStampLabel.text = "\(transactionDate)"
    cell.timeStampLabel.sizeToFit()

    return cell
  }
  
}
