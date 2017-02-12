//
//  Dijkstra.swift
//
//  Copyright (c) 2017 Michal Zelinka
//
//  MIT License
//

import Foundation

public class Node : CustomStringConvertible {

	public var ID : String
	var pathCost: Int?
	var parentNode: Node?
	var outEdges = [Edge]()


	public init(_ ID: String) {
		self.ID = ID
	}

	fileprivate func reset() {
		pathCost = nil
		parentNode = nil
		outEdges = []
	}

	public var description: String {
		return ID
	}
}

public class Edge : CustomStringConvertible {

	public private(set) var from: Node
	public private(set) var to: Node
	public private(set) var cost: Int
	public private(set) var bidirectional: Bool


	public init(from: Node, to: Node, cost: Int = 1, bidirectional: Bool = true)
	{
		self.from = from
		self.to = to
		self.cost = cost
		self.bidirectional = bidirectional
	}

	public var description: String {
		return "\(from.ID) -> \(to.ID)"
	}
}

public class Graph {

	public private(set) var edges: [Edge]


	public init(edges: [Edge]) {
		self.edges = edges
	}

	public func shortestPath(from: Node, to: Node) -> [Node] {

		if (from === to) { return [ from ] }

		for e in edges {
			e.from.reset()
			e.to.reset()
		}

		for e in edges {

			e.from.outEdges.append(e)

			if (e.bidirectional == true) {
				e.to.outEdges.append(Edge(from: e.to, to: e.from,
					cost: e.cost, bidirectional: e.bidirectional))
			}
		}

		from.pathCost = 0

		var queue = [ from ]

		while (queue.count > 0) {

			let current = queue.removeFirst()

			for e in current.outEdges {

				let dest = e.to

				if (current.ID == dest.ID) { continue }

				if dest.pathCost != nil &&
				   dest.pathCost! <= (current.pathCost ?? 0) + e.cost
				{ continue }

				dest.pathCost = (current.pathCost ?? 0) + e.cost
				dest.parentNode = current
				queue.append(dest)
			}

		}

		var top : Node? = to
		var path = [Node]()

		while (top != nil) {
			path.insert(top!, at: 0)
			top = top?.parentNode
		}

		if (path.count <= 1) { return [ ] }

		return path
	}
}
