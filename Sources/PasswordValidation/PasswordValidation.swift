import Dependencies
import Translating

public struct PasswordValidation: Sendable {
    public var validate: @Sendable (_ password: String) throws -> Bool

    public init(validate: @Sendable @escaping (_: String) throws -> Bool) {
        self.validate = validate
    }
}

enum PasswordValidationKey {}

extension DependencyValues {
    public var passwordValidation: PasswordValidation {
        get { self[PasswordValidationKey.self] }
        set { self[PasswordValidationKey.self] = newValue }
    }
}

extension PasswordValidationKey: DependencyKey {
    public static var testValue: PasswordValidation { .simple }
    public static var liveValue: PasswordValidation { .default }
}

extension PasswordValidation {
    public static var `default`: Self {
        .init { password in
            let minLength = 8
            let maxLength = 64

            // Regular expression patterns
            let uppercasePattern = ".*[A-Z]+.*"
            let lowercasePattern = ".*[a-z]+.*"
            let digitPattern = ".*[0-9]+.*"
            let specialCharacterPattern = ".*[!&^%$#@()/]+.*"

            // Check password length
            if password.count < minLength {
                throw PasswordValidation.Error.tooShort(minLength: minLength)
            }
            if password.count > maxLength {
                throw PasswordValidation.Error.tooLong(maxLength: maxLength)
            }

            // Check for uppercase, lowercase, digit, and special character
            if !matches(pattern: uppercasePattern, in: password) {
                throw PasswordValidation.Error.missingUppercase
            }
            if !matches(pattern: lowercasePattern, in: password) {
                throw PasswordValidation.Error.missingLowercase
            }
            if !matches(pattern: digitPattern, in: password) {
                throw PasswordValidation.Error.missingDigit
            }
            if !matches(pattern: specialCharacterPattern, in: password) {
                throw PasswordValidation.Error.missingSpecialCharacter
            }

            return true
        }
    }

    public static var simple: Self {
        .init { password in
            guard password.count >= 4 else {
                throw PasswordValidation.Error.tooShort(minLength: 4)
            }
            return true
        }
    }
}

private func matches(pattern: String, in text: String) -> Bool {
    guard let regex = try? Regex(pattern) else { return false }
    return text.contains(regex)
}

extension PasswordValidation {
    public enum Error: Swift.Error, Equatable, CustomStringConvertible {
        case tooShort(minLength: Int)
        case tooLong(maxLength: Int)
        case missingUppercase
        case missingLowercase
        case missingDigit
        case missingSpecialCharacter

        public var description: String {
            switch self {
            case .tooShort(let minLength):
                return TranslatedString(
                    english: "Password must be at least \(minLength) characters long."
                ).description
            case .tooLong(let maxLength):
                return TranslatedString(
                    english: "Password must be no more than \(maxLength) characters long."
                ).description
            case .missingUppercase:
                return TranslatedString(
                    english: "Password must contain at least one uppercase letter."
                ).description
            case .missingLowercase:
                return TranslatedString(
                    english: "Password must contain at least one lowercase letter."
                ).description
            case .missingDigit:
                return TranslatedString(
                    english: "Password must contain at least one digit."
                ).description
            case .missingSpecialCharacter:
                return TranslatedString(
                    english: "Password must contain at least one special character (e.g., !&^%$#@()/)."
                ).description
            }
        }
    }
}
