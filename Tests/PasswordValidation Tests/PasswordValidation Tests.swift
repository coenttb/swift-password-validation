//
//  PasswordValidation Tests.swift
//  coenttb-server
//
//  Created by Coen ten Thije Boonkkamp on 23/07/2025.
//

@testable import Coenttb_Database
import Testing
import Dependencies
import DependenciesTestSupport

@Suite(
    "PasswordValidation Tests",
    .dependency(\.passwordValidation, .default)
)
struct PasswordValidationTests {

    @Suite("Valid Passwords")
    struct ValidPasswordTests {

        @Test("Valid password with all requirements")
        func validPasswordWithAllRequirements() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let validPassword = "Password123!"
            #expect(try isValidPassword(validPassword) == true)
        }

        @Test("Valid password with minimum length")
        func validPasswordWithMinimumLength() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let validPassword = "Pass123!"
            #expect(try isValidPassword(validPassword) == true)
        }

        @Test("Valid password with multiple special characters")
        func validPasswordWithMultipleSpecialCharacters() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let validPassword = "Password123!@#$%^&*()"
            #expect(try isValidPassword(validPassword) == true)
        }

        @Test("Valid password with maximum allowed length")
        func validPasswordWithMaximumLength() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let validPassword = String(repeating: "Aa1!", count: 16) // 64 characters
            #expect(try isValidPassword(validPassword) == true)
        }
    }

    @Suite(
        "Invalid Passwords - Length",
    )
    struct InvalidPasswordLengthTests {

        @Test("Password too short throws tooShort error")
        func passwordTooShortThrowsError() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let shortPassword = "Pass1!"

            #expect(throws: PasswordValidation.Error.tooShort(minLength: 8)) {
                try isValidPassword(shortPassword)
            }
        }

        @Test("Password too long throws tooLong error")
        func passwordTooLongThrowsError() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let longPassword = String(repeating: "Aa1!", count: 17) // 68 characters
            #expect(throws: PasswordValidation.Error.tooLong(maxLength: 64)) {
                try isValidPassword(longPassword)
            }
        }
    }

    @Suite(
        "Invalid Passwords - Missing Character Types",
    )
    struct InvalidPasswordCharacterTests {

        @Test("Password missing uppercase throws missingUppercase error")
        func passwordMissingUppercaseThrowsError() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let password = "password123!"
            #expect(throws: PasswordValidation.Error.missingUppercase) {
                try isValidPassword(password)
            }
        }

        @Test("Password missing lowercase throws missingLowercase error")
        func passwordMissingLowercaseThrowsError() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let password = "PASSWORD123!"

            #expect(throws: PasswordValidation.Error.missingLowercase) {
                try isValidPassword(password)
            }
        }

        @Test("Password missing digit throws missingDigit error")
        func passwordMissingDigitThrowsError() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let password = "Password!"

            #expect(throws: PasswordValidation.Error.missingDigit) {
                try isValidPassword(password)
            }
        }

        @Test("Password missing special character throws missingSpecialCharacter error")
        func passwordMissingSpecialCharacterThrowsError() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let password = "Password123"

            #expect(throws: PasswordValidation.Error.missingSpecialCharacter) {
                try isValidPassword(password)
            }
        }
    }

    @Suite("PasswordValidation.Error Tests")
    struct PasswordValidationErrorTests {

        @Test("TooShort error has correct description")
        func tooShortErrorDescription() {
            let error = PasswordValidation.Error.tooShort(minLength: 8)
            #expect(error.description.contains("at least 8 characters"))
        }

        @Test("TooLong error has correct description")
        func tooLongErrorDescription() {
            let error = PasswordValidation.Error.tooLong(maxLength: 64)
            #expect(error.description.contains("no more than 64 characters"))
        }

        @Test("MissingUppercase error has correct description")
        func missingUppercaseErrorDescription() {
            let error = PasswordValidation.Error.missingUppercase
            #expect(error.description.contains("uppercase letter"))
        }

        @Test("MissingLowercase error has correct description")
        func missingLowercaseErrorDescription() {
            let error = PasswordValidation.Error.missingLowercase
            #expect(error.description.contains("lowercase letter"))
        }

        @Test("MissingDigit error has correct description")
        func missingDigitErrorDescription() {
            let error = PasswordValidation.Error.missingDigit
            #expect(error.description.contains("digit"))
        }

        @Test("MissingSpecialCharacter error has correct description")
        func missingSpecialCharacterErrorDescription() {
            let error = PasswordValidation.Error.missingSpecialCharacter
            #expect(error.description.contains("special character"))
        }
    }

    @Suite("Edge Cases")
    struct EdgeCaseTests {

        @Test("Empty password throws tooShort error")
        func emptyPasswordThrowsError() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let emptyPassword = ""

            #expect(throws: PasswordValidation.Error.tooShort(minLength: 8)) {
                try isValidPassword(emptyPassword)
            }
        }

        @Test("Password with Unicode characters")
        func passwordWithUnicodeCharacters() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let unicodePassword = "Pássword123!"
            #expect(try isValidPassword(unicodePassword) == true)
        }

        @Test("Password with all allowed special characters")
        func passwordWithAllAllowedSpecialCharacters() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let password = "Password123!&^%$#@()/"
            #expect(try isValidPassword(password) == true)
        }

        @Test("Password with spaces")
        func passwordWithSpaces() async throws {
            @Dependency(\.passwordValidation.validate) var isValidPassword
            let password = "Pass word123!"
            #expect(try isValidPassword(password) == true)
        }
    }
}
