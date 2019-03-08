//
//  main.swift
//  Game of Life
//
//  Created by Eugenio Tampieri on 08/03/2019.
//  Copyright © 2019 Eugenio Tampieri. All rights reserved.
//

import Foundation

print("Hello, World!")
let size = (Int(arc4random_uniform(80)), Int(arc4random_uniform(30)))
//var size = (30,20)
var g = Cells(width: size.0,height: size.1)
//let g = Cells()
/*let _ = g.populate(withRLE: """
            x = 13, y = 13
            2b3o3b3o2b2$o4bobo4bo$o4bobo4bo$o4bobo4bo$2b3o3b3o2b2$2b3o3b3o2b$o4bob
            o4bo$o4bobo4bo$o4bobo4bo2$2b3o3b3o!
            """)*/
g.populate()
g.print()
sleep(2)
let iters = 100
for _ in 0..<iters{
    g.iterate()
    usleep(80000)
    print("\u{001B}[2J")
    g.print()
}
