import Dependencies
import Translating

enum PasswordValidationKey {}

extension DependencyValues {
    /// Access to password validation functionality through the Dependencies system.
    ///
    /// This provides a convenient way to inject password validation into your application
    /// components while maintaining testability.
    ///
    /// ## Usage
    /// ```swift
    /// @Dependency(\.passwordValidation) var passwordValidation
    /// 
    /// func validateUserPassword(_ password: String) throws -> Bool {
    ///     return try passwordValidation.validate(password)
    /// }
    /// ```
    public var passwordValidation: PasswordValidation {
        get { self[PasswordValidationKey.self] }
        set { self[PasswordValidationKey.self] = newValue }
    }
}

extension PasswordValidationKey: DependencyKey {
    /// The test value uses simple validation for easier testing.
    public static var testValue: PasswordValidation { .simple }
    /// The live value uses comprehensive validation for production.
    public static var liveValue: PasswordValidation { .default }
}

