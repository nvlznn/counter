import XCTest

@MainActor
final class AccumUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        deleteAllCounters()
    }

    func testAddIncrementDelete() throws {
        XCTAssertTrue(app.staticTexts["還沒有計數器"].waitForExistence(timeout: 5))

        app.navigationBars.buttons["新增計數器"].tap()
        let addButton = app.navigationBars["新增計數器"].buttons["新增"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        XCTAssertFalse(addButton.isEnabled)

        app.textFields["名稱"].typeText("喝水")
        XCTAssertTrue(addButton.isEnabled)
        addButton.tap()

        let row = app.cells.containing(.staticText, identifier: "喝水").firstMatch
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["還沒有計數器"].exists)
        XCTAssertTrue(row.staticTexts["0"].exists)

        row.buttons["加一"].tap()
        row.buttons["加一"].tap()
        XCTAssertTrue(row.staticTexts["2"].waitForExistence(timeout: 2))

        row.swipeLeft()
        app.buttons["刪除"].tap()
        XCTAssertTrue(app.staticTexts["還沒有計數器"].waitForExistence(timeout: 5))
    }

    func testCancelDoesNotAdd() throws {
        app.navigationBars.buttons["新增計數器"].tap()
        app.textFields["名稱"].typeText("不要存")
        app.navigationBars["新增計數器"].buttons["取消"].tap()

        XCTAssertTrue(app.staticTexts["還沒有計數器"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.cells.count, 0)
    }

    private func deleteAllCounters() {
        while app.cells.firstMatch.waitForExistence(timeout: 1) {
            app.cells.firstMatch.swipeLeft()
            app.buttons["刪除"].tap()
        }
    }
}
