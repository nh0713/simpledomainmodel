//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    switch self.currency {
        case "USD":
            switch to {
                case "GBP":
                    return Money(amount: self.amount / 2, currency: "GBP")
                case "EUR":
                    return Money(amount: self.amount / 2 + self.amount, currency: "EUR")
                case "CAN":
                    return Money(amount: self.amount / 4 + self.amount, currency: "CAN")
                default:
                    return Money(amount: self.amount, currency: self.currency)
            }
        case "GBP":
            switch to {
            case "USD":
                return Money(amount: self.amount * 2, currency: "USD")
            case "EUR":
                return Money(amount: self.amount * 2 + self.amount, currency: "EUR")
            case "CAN":
                return Money(amount: self.amount * 2 + self.amount / 2, currency: "CAN")
            default:
                return Money(amount: self.amount, currency: self.currency)
            }
        case "EUR":
            switch to {
            case "USD":
                return Money(amount: self.amount * 2 / 3, currency: "USD")
            case "GBP":
                return Money(amount: self.amount * 2 / 6, currency: "GBP")
            case "CAN":
                return Money(amount: self.amount * 2 / 3 + (self.amount * 2 / 12), currency: "CAN")
            default:
                return Money(amount: self.amount, currency: self.currency)
            }
        case "CAN":
            switch to {
                case "USD":
                    return Money(amount: self.amount * 4 / 5, currency: "USD")
                case "GBP":
                    return Money(amount: self.amount * 4 / 10, currency: "GBP")
                case "EUR":
                    return Money(amount: self.amount * 6 / 5, currency: "EUR")
                default:
                    return Money(amount: self.amount, currency: self.currency)
            }
        default:
            return Money(amount: self.amount, currency: "Unknown Currency")
    }
  }
    
  public func add(_ to: Money) -> Money {
    return Money(amount : self.convert(to.currency).amount + to.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    return Money(amount : self.convert(from.currency).amount - from.amount, currency: from.currency)
  }
}

//////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
    
    func getHourly() -> Double {
        switch self {
            case .Hourly(let hourly):
                return hourly
            default:
                return 0.0
        }
    }
    
    func getSalary() -> Int{
        switch self {
            case .Salary(let salary):
                return salary
            default:
                return 0
        }
    }
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hourly):
        return Int(hourly * Double(hours))
    case .Salary(let sal):
        return sal
    }
  }

  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hourly):
        self.type = .Hourly(amt + hourly)
    case .Salary(let sal):
        self.type = .Salary(Int(amt) + sal)
    }
  }
}

//////////////////////////////////
// Person

open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return self._job
    }
    set(value) {
        if self.age < 16 {
            self._job = nil
        } else {
            self._job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return self._spouse
    }
    set(value) {
        if self.age < 18 {
            self._spouse = nil
        } else {
            self._spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self._job) spouse:\(self._spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    if members[0].age > 21 || members[1].age > 21 {
        members.append(child)
        return true
    }
    return false
  }

  open func householdIncome() -> Int {
    var income = 0
    for member in members {
        if member.job != nil {
            income += (member.job?.calculateIncome(2000))!
        }
    }
    return income
  }
}





