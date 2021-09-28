//
//  StretchViewController.swift
//  BandTheImage
//
//  Created by VikHolovach on 16.09.2021.
//

import UIKit
import BCMeshTransformView

extension BCMutableMeshTransform {
    static func warpTransform(from startPoint:CGPoint,
                              to endPoint:CGPoint, in size:CGSize) -> BCMutableMeshTransform {
        let resolution:UInt = 30
        let mesh = BCMutableMeshTransform.identityMeshTransform(withNumberOfRows: resolution,
                                                                numberOfColumns: resolution)!
        
        let _startPoint = CGPoint(x: startPoint.x/size.width, y: startPoint.y/size.height)
        let _endPoint = CGPoint(x: endPoint.x/size.width, y: endPoint.y/size.height)
        let xDist = (_startPoint.x - _endPoint.x)
        let yDist = (_startPoint.y - _endPoint.y);
        let dragDistance = sqrt((xDist * xDist) + (yDist * yDist))
        for i in 0..<mesh.vertexCount {
            var vertex = mesh.vertex(at: i)
            let xxDist = (_startPoint.x - vertex.from.x)
            let yyDist = (_startPoint.y - vertex.from.y)
            let myDistance = sqrt((xxDist * xxDist) + (yyDist * yyDist))
            
            let hEdgeDistance = min(vertex.from.x, 1 - vertex.from.x)
            let vEdgeDistance = min(vertex.from.y, 1 - vertex.from.y)
            let hProtection = min(100, pow(hEdgeDistance * 100, 1.5))/100
            let vProtection = min(100, pow(vEdgeDistance * 100, 1.5))/100
            
            if (myDistance < dragDistance) {
                let maxDistort = CGPoint(x:(_endPoint.x - _startPoint.x) / 2,
                                         y:(_endPoint.y - _startPoint.y) / 2)
                
                let normalizedDistance = myDistance/dragDistance
                let normalizedImpact = (cos(normalizedDistance * .pi) + 1) / 2
                
                vertex.to.x += maxDistort.x * normalizedImpact * hProtection
                vertex.to.y += maxDistort.y * normalizedImpact * vProtection
                
                mesh.replaceVertex(at: i, with: vertex)
            }
        }
        
        return mesh
        
    }
}
