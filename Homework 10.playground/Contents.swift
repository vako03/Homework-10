import UIKit
//////
//////თქვენი დავალებაა კარგათ გაერკვეთ როგორ მუშაობს ARC სხვადასხვა იმპლემენტაციების გამოყენებით.
//////
//////შექმენით ციკლური რეფერენცები და გაწყვიტეთ
//////აუცილებელია ქლოჟერების გამოყენება
//////აუცილებელია value და რეფერენს ტიების გამოყენება (კლასები, სტრუქტურები, ენამები და პროტოკოლები)
//////აუცილებელია გამოიყენოთ strong, weak & unowned რეფერენსები ერთხელ მაინც
//////დაიჭირეთ self ქლოჟერებში
//////გატესტეთ მიღებული შედეგები ინსტანსების შექმნით და დაპრინტვით

//სტრუქტურის გამოყენებით
class University {
    var name: String
    var founderYear: Int
    var courses: [Course] = []
    weak var student: Student?
    
    init(name: String, founderYear: Int) {
        self.name = name
        self.founderYear = founderYear
    }
    
    deinit {
        print("University deinited")
    }
}

struct Course {
    var name: String
    var code: String
    var credits: Int
}

class Student {
    var name: String
    var program: String
    weak var university: University?
    var enrolledCourses: [Course] = []
    
    init(name: String, program: String) {
        self.name = name
        self.program = program
    }
    
    deinit {
        print("\(name) is being deinited")
        university?.student = nil
    }
    
    func enroll(in university: University, forCourse courseCode: String) {
        self.university = university
        // Use a closure to capture self strongly
        if let course = university.courses.first(where: { $0.code == courseCode }) {
            enrolledCourses.append(course)
            print("\(name) enrolled in \(course.name) course at \(university.name)")
        } else {
            print("Course with code \(courseCode) not found in \(university.name)")
        }
    }
}


var university: University? = University(name: "TBC Academy", founderYear: 2023)

let iosCourse = Course(name: "iOS Development", code: "IOS", credits: 3)
let androidCourse = Course(name: "Android Development", code: "ANDROID", credits: 3)

university?.courses = [iosCourse, androidCourse]

var student: Student? = Student(name: "Dua Lipa", program: "Ios")
student?.enroll(in: university!, forCourse: "IOS")

student?.university = university
university?.student = student

university = nil
student = nil





/// პროტოკოლის გამოყენებით

protocol CreditCardHolder {
    var cards: [CreditCard] { get set }
    func payMonthlyCommission(completion: () -> Void)
}

class Person: CreditCardHolder {
    let name: String
    var cards: [CreditCard] = []
    let smsBankingCommission: Double = 1.0
    
    init(name: String) {
        self.name = name
        print("Person \(name) is being initialized.")
    }
    
    deinit {
        print("Person \(name) is being deinited.")
    }
    
    func payMonthlyCommission(completion: () -> Void) {
        let totalCommission = smsBankingCommission * Double(cards.count)
        print("\(name) paid monthly SMS banking commission of \(totalCommission) GEL")
        completion()
    }
}

class CreditCard {
    let number: String
    let expiry: String
    unowned let owner: Person
    
    init(owner: Person, number: String, expiry: String) {
        self.owner = owner
        self.number = number
        self.expiry = expiry
        print("Credit card \(number) owned by \(owner.name) is being initialized.")
    }
    
    deinit {
        print("Credit card \(number) owned by \(owner.name ) is being deinited.")
    }
}

var worker: Person? = Person(name: "Gela")
print()

let card = CreditCard(owner: worker!, number: "123456789", expiry: "12/29")
let otherCard = CreditCard(owner: worker!, number: "987654321", expiry: "06/30")

worker?.cards = [card, otherCard]

worker?.payMonthlyCommission {
    print("Monthly commission paid.")
}

worker = nil
