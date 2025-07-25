# Getting Started with PasswordValidation

Learn how to integrate and use password validation in your Swift applications.

## Overview

The PasswordValidation library provides a flexible approach to password validation with predefined rules and the ability to create custom validators.

## Basic Usage

### Using Predefined Validators

The library comes with two predefined validators:

```swift
import PasswordValidation

// Use the comprehensive validator
let defaultValidator = PasswordValidation.default
do {
    let isValid = try defaultValidator.validate("MySecurePass123!")
    print("Password is valid: \(isValid)")
} catch let error as PasswordValidation.Error {
    print("Validation failed: \(error.description)")
}

// Use the simple validator for testing
let simpleValidator = PasswordValidation.simple
try simpleValidator.validate("test") // Returns true
```

### Creating Custom Validators

You can create custom validation logic by initializing a `PasswordValidation` instance:

```swift
let customValidator = PasswordValidation { password in
    // Custom validation logic
    guard password.count >= 6 else {
        throw PasswordValidation.Error.tooShort(minLength: 6)
    }
    
    guard !password.lowercased().contains("password") else {
        // You can throw custom errors or use predefined ones
        throw PasswordValidation.Error.missingSpecialCharacter
    }
    
    return true
}
```

## Integration with Dependencies

If you're using the Dependencies library, you can access password validation through the dependency system:

```swift
import Dependencies

struct LoginService {
    @Dependency(\.passwordValidation) var passwordValidation
    
    func validateUserPassword(_ password: String) throws -> Bool {
        return try passwordValidation.validate(password)
    }
}
```

## Error Handling

The library provides specific error types for different validation failures:

```swift
do {
    try PasswordValidation.default.validate("weak")
} catch PasswordValidation.Error.tooShort(let minLength) {
    print("Password too short, needs at least \(minLength) characters")
} catch PasswordValidation.Error.missingUppercase {
    print("Password needs an uppercase letter")
} catch PasswordValidation.Error.missingDigit {
    print("Password needs a digit")
} catch {
    print("Other validation error: \(error)")
}
```