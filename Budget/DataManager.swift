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
import SQLite3

class DataManager: NSObject {

  let dailyBudget = NSDecimalNumber(string: "10.00")
  var spent = NSDecimalNumber(string: "0.00")

  let db = SQLiteDatabase()

  func budgetRemainingToday() -> NSDecimalNumber {
    let startOfDay = NSCalendar.current.startOfDay(for: Date())
    
    // Components to calculate end of day
    var components = DateComponents()
    components.day = 1
    components.second = -1
    
    let endOfDay = NSCalendar.current.date(byAdding: components, to: startOfDay)
    
    let query = """
      SELECT sum(amount) FROM transactions WHERE timestamp >=\(Int(startOfDay.timeIntervalSince1970))
        AND timestamp >=\(Int(endOfDay!.timeIntervalSince1970));
    """
    
    let result = db.execute(complexQuery: query)
    print(result)
    
    return dailyBudget.subtracting(spent)
  }
  
  func spend(amount: NSDecimalNumber, time: Date) {
    spent = spent.adding(amount)
    
    let query = """
      INSERT INTO transactions (amount, timestamp) VALUES
        (\(Int(truncating: amount)), \(Int(Date().timeIntervalSince1970)));
    """
    
    try? db.execute(simpleQuery: query)
  }
  
  func initialSetup() {
    try? db.openDatabase(name: "budget.db")

    let query = """
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY,
        amount INTEGER,
        timestamp INTEGER
      );

      CREATE TABLE daily_budgets (
        id INTEGER PRIMARY KEY,
        amount INTEGER
      );
    """
    
    try? db.execute(simpleQuery: query)
  }

}
