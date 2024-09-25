//
//  WorkflowTest.swift
//  SwiftTestingTests
//
//  Created by Dhanushkumar Kanagaraj on 24/09/24.
//

import Foundation
import Testing

struct WorkflowTest {

    struct TestWithConditions {
        
        @Test(
            .enabled(if: UserDefaults.standard.bool(forKey: "underSUT"))
        )
        func systemUnderTest() async throws {
            #expect(true)
        }
        
        @Test(
            .disabled(if: UserDefaults.standard.bool(forKey: "underSUT"))
        )
        func systemUnderTestWithDisabledState() async throws {
            #expect(false)
        }
        
        @Test(.bug("https://www.example.com/issue/1234"))
        func systemUnderTestWithKnownIssue() async throws {
            withKnownIssue(isIntermittent: true) {
                #expect(false)
            }
        }
        
        @Test
        @available(macOS 14, *)
        func systemUnderTestOnlyOnMacOS() async throws {
            #expect(true)
        }
    }

    @Suite(.tags(.tagged))
    struct TestWithTags {
        @Test func tagTesting1() {
            #expect(true)
        }
        
        @Test func tagTesting2() {
            #expect(true)
        }
        
        @Test(.tags(.composer))
        func composerTagTesting1() {
            
            #expect(true)
        }
    }
    
    struct TestWithMultipleArguments {
        let knownArtist = ["ARR", "Anirudh", "Deva", "DSP", "GV Prakash", "Sean Roldan"]
        let mostLikedArtist = ["ARR", "Anirudh", "Deva", "GV Prakash"]
        let awardWinningArtist = ["ARR", "Deva", "GV Prakash"]
        
        @Test(
            "Few Known Artist",
            arguments: ["ARR", "Deva", "Siddarth"]
        )
        func isAKnownArtist(_ artist: String) async throws {
            #expect(knownArtist.contains(artist))
        }
        
        @Test(
            "Award Winning Artist and awards",
            arguments: ["ARR", "Deva", "GV Prakash"], [3, 2, 1, 0]
        )
        func artistWithAwards(_ artist: String, awardCount: Int) async throws {
            #expect(awardWinningArtist.contains(artist))
        }
        
        @Test(
            "Award Winning Artist with exact awards",
            arguments: zip(["ARR", "Deva", "GV Prakash"], [3, 2, 1])
        )
        func artistWithExactAwards(_ artist: String, awardCount: Int) async throws {
            #expect(awardWinningArtist.contains(artist))
            #expect(awardCount > 0)
        }
    }
}
