//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by name surname on 02.06.2025.
//

import XCTest
@testable import ToDoList

/// Test class for checking the basic functionality of the application
/// Includes tests for CoreDataViewModel and ItemModel
final class ToDoListTests: XCTestCase {
    // MARK: - Properties
    /// ViewModel for testing basic data operations
    var viewModel: CoreDataViewModel!
    /// Data manager for testing network operations
    var dataManager: DataManager!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        viewModel = CoreDataViewModel()
        dataManager = DataManager.shared
    }
    
    override func tearDown() {
        viewModel = nil
        dataManager = nil
        super.tearDown()
    }
    
    // MARK: - ItemModel Tests
    /// Test of JSON decoding into ItemModel
    /// Checks if JSON conversion to model object is correct
    func testItemModelDecoding() {
        let json = """
        {
            "id": 1,
            "todo": "Test Task",
            "completed": false
        }
        """.data(using: .utf8)!
        
        do {
            let item = try JSONDecoder().decode(ItemModel.self, from: json)
            XCTAssertEqual(item.id, 1)
            XCTAssertEqual(item.title, "Test Task")
            XCTAssertFalse(item.completed)
        } catch {
            XCTFail("Failed to decode ItemModel: \(error)")
        }
    }
    
    // MARK: - CoreDataViewModel Tests
    /// Test adding a new task
    /// Checks that the task is successfully added and displayed in the list
    func testAddItem() {
        let expectation = XCTestExpectation(description: "Add item")
        
        viewModel.addItem(
            title: "Test Task",
            id: 1,
            details: "Test Details",
            date: Date(),
            completed: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.viewModel.items.isEmpty)
            XCTAssertEqual(self.viewModel.items.first?.title, "Test Task")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    /// Tasks status switching test
    /// Checks that the task status is correctly reversed
    func testToggleCompletion() {
        let expectation = XCTestExpectation(description: "Toggle completion")
        
        viewModel.addItem(
            title: "Test Task",
            id: 1,
            details: "Test Details",
            date: Date(),
            completed: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let item = self.viewModel.items.first else {
                XCTFail("No items found")
                return
            }
            
            self.viewModel.toggleCompletion(item: item)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertTrue(self.viewModel.items.first?.completed ?? false)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    /// Multiple task deletion test
    /// Checks if the first and the last task in the list is deleted correctly
    /// Takes into account sorting by date (new tasks on top)
    func testDeleteMultipleItems() {
        let expectation = XCTestExpectation(description: "Delete multiple items")
        
        // Add multiple items
        viewModel.addItem(
            title: "Test Task 1",
            id: 1,
            details: "Test Details 1",
            date: Date(),
            completed: false
        )
        
        viewModel.addItem(
            title: "Test Task 2",
            id: 2,
            details: "Test Details 2",
            date: Date(),
            completed: false
        )
        
        viewModel.addItem(
            title: "Test Task 3",
            id: 3,
            details: "Test Details 3",
            date: Date(),
            completed: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let testItems = self.viewModel.items.prefix(3)
            XCTAssertEqual(testItems.count, 3)
            
            XCTAssertEqual(testItems[0].title, "Test Task 3")
            XCTAssertEqual(testItems[1].title, "Test Task 2")
            XCTAssertEqual(testItems[2].title, "Test Task 1")
            
            // Delete first and last of our test items
            if let firstIndex = self.viewModel.items.firstIndex(where: { $0.title == "Test Task 3" }),
               let lastIndex = self.viewModel.items.firstIndex(where: { $0.title == "Test Task 1" }) {
                self.viewModel.deleteItem(indexSet: IndexSet([firstIndex, lastIndex]))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let remainingTestItems = self.viewModel.items.prefix(1)
                    XCTAssertEqual(remainingTestItems.count, 1)
                    XCTAssertEqual(remainingTestItems.first?.title, "Test Task 2")
                    expectation.fulfill()
                }
            } else {
                XCTFail("Could not find test items in the list")
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    /// Task update test
    /// Checks whether the task title and description have been changed correctly
    func testUpdateItem() {
        let expectation = XCTestExpectation(description: "Update item")
        
        viewModel.addItem(
            title: "Test Task",
            id: 1,
            details: "Test Details",
            date: Date(),
            completed: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            guard let item = self.viewModel.items.first else {
                XCTFail("No items found")
                return
            }
            
            self.viewModel.updateItem(
                item: item,
                newTitle: "Updated Task",
                newDetails: "Updated Details"
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertEqual(self.viewModel.items.first?.title, "Updated Task")
                XCTAssertEqual(self.viewModel.items.first?.details, "Updated Details")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    /// Test adding a task with an empty header
    /// Checks that tasks with empty or space header are not added
    /// Uses the same test method as in CoreDataViewModel
    func testAddItemWithEmptyTitle() {
        let expectation = XCTestExpectation(description: "Add item with empty title")
        
        // Try to add item with empty title
        viewModel.addItem(
            title: "   ", // Only spaces
            id: 1,
            details: "Test Details",
            date: Date(),
            completed: false
        )
        
        // Try to add item with completely empty title
        viewModel.addItem(
            title: "", // Empty string
            id: 2,
            details: "Test Details",
            date: Date(),
            completed: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Verify that our test items are not in the list
            let emptyTitleItems = self.viewModel.items.filter { 
                $0.title?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? false
            }
            XCTAssertTrue(emptyTitleItems.isEmpty, "Found items with empty titles")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

