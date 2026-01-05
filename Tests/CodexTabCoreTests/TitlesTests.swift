import XCTest
@testable import CodexTabCore

final class TitlesTests: XCTestCase {
    func testParseSpecOrdered() throws {
        let titles = try CodexTabTitles.parseSpec("new|run|done|no|timeout")
        XCTAssertEqual(titles.newTitle, "new")
        XCTAssertEqual(titles.runningTitle, "run")
        XCTAssertEqual(titles.doneTitle, "done")
        XCTAssertEqual(titles.noCommitTitle, "no")
        XCTAssertEqual(titles.timeoutTitle, "timeout")
    }

    func testParseSpecKeyValuePartialOverride() throws {
        let titles = try CodexTabTitles.parseSpec(
            "running=codex:🚧,timeout=codex:🛑",
            base: .defaults
        )
        XCTAssertEqual(titles.newTitle, CodexTabTitles.defaults.newTitle)
        XCTAssertEqual(titles.runningTitle, "codex:🚧")
        XCTAssertEqual(titles.doneTitle, CodexTabTitles.defaults.doneTitle)
        XCTAssertEqual(titles.noCommitTitle, CodexTabTitles.defaults.noCommitTitle)
        XCTAssertEqual(titles.timeoutTitle, "codex:🛑")
    }

    func testParseSpecKeyValueSupportsNoCommitAliasesAndQuotes() throws {
        let titles1 = try CodexTabTitles.parseSpec("no_commit='nc'", base: .defaults)
        XCTAssertEqual(titles1.noCommitTitle, "nc")

        let titles2 = try CodexTabTitles.parseSpec("no-commit=\"nc2\"", base: .defaults)
        XCTAssertEqual(titles2.noCommitTitle, "nc2")
    }

    func testParseSpecInvalidOrderedCount() {
        XCTAssertThrowsError(try CodexTabTitles.parseSpec("a|b|c|d")) { error in
            guard case TitlesSpecError.invalidOrderedCount(4) = error else {
                XCTFail("Expected invalidOrderedCount, got: \(error)")
                return
            }
        }
    }

    func testParseSpecUnknownKey() {
        XCTAssertThrowsError(try CodexTabTitles.parseSpec("nope=x", base: .defaults)) { error in
            guard case TitlesSpecError.unknownKey("nope") = error else {
                XCTFail("Expected unknownKey, got: \(error)")
                return
            }
        }
    }

    func testParseSpecInvalidPair() {
        XCTAssertThrowsError(try CodexTabTitles.parseSpec("running=x,done", base: .defaults)) { error in
            guard case TitlesSpecError.invalidPair("done") = error else {
                XCTFail("Expected invalidPair, got: \(error)")
                return
            }
        }
    }
}

