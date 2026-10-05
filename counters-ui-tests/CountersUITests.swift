import XCTest

@MainActor
final class CountersUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        deleteAllCounters()
    }

    func testAddIncrementDelete() throws {
        XCTAssertTrue(app.staticTexts["No Counters"].waitForExistence(timeout: 5))

        app.navigationBars.buttons["New Counter"].tap()
        let addButton = app.navigationBars["New Counter"].buttons["Add"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        XCTAssertFalse(addButton.isEnabled)

        app.textFields["Name"].typeText("Water")
        XCTAssertTrue(addButton.isEnabled)
        addButton.tap()

        let row = row(named: "Water")
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["No Counters"].exists)
        XCTAssertTrue(row.staticTexts["0"].exists)

        row.buttons["Increment"].tap()
        row.buttons["Increment"].tap()
        XCTAssertTrue(row.staticTexts["2"].waitForExistence(timeout: 2))
        XCTAssertFalse(app.navigationBars["Edit Counter"].exists)

        row.swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertTrue(app.staticTexts["No Counters"].waitForExistence(timeout: 5))
    }

    func testCancelDoesNotAdd() throws {
        app.navigationBars.buttons["New Counter"].tap()
        app.textFields["Name"].typeText("Discard Me")
        app.navigationBars["New Counter"].buttons["Cancel"].tap()

        XCTAssertTrue(app.staticTexts["No Counters"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.cells.count, 0)
    }

    func testEditNameAndValue() throws {
        addCounter(named: "Water")

        // Done saves the new value and name.
        row(named: "Water").staticTexts["Water"].tap()
        XCTAssertTrue(app.navigationBars["Edit Counter"].waitForExistence(timeout: 5))
        app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "5")

        let nameField = app.textFields["Name"]
        nameField.tap()
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 5))
        nameField.buttons["Clear text"].tap()
        nameField.typeText("Coffee")
        app.navigationBars["Edit Counter"].buttons["Done"].tap()

        let renamed = row(named: "Coffee")
        XCTAssertTrue(renamed.waitForExistence(timeout: 5))
        XCTAssertTrue(renamed.staticTexts["5"].exists)

        // Cancel discards changes.
        renamed.staticTexts["Coffee"].tap()
        XCTAssertTrue(app.navigationBars["Edit Counter"].waitForExistence(timeout: 5))
        app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "8")
        app.navigationBars["Edit Counter"].buttons["Cancel"].tap()
        XCTAssertTrue(renamed.staticTexts["5"].waitForExistence(timeout: 5))
    }

    private func row(named name: String) -> XCUIElement {
        app.cells.containing(.staticText, identifier: name).firstMatch
    }

    private func addCounter(named name: String) {
        app.navigationBars.buttons["New Counter"].tap()
        app.textFields["Name"].typeText(name)
        app.navigationBars["New Counter"].buttons["Add"].tap()
        XCTAssertTrue(row(named: name).waitForExistence(timeout: 5))
    }

    private func deleteAllCounters() {
        while app.cells.firstMatch.waitForExistence(timeout: 1) {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()
        }
    }
}
