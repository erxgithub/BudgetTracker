// Copyright (c) 2018 Lighthouse Labs. All rights reserved.
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

enum SQLiteError: Error {
  case openDatabase
  case execute
  case closeDatabase
  case prepare
  case step
  case finalize
}

class SQLiteDatabase: NSObject {
  
  var database: OpaquePointer?
  
  func openDatabase(name: String) throws {
    let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(name)
    print(fileURL)
    
    let status = sqlite3_open(fileURL.path, &database)
    if status != SQLITE_OK {
      print("error opening database")
    }
  }
  
  func execute(simpleQuery query: String) throws {
    let status = sqlite3_exec(database, query, nil, nil, nil)
    if status != SQLITE_OK {
      throw SQLiteError.execute
    }
  }
  
  func closeDatabase() {
    let status = sqlite3_close(database)
    if status != SQLITE_OK {
      print("error closing database")
    }
  }
  
  func execute(complexQuery query: String) throws -> [[String: String]] {
    var queryStatement: OpaquePointer? = nil
    guard sqlite3_prepare_v2(database, query, -1, &queryStatement, nil) == SQLITE_OK else {
      throw SQLiteError.prepare
    }
    
    var stepStatus = sqlite3_step(queryStatement)
    let numberOfColumns = sqlite3_column_count(queryStatement)
    
    var rows = [[String: String]]()
    
    while(stepStatus == SQLITE_ROW) {
      var row = [String: String]()
      
      for i in 0..<numberOfColumns {
        let columnName = String(cString: sqlite3_column_name(queryStatement, Int32(i)))
        let columnText = String(cString: sqlite3_column_text(queryStatement, Int32(i)))
        row[columnName] = columnText
      }
      
      rows.append(row)
      
      stepStatus = sqlite3_step(queryStatement)
    }
    
    if stepStatus != SQLITE_DONE {
      throw SQLiteError.execute
    }
    
    let finalizeStatus = sqlite3_finalize(queryStatement)
    if finalizeStatus != SQLITE_OK {
      throw SQLiteError.execute
    }
    
    return rows
  }
  
  deinit {
    closeDatabase()
  }
  
}
