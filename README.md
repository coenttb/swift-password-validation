# PasswordValidation

A flexible and secure password validation library for Swift applications.

## Overview

PasswordValidation provides a composable approach to password validation in Swift. It offers predefined validation rules while allowing custom validation logic to be easily integrated, making it perfect for applications that need robust password security.

## Features

- ✅ **Predefined Validators**: Ready-to-use validation rules for common scenarios
- ✅ **Custom Validation**: Create your own validation logic with ease
- ✅ **Dependencies Integration**: Built-in support for the Dependencies library
- ✅ **Localized Error Messages**: User-friendly error descriptions
- ✅ **Comprehensive Testing**: Simple and default validators for different environments
- ✅ **Swift Concurrency**: Full `Sendable` support for modern Swift apps

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-password-validation.git", from: "0.0.1")
]
```

Then add `PasswordValidation` to your target dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "PasswordValidation", package: "swift-password-validation")
    ]
)
```

## Quick Start

### Basic Usage

```swift
import PasswordValidation

// Use the comprehensive validator
let validator = PasswordValidation.default

do {
    let isValid = try validator.validate("MySecurePass123!")
    print("Password is valid: \(isValid)")
} catch let error as PasswordValidation.Error {
    print("Validation failed: \(error.description)")
}
```

### With Dependencies

```swift
import Dependencies
import PasswordValidation

struct LoginService {
    @Dependency(\.passwordValidation) var passwordValidation
    
    func validateUserPassword(_ password: String) throws -> Bool {
        return try passwordValidation.validate(password)
    }
}
```

## Predefined Validators

### Default Validator

The `default` validator implements comprehensive security requirements:

- **Length**: 8-64 characters
- **Uppercase**: At least one uppercase letter (A-Z)
- **Lowercase**: At least one lowercase letter (a-z)
- **Digits**: At least one digit (0-9)
- **Special Characters**: At least one special character (`!&^%$#@()/`)

```swift
let validator = PasswordValidation.default
try validator.validate("MySecurePass123!") // ✅ Valid
```

### Simple Validator

The `simple` validator has minimal requirements (4+ characters) and is useful for testing:

```swift
let validator = PasswordValidation.simple
try validator.validate("test") // ✅ Valid
```

## Custom Validation

Create your own validation rules:

```swift
let customValidator = PasswordValidation { password in
    guard password.count >= 6 else {
        throw PasswordValidation.Error.tooShort(minLength: 6)
    }
    
    guard !password.lowercased().contains("password") else {
        throw PasswordValidation.Error.missingSpecialCharacter
    }
    
    return true
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

## Available Errors

- `tooShort(minLength: Int)` - Password is shorter than required
- `tooLong(maxLength: Int)` - Password exceeds maximum length
- `missingUppercase` - No uppercase letters found
- `missingLowercase` - No lowercase letters found  
- `missingDigit` - No digits found
- `missingSpecialCharacter` - No special characters found

## Documentation

For comprehensive documentation including advanced usage examples, visit the [DocC documentation](Sources/PasswordValidation/PasswordValidation.docc/PasswordValidation.md).

## Dependencies

This library depends on:

- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) - For dependency injection
- [swift-translating](https://github.com/coenttb/swift-translating) - For localized error messages

## Feedback is much appreciated!

If you're working on your own Swift project, feel free to learn, fork, and contribute.

Got thoughts? Found something you love? Something you hate? Let me know! Your feedback helps make this project better for everyone. Open an issue or start a discussion—I'm all ears.

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Link on Linkedin](https://www.linkedin.com/in/tenthijeboonkkamp)

## License

This project is licensed under the **APACHE 2.0. License**.  
You are free to use, modify, and distribute this project under the terms of the APACHE 2.0. License.  
For full details, please refer to the [LICENSE](LICENSE) file.
