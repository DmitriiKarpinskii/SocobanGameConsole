struct Room {
    var weight : Int
    var height : Int
}


struct Player {
 
    var x: Int
    var y: Int
    
    mutating func walk(direct: Direction) {
        switch direct {
        case .Up :
            self.y = y - 1
        case .Down :
            self.y = y + 1
        case .Right :
            self.x = x + 1
        case .Left :
            self.x = x - 1
        }
    }
}

struct Box {
    var x: Int
    var y: Int
    
    mutating func move(direct: Direction) {
        
        switch direct {
        case .Up :
            self.y = y - 1
        case .Down :
            self.y = y + 1
        case .Right :
            self.x = x + 1
        case .Left :
            self.x = x - 1
        }
    }
    
}

struct Point {
    var x: Int
    var y: Int
}

enum Direction {
    case Left, Right, Up, Down
}

struct Game {
    
    
    let actionField : Room
    var fullFiled : Room {
        return Room(weight: actionField.weight + 2, height: actionField.height + 2)
    }
    
    var player : Player {
        didSet {
            if 1...actionField.height ~= player.y && 1...actionField.weight ~= player.x {
                print("Установлены новые координаты игрока: x: \(player.x) y: \(player.y)")
            } else {
                print("Не удается переместить игрока.")
                player = oldValue
            }
        }
    }
    var box : Box {
        didSet {
            if 1...actionField.height ~= box.y && 1...actionField.weight ~= box.x {
                print("Установлены новые координаты ящика: x: \(box.x) y: \(box.y)")
            } else if box.x == -1 && box.y == -1 {
                print("Служебная установка")
            } else {
                print("Не удается переместить ящик.")
                box = oldValue
            }
        }
        
    }
    
    let endPoint : Point
     
    
    init(room: Room = Room(weight: 10, height: 10)) {
            
        
        if room.weight < 2 || room.height < 2 {
            self.actionField = Room(weight: 3, height: 3)
        } else {
            self.actionField = room
        }
        
        
        let xPlayer = actionField.weight / 2
        let yPlayer = actionField.height / 2
        self.player = Player(x: xPlayer, y: yPlayer)
        
        var xBox : Int
        var yBox : Int
            
        repeat {
                xBox = Int.random(in: 2...actionField.weight - 1)
                yBox = Int.random(in: 2...actionField.height - 1)
        } while xBox == xPlayer && yBox == yPlayer
        
        self.box = Box(x: xBox, y: yBox)
        
        var xPoint : Int
        var yPoint : Int
        
        repeat {
            xPoint = Int.random(in: 1...actionField.weight )
            yPoint = Int.random(in: 1...actionField.height )
           
        } while xPoint == xPlayer || yPoint == yBox
        
        self.endPoint = Point(x: xPoint, y: yPoint)
            
        
       
        print("Координаты ▅ (ящика):          x:\(box.x) y:\(box.y)")
        print("Координаты ★ (игрока):         x:\(player.x) y:\(player.y)")
        print("Координаты ⚑ (конечной точки): x:\(endPoint.x) y:\(endPoint.y)")
        print("\nЗадание: дотолкать ящик до конечной точки")
    }
    
    mutating func movePlayer(direct: Direction) {
        self.player.walk(direct: direct)
    }
    
    mutating func moveBox(direct: Direction) {
        self.box.move(direct: direct)
    }
    
    func avalibaleNewPositionForBox(direct: Direction) -> Bool {
        
        switch direct {
        case .Up:
            return 1...actionField.height ~= box.y - 1
        case .Down :
            return 1...actionField.height ~= box.y + 1
        case .Right :
            return 1...actionField.weight ~= box.x + 1
        case .Left :
            return 1...actionField.weight ~= box.x - 1
        }
    }
    
    func avalibaleNewPositionForPlayer(direct: Direction) -> Bool {
        
        switch direct {
        case .Up:
            return player.y - 1 != endPoint.y || player.x != endPoint.x
        case .Down :
            return player.y + 1 != endPoint.y || player.x != endPoint.x
        case .Right :
            return player.x + 1 != endPoint.x || player.y != endPoint.y
        case .Left :
            return player.x - 1 != endPoint.x || player.y != endPoint.y
        }
    }
    
    func isBoxOnWay(direct: Direction) -> Bool {
        switch direct {
        case .Up:
            return player.x == box.x  &&  player.y - 1 == box.y
        case .Down :
            return player.x == box.x  &&  player.y + 1 == box.y
        case .Right :
            return player.x + 1 == box.x  &&  player.y == box.y
        case .Left :
            return player.x - 1 == box.x  &&  player.y == box.y
        }
    }
    
    func isBoxOnEndPoint() -> Bool {
        return box.x == endPoint.x && box.y == endPoint.y
    }
    
    func generateNewPositionForBox() -> Box {
        
        var xBox : Int
        var yBox : Int
        repeat {
                xBox = Int.random(in: 2...actionField.weight - 1)
                yBox = Int.random(in: 2...actionField.height - 1)
        } while xBox == player.x || yBox == endPoint.y
        
        return Box(x: xBox, y: yBox)
    }
    
    mutating func stepPlayer(direct: Direction) {

        if isBoxOnWay(direct: direct) && avalibaleNewPositionForBox(direct: direct) {
            moveBox(direct: direct)
            movePlayer(direct: direct)
            if isBoxOnEndPoint() {
                print("Ящик доставлен!")
                box = generateNewPositionForBox()
            }
        } else if !isBoxOnWay(direct: direct) && avalibaleNewPositionForPlayer(direct: direct) {
            movePlayer(direct: direct)
        } else  {
            print("Движение в этом навправлении невозможно.")
        }
    }
    
    
    func printField() {
        
        for row in 1...fullFiled.height {
           
            var lineForPrint = Array(repeating: "  ", count: fullFiled.weight)
                                                    
            if row == 1 {
                lineForPrint = Array(repeating: "\u{2500}\u{2500}", count: fullFiled.weight)
                lineForPrint[0] = "\u{250D}"
                lineForPrint[fullFiled.weight - 1] = "\u{2513}"
            } else if row == fullFiled.height {
                lineForPrint = Array(repeating: "\u{2500}\u{2500}", count: fullFiled.weight)
                lineForPrint[0] = "\u{2517}"
                lineForPrint[fullFiled.weight - 1] = "\u{251b}"
            } else {
                lineForPrint[0] = "\u{2502}"
                lineForPrint[fullFiled.weight - 1] = "\u{2502}"
            }
            
            if row == player.y + 1 {
                lineForPrint[player.x] = " \u{2605}"
            }
            
            if row == box.y + 1 {
                lineForPrint[box.x] = " \u{2585}"
            }
    
            if row == endPoint.y + 1  {
                lineForPrint[endPoint.x] = " ⚑"
            }
            
            print(lineForPrint.joined())
            
        }
    }
}


var room = Room(weight: 13, height: 7)
var game = Game(room: room)


var line : String?
repeat {
    game.printField()
    line = readLine()
    
    switch line {
    case "w":
        game.stepPlayer(direct: .Up)
    case "s":
        game.stepPlayer(direct: .Down)
    case "a":
        game.stepPlayer(direct: .Left)
    case "d":
        game.stepPlayer(direct: .Right)
    case "r":
        let x = Int(readLine()!) ?? 0
        let y = Int(readLine()!) ?? 0
        game.box = Box(x: x, y: y)
    default:
        break
    }
    
    
} while line != "ex"
