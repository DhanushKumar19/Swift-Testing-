//
//  BuildingBlocksTest.swift
//  SwiftTestingTests
//
//  Created by Dhanushkumar Kanagaraj on 22/09/24.
//

import Testing

struct BuildingBlocksTest {
    
    // MARK: - Test Functions
    struct WatchListTestFunction {
        let animeWatchList: [String]? = ["One Piece", "Demon Slayer", "Attack on Titans"]

        @Test func watchListIsNotEmpty() async {
            #expect(!animeWatchList!.isEmpty)
        }

        @Test func unwrapWatchListIsNotEmpty() async throws {
            let watchList = try #require(animeWatchList)
            #expect(!watchList.isEmpty)
        }

        @MainActor
        @Test func watchListHasOnePiece() async throws {
            let watchList = try #require(animeWatchList)
            #expect(watchList.contains("One Piece"))
        }
    }

    // MARK: - Expectations
    class Expectations {
        @Test func expectations() throws {
            #expect(true == true)
            #expect(false == false)

            let optionalNil: String? = nil
//            _ = try #require(optionalNil)
            #expect(optionalNil == nil)
            let optionalValue: String? = "Not Nil"
            let value = try #require(optionalValue)
            #expect(value != nil)
            
            let six = 6
            #expect(six > 5)
            #expect(six >= 6)
            
            #expect(six < 7)
            #expect(six <= 6)
        }
        
        @Test func throwingExpectations() throws {
            let age = 9
            
            #expect(throws: (any Error).self) {
                if age < 10 {
                    throw CustomError.accessDenied(reason: "You are younger")
                }
            }
            
            #expect(throws: CustomError.self) {
                if age < 10 {
                    throw CustomError.accessDenied(reason: "You are younger")
                }
            }
            
            #expect(throws: CustomError.underAge) {
                if age < 10 {
                    throw CustomError.underAge
                }
            }
            
            #expect(performing: {
                if age < 10 {
                    throw CustomError.accessDenied(reason: "You are younger")
                }
            }, throws: { error in
                guard case let .accessDenied(reason) = error as? CustomError else {
                    return false
                }
                return reason == "You are younger"
            })
        }
    }
    
    // MARK: - Traits
    actor TraitsTestFunction {
        let likedArtist = [ "AR Rahman", "Arjit Singh", "Vidyasagar" ]
        let mostLikedArtist: String? = "AR Rahman"
        
        @Test("Has Liked Artist")
        func hasLikedArtist() async {
            #expect(likedArtist != nil)
        }
        
        @Test(
            "User listens to Arjit Singh",
            .bug("https://www.example.com/issue/1234", "Arjit Singh is by default added to everyone's ;iled list")
        )
        func arjitSinghInLikedArtist() async {
            #expect(likedArtist.contains("Arjit Singh"))
        }
        
        @Test(
            "AR Rahman is the most liked Artist",
            .tags(.composer)
        )
        func mostLikedArtistIaARR() async {
            #expect(mostLikedArtist == "AR Rahman")
        }
        
        @Test(
            "Most Liked Artist is available",
            .enabled(if: true),
            .timeLimit(.minutes(1))
        )
        func hasMostLikedArtist() async throws {
            try #require(mostLikedArtist != nil)
        }
        
        @Test(
            "Least Liked Artist is not available",
            .disabled("Removed the least liked option temporarily")
        )
        @available(iOS 16, *)
        func hasLeastLikedArtist() async throws {
            try #require(mostLikedArtist == nil)
        }
    }
    
    // MARK: - Suite
    @Suite("Suite in Action")
    class TestSuite {
        var isSUT: Bool?
        
        init() {
            // Setup needs to go here
            isSUT = true
        }
        
        deinit {
            // Teardown needs to go here
            isSUT = false
        }
        
        @Test
        func isSystemUnderTest() async {
            #expect(isSUT == true)
        }
    }
}

// MARK: - Support Details
extension Tag {
    @Tag static var composer: Self
}

enum CustomError: Error, Equatable {
    case accessDenied(reason: String?)
    case underAge
}
