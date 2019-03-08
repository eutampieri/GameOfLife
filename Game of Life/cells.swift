//
//  cells.swift
//  Game of Life
//
//  Created by Eugenio Tampieri on 08/03/2019.
//  Copyright © 2019 Eugenio Tampieri. All rights reserved.
//

import Foundation

final class Cells{
    private
    var mat: [[Bool]] = []
    var newMat:[[Bool]] = [];
    public
    var size: (Int, Int)
    init(width: Int, height: Int) {
        size = (width, height)
        for x in 0..<width{
            mat.append([])
            for _ in 0..<height{
                mat[x].append(false)
            }
        }
    }
    init(){
        size = (0,0)
    }
    func countNeighbours(x: Int, y: Int)->Int{
        var res=0;
        // Sinistra
        if(x>0){
            res += (mat[x-1][y] ? 1 : 0)
        }
        // Alto
        if(y>0){
            res += (mat[x][y-1] ? 1 : 0)
        }
        // Destra
        if(x<mat.count-1){
            res += (mat[x+1][y] ? 1 : 0)
        }
        // Basso
        if(y<mat[0].count-1){
            res += (mat[x][y+1] ? 1 : 0)
        }
        
        //TopLeft
        if(x>0&&y>0){
            res += (mat[x-1][y-1] ? 1 : 0)
        }
        // TopRight
        if(y>0&&x<mat.count-1){
            res += (mat[x+1][y-1] ? 1 : 0)
        }
        // BottomLeft
        if(y<mat[0].count-1 && x>0){
            res += (mat[x-1][y+1] ? 1 : 0)
        }
        // BottomRight
        if(y<mat[0].count-1 && x<mat.count-1){
            res += (mat[x+1][y+1] ? 1 : 0)
        }
        return res;
    }
    func isAlive(x: Int, y: Int)->Bool{
        return mat[x][y]
    }
    func kill(x: Int, y: Int){
        mat[x][y]=false;
    }
    func resuscitate(x: Int, y: Int){
        mat[x][y]=true;
    }
    func simKill(x: Int, y: Int){
        newMat[x][y]=false;
    }
    func simResuscitate(x: Int, y: Int){
        newMat[x][y]=true;
    }
    func populate(withRLE rle: String)->(Int, Int){
        let rleData = rle.split(separator: "\n").filter({$0.first! != "#"})
        let header = Dictionary(uniqueKeysWithValues: rleData[0].replacingOccurrences(of: " ", with: "", options: .literal, range: nil).split(separator: ",").map{str in
            return str.split(separator: "=")
            }.map{ ($0[0], Int($0[1])!) })
        mat = []
        size = (header["x"]!+6, header["y"]!+6)
        for x in 0..<header["x"]!+6{
            mat.append([])
            for _ in 0..<header["y"]!+6{
                mat[x].append(false)
            }
        }
        let data = rleData.dropFirst().map({$0.split(separator: "!")[0]}).joined(separator: "").split(separator: "$")
        var yOffset = 0;
        for (y, _) in data.enumerated(){
            var previousWasNum = false
            var startx = 2, x:Int = 2
            var num = ""
            for (_, c) in data[y].enumerated(){
                switch c{
                case "b":
                    if previousWasNum{
                        x=startx+Int(num)!-1
                        for j in startx...x{
                            mat[j+2][y+2+yOffset]=false;
                        }
                        previousWasNum=false
                    }
                    else{
                        mat[x+2][y+2+yOffset]=false
                    }
                    x = x+1
                case "o":
                    if previousWasNum{
                        x=startx+Int(num)!-1
                        for j in startx...x{
                            mat[j+2][y+2+yOffset]=true;
                        }
                        previousWasNum=false
                    }
                    else{
                        mat[x+2][y+2+yOffset]=true
                    }
                    x = x+1
                case "0"..."9":
                    if(!previousWasNum){
                        num=""
                        startx = x
                        previousWasNum = true
                    }
                    num.append(c)
                default:
                    continue
                }
            }
            if(previousWasNum){
                yOffset = yOffset + Int(num)! - 1
            }
        }
        return (header["x"]!, header["y"]!)
    }
    func populate(){
        let w = mat.count
        let h = mat[0].count
        for x in 0..<w{
            for y in 0..<h{
                mat[x][y] = arc4random_uniform(10)==1
            }
        }
    }
    func print(){
        let w = mat.count
        let h = mat[0].count
        for y in 0..<h{
            for x in 0..<w{
                Swift.print((mat[x][y] ? "◾" : " □"), separator:" ", terminator:"")
            }
            Swift.print("")
        }
    }
    func iterate(){
        newMat = mat
        for x in 0..<size.0{
            for y in 0..<size.1{
                if !g.isAlive(x: x, y: y)&&g.countNeighbours(x: x, y: y)==3{
                    g.simResuscitate(x: x, y: y)
                    continue
                }
                else if !g.isAlive(x: x, y: y){
                    continue
                }
                switch g.countNeighbours(x: x, y: y){
                case 0..<2:
                    g.simKill(x: x, y: y)
                case 4...8:
                    g.simKill(x: x, y: y)
                default:
                    continue
                }
            }
        }
        mat = newMat
    }
}
