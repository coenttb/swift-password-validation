# Validation Rules

Understanding the predefined validation rules and how to customize them.

## Overview

PasswordValidation provides two predefined validators with different security levels, and allows you to create custom validation rules.

## Default Validator Rules

The ``PasswordValidation/default`` validator implements comprehensive security requirements:

### Length Requirements
- **Minimum length**: 8 characters
- **Maximum length**: 64 characters

### Character Requirements
- At least one **uppercase letter** (A-Z)
- At least one **lowercase letter** (a-z)
- At least one **digit** (0-9)
- At least one **special character** from the set: `!&^%$#@()/`

### Example Valid Passwords
```swift
try PasswordValidation.default.validate("MySecurePass123!")  // ✅ Valid
try PasswordValidation.default.validate("AnotherGood1$")     // ✅ Valid
try PasswordValidation.default.validate("Complex9@Password") // ✅ Valid
```

### Example Invalid Passwords
```swift
// Too short
try PasswordValidation.default.validate("Short1!")  // ❌ Throws tooShort

// Missing uppercase
try PasswordValidation.default.validate("lowercase123!")  // ❌ Throws missingUppercase

// Missing digit
try PasswordValidation.default.validate("NoDigits!")  // ❌ Throws missingDigit

// Missing special character
try PasswordValidation.default.validate("NoSpecial123ABC")  // ❌ Throws missingSpecialCharacter
```

## Simple Validator Rules

The ``PasswordValidation/simple`` validator has minimal requirements:

- **Minimum length**: 4 characters
- No other character requirements

This validator is useful for:
- Testing environments
- Applications with relaxed security requirements
- Development and debugging

```swift
try PasswordValidation.simple.validate("test")     // ✅ Valid
try PasswordValidation.simple.validate("1234")     // ✅ Valid
try PasswordValidation.simple.validate("ab")       // ❌ Throws tooShort
```

## Creating Custom Rules

You can create validators with custom rules by providing your own validation logic:

### Custom Length Requirements
```swift
let strictValidator = PasswordValidation { password in
    guard password.count >= 12 else {
        throw PasswordValidation.Error.tooShort(minLength: 12)
    }
    return true
}
```

### Custom Character Requirements
```swift
let noCommonWordsValidator = PasswordValidation { password in
    let commonWords = ["password", "123456", "qwerty", "admin"]
    
    for word in commonWords {
        if password.lowercased().contains(word) {
            throw PasswordValidation.Error.missingSpecialCharacter // Reuse existing error
        }
    }
    
    return password.count >= 8
}
```

### Combining Multiple Rules
```swift
let hybridValidator = PasswordValidation { password in
    // First check basic requirements
    try PasswordValidation.default.validate(password)
    
    // Then add custom checks
    guard !password.contains("admin") else {
        throw PasswordValidation.Error.missingSpecialCharacter
    }
    
    return true
}
```

## Regular Expression Patterns

The default validator uses these regex patterns internally:

- **Uppercase**: `.*[A-Z]+.*`
- **Lowercase**: `.*[a-z]+.*`
- **Digit**: `.*[0-9]+.*`
- **Special character**: `.*[!&^%$#@()/]+.*`

You can use similar patterns in your custom validators:

```swift
let customPatternValidator = PasswordValidation { password in
    let pattern = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
    
    guard let regex = try? Regex(pattern),
          password.contains(regex) else {
        throw PasswordValidation.Error.missingSpecialCharacter
    }
    
    return true
}
```