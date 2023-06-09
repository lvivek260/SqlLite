//
//  DBManager.swift
//  SqlLite
//
//  Created by Admin on 20/03/23.
//

import Foundation
import SQLite3

class DBManager
{
    init()
    {
        db = openDatabase()
        createTable()
    }
  
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
  
  
    func openDatabase() -> OpaquePointer?
    {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            debugPrint("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(dbPath)")
            return db
        }
    }
      
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS students(firstName TEXT,lastName TEXT,marks INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("student table created.")
            } else {
                print("student table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
      
      
    func insert(fname:String, lname:String, marks:Int)
    {
        let students = read()
        for s in students
        {
            if s.marks == marks
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO students (firstName, lastName, marks) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (fname as NSString).utf8String,-1,nil)
            sqlite3_bind_text(insertStatement, 2, (lname as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(marks))
              
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        }
        else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
      
    
    func read() -> [Student] {
        let queryStatementString = "SELECT * FROM students;"
        var queryStatement: OpaquePointer? = nil
        var students : [Student] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let fname = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let lname = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let marks = sqlite3_column_int(queryStatement, 2)
                students.append(Student(firstName: fname, lastName: lname, marks: Int(marks)))
                print("Query Result:")
                print("\(fname) | \(lname) | \(marks)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return students
    }
    
      
    func delete(fname:String, lname:String, marks:Int) {
               let deleteStatementString = "DELETE FROM students WHERE firstName = ? AND lastName = ? AND marks = ?;"
                
               var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                   sqlite3_bind_text(deleteStatement, 1, (fname as NSString).utf8String,-1,nil)
                   sqlite3_bind_text(deleteStatement, 2, (lname as NSString).utf8String,-1,nil)
                   sqlite3_bind_int(deleteStatement, 3, Int32(marks))
                   if sqlite3_step(deleteStatement) == SQLITE_DONE {
                       print("Successfully deleted row.")
                   } else {
                       print("Could not delete row.")
                   }
            }
            else {
                   print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(deleteStatement)
    }
    
    
    func update(fname:String, lname:String, marks:Int,s:Student) {
               let updateStatementString = "UPDATE students SET firstName = ? , lastName = ? ,marks = ? Where firstName = ? AND lastName = ? AND marks = ? ;"
            
               var updateStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(updateStatement, 1, (fname as NSString).utf8String,-1,nil)
                sqlite3_bind_text(updateStatement, 2, (lname as NSString).utf8String,-1,nil)
                sqlite3_bind_int(updateStatement, 3, Int32(marks))
                sqlite3_bind_text(updateStatement, 4, (s.firstName as NSString).utf8String,-1,nil)
                sqlite3_bind_text(updateStatement, 5, (s.lastName as NSString).utf8String,-1,nil)
                sqlite3_bind_int(updateStatement, 6, Int32(s.marks))
                   if sqlite3_step(updateStatement) == SQLITE_DONE {
                       print("Successfully updated row.")
                   } else {
                       print("Could not delete row.")
                   }
            }
            else {
                   print("Update statement could not be prepared")
            }
            sqlite3_finalize(updateStatement)
    }
      
}
