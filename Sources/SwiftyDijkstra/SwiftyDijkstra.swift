//
//  SwiftyDijkstra.swift
//
//  Copyright (c) 2017– Michal Zelinka
//
//  MIT License
//

import Foundation

public class Node : CustomStringConvertible, Equatable {

	public private(set) var ID : String
	fileprivate var pathCost: Int?
	fileprivate weak var parentNode: Node?
	internal var outEdges = [Edge]()


	public init(_ ID: String) {
		self.ID = ID
	}

	fileprivate func reset() {
		pathCost = nil
		parentNode = nil
		outEdges = []
	}

	public static func == (lhs: Node, rhs: Node) -> Bool {
		lhs.ID == rhs.ID
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

	fileprivate var reversedEdge: Edge { get {
		Edge(from: to, to: from, cost: cost, bidirectional: bidirectional)
	} }

	public var description: String {
		return "\(from.ID) -> \(to.ID)"
	}
}

public class Graph {

	private var edges: [Edge]
	private let processingLock = NSLock()

	public init(edges: [Edge]) {
		self.edges = edges
	}

	private func resetElements() {
		self.edges.forEach {
			$0.from.reset()
			$0.to.reset()
		}
	}

	public func shortestPath(from: Node, to: Node) -> [Node] {

		if (from === to) { return [ from ] }

		processingLock.lock()

		for e in edges {
			e.from.outEdges.append(e)
			if (e.bidirectional) {
				e.to.outEdges.append(e.reversedEdge)
			}
		}

		from.pathCost = 0

		var queue = [ from ]

		while (queue.count > 0) {

			let current = queue.removeFirst()

			for e in current.outEdges {

				let dest = e.to

				if (current.ID == dest.ID) { continue }

				let currCost = current.pathCost ?? 0

				if let destCost = dest.pathCost,
				   destCost <= currCost + e.cost
				{ continue }

				dest.pathCost = currCost + e.cost
				dest.parentNode = current
				queue.append(dest)
			}
		}

		var top : Node? = to
		var path = [Node]()

		while (top != nil) {
			path.insert(top!, at: 0)
			top = top!.parentNode
		}

		self.resetElements()
		processingLock.unlock()

		if (path.count <= 1) { return [ ] }

		return path
	}
}
