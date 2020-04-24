import XCTest
@testable import SwiftyDijkstra

final class SwiftyDijkstraTests: XCTestCase {

	func test() {

		// Prepare weak Node handlers for later

		weak var weakBrno: Node? = nil
		weak var weakPraha: Node? = nil
		weak var weakOstrava: Node? = nil
		weak var weakPardubice: Node? = nil
		weak var weakKolin: Node? = nil
		weak var weakPlzen: Node? = nil
		weak var weakAdamov: Node? = nil
		weak var weakPrcice: Node? = nil

		autoreleasepool {

			// Define the nodes

			let Brno: Node      = Node("Brno")
			let Praha: Node     = Node("Praha")
			let Ostrava: Node   = Node("Ostrava")
			let Pardubice: Node = Node("Pardubice")
			let Kolin: Node     = Node("Kolin")
			let Plzen: Node     = Node("Plzen")
			let Adamov: Node    = Node("Adamov")

			let Prcice: Node      = Node("Prcice")
			let doPrcicEdge: Edge = Edge(from: Prcice, to: Prcice)
			Prcice.outEdges = [ doPrcicEdge ]

			// Define the graph edges

			let edges = [
				Edge(from: Ostrava,   to: Brno,    cost:180),
				Edge(from: Praha,     to: Ostrava, cost:420),
				Edge(from: Pardubice, to: Brno,    cost:110),
				Edge(from: Pardubice, to: Praha,   cost:90),
				Edge(from: Pardubice, to: Plzen,   cost:140),
				Edge(from: Pardubice, to: Ostrava, cost:290),
				Edge(from: Plzen,     to: Praha,   cost:70),
				Edge(from: Adamov,    to: Adamov,  cost:0),
			]

			// Initialize the graph itself

			let G = Graph(edges: edges)

			// Define some stuff...

			var result: [Node]! = nil
			var expectation: [Node]! = nil


			let printArr: ([Node], [Node]) -> Void = {
				print("\($0) == \($1)")
			}

			// Look for shortest paths and print'em

			result = G.shortestPath(from:Praha, to: Ostrava)
			expectation = [Praha, Pardubice, Ostrava]
			XCTAssert(result == expectation)
			printArr(result, expectation)

			result = G.shortestPath(from:Ostrava, to: Plzen)
			expectation = [Ostrava, Pardubice, Plzen]
			XCTAssert(result == expectation)
			printArr(result, expectation)

			result = G.shortestPath(from:Ostrava, to: Ostrava)
			expectation = [Ostrava]
			XCTAssert(result == expectation)
			printArr(result, expectation)

			result = G.shortestPath(from:Brno, to: Kolin)
			expectation = []
			XCTAssert(result == expectation)
			printArr(result, expectation)

			weakBrno      = Brno
			weakPraha     = Praha
			weakOstrava   = Ostrava
			weakPardubice = Pardubice
			weakKolin     = Kolin
			weakPlzen     = Plzen
			weakAdamov    = Adamov
			weakPrcice    = Prcice
		}

		// Test Node addresses for dealloc failures

		XCTAssert(weakBrno      == nil)
		XCTAssert(weakPraha     == nil)
		XCTAssert(weakOstrava   == nil)
		XCTAssert(weakPardubice == nil)
		XCTAssert(weakKolin     == nil)
		XCTAssert(weakPlzen     == nil)
		XCTAssert(weakAdamov    == nil)

		XCTAssert(weakPrcice    != nil)
		weakPrcice?.outEdges = [ ]
		XCTAssert(weakPrcice    == nil)

		// Done

		print("Finished!")
	}

	static var allTests = [
		("test", test),
	]
}
