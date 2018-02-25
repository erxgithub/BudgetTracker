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

class DetailViewController: UIViewController {
  
  var data: [[String: Any]]?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sortButton: UIButton!
  
  var amountTitle: String!
  var dateTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
      sortTableData(amountAscending: false, dateAscending: false)
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
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
      let alert = UIAlertController(title: "Sort Direction", message: nil, preferredStyle: .actionSheet)

      let sortTitle1 = "Amount " + "\u{25BC}" + " Date " + "\u{25BC}"
      let sortTitle2 = "Amount " + "\u{25BC}" + " Date " + "\u{25B2}"
      let sortTitle3 = "Amount " + "\u{25B2}" + " Date " + "\u{25BC}"
      let sortTitle4 = "Amount " + "\u{25B2}" + " Date " + "\u{25B2}"

      let sortOption1 = UIAlertAction(title: sortTitle1, style: .default, handler: { action in
        self.sortTableData(amountAscending: false, dateAscending: false)
      })
      
      let sortOption2 = UIAlertAction(title: sortTitle2, style: .default, handler: { action in
        self.sortTableData(amountAscending: false, dateAscending: true)
      })
      
      let sortOption3 = UIAlertAction(title: sortTitle3, style: .default, handler: { action in
        self.sortTableData(amountAscending: true, dateAscending: false)
      })
      
      let sortOption4 = UIAlertAction(title: sortTitle4, style: .default, handler: { action in
        self.sortTableData(amountAscending: true, dateAscending: true)
      })

      let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
        
      }
      
      alert.addAction(sortOption1)
      alert.addAction(sortOption2)
      alert.addAction(sortOption3)
      alert.addAction(sortOption4)
      alert.addAction(cancel)
      
      self.present(alert, animated: true)
    }
  
  func sortTableData(amountAscending: Bool, dateAscending: Bool) {
    self.data?.sort {
      guard let s1 = $0["datestamp"] as? String, let s2 = $1["datestamp"] as? String else {
        return false
      }
      
      if s1 == s2 {
        guard let g1 = $0["amount"] as? Int32, let g2 = $1["amount"] as? Int32 else {
          return false
        }
        
        if amountAscending {
          return g1 < g2
        } else {
          return g1 > g2
        }
      }
      
      if dateAscending {
        return s1 < s2
      } else {
        return s1 > s2
      }
    }
    
    if amountAscending {
      self.amountTitle = "Amount " + "\u{25B2}"
    } else {
      self.amountTitle = "Amount " + "\u{25BC}"
    }
    
    if dateAscending {
      self.dateTitle = "Date " + "\u{25B2}"
    } else {
      self.dateTitle = "Date " + "\u{25BC}"
    }
    
    self.tableView.reloadData()
  }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data!.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell  else {
      fatalError("The dequeued cell is not an instance of UITableViewCell.")
    }

    if indexPath.row == 0 {
      cell.amountLabel.text = amountTitle
      cell.amountLabel.sizeToFit()
      
      cell.timeStampLabel.text = dateTitle
      cell.timeStampLabel.sizeToFit()
      
      return cell
    }
    
    let transaction = data![indexPath.row - 1]
    let amount = transaction["amount"] as! Int32
    let datestamp = transaction["datestamp"]
    
//    let timestamp = transaction["timestamp"]
//
//    let dateTime = Date(timeIntervalSince1970: TimeInterval(timestamp))
//    let dateFormatter = DateFormatter()
//    //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
//    //dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
//    dateFormatter.dateFormat = "yyyy/MM/dd"
//    let transactionDate = dateFormatter.string(from: dateTime)
//
//    cell.timeStampLabel.text = "\(transactionDate)"
//    cell.timeStampLabel.sizeToFit()

    cell.amountLabel.text = "$\(amount)"
    cell.amountLabel.sizeToFit()
    
    cell.timeStampLabel.text = datestamp as? String
    cell.timeStampLabel.sizeToFit()

    return cell
  }
  
}
