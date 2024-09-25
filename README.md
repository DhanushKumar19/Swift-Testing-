
# Swift Testing

## 1. Key Features
1. **Descriptive, organized tests**
2. **Actionable failures**
3. **Scalable**

## 2. Swift Testing Highlights
- Designed for **Swift**, supporting modern features like **Concurrency** and **macros**.
- Cross-platform: Supports other platforms like **Linux** and **Windows**.
- **Open Source**.
- In **Xcode 16**, Swift Testing is the default option when creating a new testing framework.

## 3. Building Blocks

### 3.1 Test Function
- Annotated using `@Test`.
- Can be a **global function** or **method** in a type.
- May be `async` or `throws`.
- May be **global isolated-actor** (like `@MainActor`).

### 3.2 Expectations
- Use `#expect(...)` to validate that an expected condition is true.
- Accepts **ordinary expressions** and operators.
- Captures **source code** and sub-expression values upon failure.

### 3.3 Required Expectations
- Use `try #require(…)` to stop the test if the condition is false.
- Can **unwrap optional values** and stop the test when `nil`.

### 3.4 Traits
- Adds **descriptive information** about a test.
- Customize whether a test runs.
- Modify how a test behaves.

```swift
// Built-in-traits

// Customise the display name of a test
@Test("Custom Name") 

// Reference an issue from a Bug tracker
@Test(.bug("Bug Link", "Title")) 

// Add custom tag to test
@Test(.tag(.critical)) 

// Specify a runtime condition for a test
@Test(.enabled(if: condition)) 

// Unconditionally disable a test
@Test(.disabled("Currently Broken")) 

// Limit a test to certain OS version
@Test(...) @available(iOS 15, *) 

// Set a maximum time limit for a test
@Test(.timeLimit(.minutes(3))) 

// Runs the tests in a Suite one at a time, without parallelization
@Suite(.serialized)
```

### 3.5 Suites
- Group related **test functions** and suites.
- Annotated using `@Suite`.
    - Implicit for types containing `@Test` functions or suites.
- May have **stored instance properties**.
- Use `init` and `deinit` for set-up and tear-down logic.
- **Initialized once per instance** `@Test` method.

## 4. Common Workflows

### 4.1 Tests with Conditions
- `.enabled`
- `.disabled`
- `.bug`
- `@available`

### 4.2 Tests with Common Characteristics
- `.tags`

### 4.3 Tests with Different Arguments
- View details of each argument in the result.
- Re-run individual arguments to debug.
- Run arguments in parallel.

## 5. Swift Testing vs XCTest

### 5.1 Test Functions

|  | XCTest | Swift Testing |
| --- | --- | --- |
| **Discovery** | Name begins with `test` | `@Test` |
| **Support Types** | Instance methods | Instance methods, static/class methods, global functions |
| **Supports Traits** | No | Yes |
| **Parallel Execution** | Multi-process, macOS and Simulator only | In-process (using Swift Concurrency), supports devices |

### 5.2 Expectations

|  | XCTest | Swift Testing |
| --- | --- | --- |
| **Assertions** | `XCTAssert`, `XCTAssertTrue`, `XCTAssertFalse` |  |
| **Nil Checks** | `XCTAssertNil`, `XCTAssertNotNil` |  |
| **Equality Checks** | `XCTAssertEqual`, `XCTAssertNotEqual` | `#expect(…)` |
| **Identity Checks** | `XCTAssertIdentical`, `XCTAssertNotIdentical` | `try #require(…)` |
| **Comparison Checks** | `XCTAssertGreaterThan`, `XCTAssertLessThan` |  |
| **Greater Than or Equal, Less Than or Equal** | `XCTAssertGreaterThanOrEqual`, `XCTAssertLessThanOrEqual` |  |

### 5.3 Suites

|  | XCTest | Swift Testing |
| --- | --- | --- |
| **Types** | Class | Struct, Class, Actor |
| **Discovery** | Subclass of `XCTestCase` | `@Suite` |
| **Before Each Test** | `setUp()`, `setUpWithErrors() throws`, `setUp() async throws` | `init() async throws` |
| **After Each Test** | `tearDown()`, `tearDownWithErrors() throws`, `tearDown() async throws` | `deinit` |
| **Subgroups** | Unsupported | Via type nesting |

## 6. Limitations
1. Doesn’t support UI automation APIs (such as `XCUIApplication`).
2. Doesn’t support performance APIs (such as `XCTMetric`).
3. Doesn’t work on Objective-C.
4. Avoid calling `XCTestAssert` from Swift Testing tests or `#expect` from XCTest.
