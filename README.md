<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
    <img align="center" alt="Aortem Logo" src="https://raw.githubusercontent.com/aortem/logos/main/Aortem-logo-small.png" />
  </picture>
</p>

<h2 align="center">entra_id_dart_auth_sdk</h2>

<!-- x-hide-in-docs-end -->
<p align="center" class="github-badges">
  <!-- Release Badge -->
  <a href="https://github.com/aortem/entra_id_dart_auth_sdk/tags">
    <img alt="Release" src="https://img.shields.io/static/v1?label=release&message=v0.0.1-pre+10&color=blue&style=for-the-badge" />
  </a>
  <br/>
  <!-- Dart-Specific Badges -->
  <a href="https://pub.dev/packages/entra_id_dart_auth_sdk">
    <img alt="Pub Version" src="https://img.shields.io/pub/v/entra_id_dart_auth_sdk.svg?style=for-the-badge" />
  </a>
  <a href="https://dart.dev/">
    <img alt="Built with Dart" src="https://img.shields.io/badge/Built%20with-Dart-blue.svg?style=for-the-badge" />
  </a>
 <!-- Firebase Badge -->
   <a href="https://firebase.google.com/docs/reference/admin/node/firebase-admin.auth?_gl=1*1ewipg9*_up*MQ..*_ga*NTUxNzc0Mzk3LjE3MzMxMzk3Mjk.*_ga_CW55HF8NVT*MTczMzEzOTcyOS4xLjAuMTczMzEzOTcyOS4wLjAuMA..">
    <img alt="API Reference" src="https://img.shields.io/badge/API-reference-blue.svg?style=for-the-badge" />
  <br/>
<!-- Pipeline Badge -->
<a href="https://github.com/aortem/entra_id_dart_auth_sdk/actions">
  <img alt="Pipeline Status" src="https://img.shields.io/github/actions/workflow/status/aortem/entra_id_dart_auth_sdk/dart-analysis.yml?branch=main&label=pipeline&style=for-the-badge" />
</a>
<!-- Code Coverage Badges -->
  </a>
  <a href="https://codecov.io/gh/open-feature/dart-server-sdk">
    <img alt="Code Coverage" src="https://codecov.io/gh/open-feature/dart-server-sdk/branch/main/graph/badge.svg?token=FZ17BHNSU5" />
<!-- Open Source Badge -->
  </a>
  <a href="https://bestpractices.coreinfrastructure.org/projects/6601">
    <img alt="CII Best Practices" src="https://bestpractices.coreinfrastructure.org/projects/6601/badge?style=for-the-badge" />
  </a>
</p>
<!-- x-hide-in-docs-start -->

# Firebase Dart Admin Auth SDK

Firebase Dart Admin Auth SDK is designed to provide select out of the box features of Firebase in Dart.  Both low level and high level abstractions are provided.

## Features
This implementation does not yet support all functionalities of the firebase authentication service. Here is a list of functionalities with the current support status:

# Firebase to Entra ID Dart Auth SDK Migration

This document provides a high-level comparison of Firebase Authentication methods and features against Entra ID (Azure Active Directory) capabilities, tailored for the creation of a similar SDK. The goal is to maintain familiarity for developers transitioning from Firebase to Entra ID while incorporating enterprise-grade security and features of Azure AD.

---

## **Feature Comparison Chart**

### **Core Authentication Methods**

# Firebase to Entra ID Dart Auth SDK Migration

This document provides a high-level comparison of Firebase Authentication methods and features against Entra ID (Azure Active Directory) capabilities, tailored for the creation of a similar SDK. The goal is to maintain familiarity for developers transitioning from Firebase to Entra ID while incorporating enterprise-grade security and features of Azure AD.

---

# Firebase to Entra ID Dart Auth SDK Migration

This document provides a high-level comparison of Firebase Authentication methods and features against Entra ID (Azure Active Directory) capabilities, tailored for the creation of a similar SDK. The goal is to maintain familiarity for developers transitioning from Firebase to Entra ID while incorporating enterprise-grade security and features of Azure AD.

---

## **Feature Comparison Chart**

### **Core Authentication Methods**

| Firebase Method                                 | Entra ID Equivalent                            | Notes                                                                                   | Supported |
| ----------------------------------------------- | ---------------------------------------------- | --------------------------------------------------------------------------------------- | --------- |
| `FirebaseApp.getAuth()`                         | MSAL: `PublicClientApplication` initialization | Initialize and access the authentication instance.                                      | ✅         |
| `FirebaseApp.initializeAuth()`                  | MSAL: `PublicClientApplication` initialization | SDK initialization. Entra ID may require additional tenant or directory configurations. | ✅         |
| `FirebaseAuth.signInWithEmailAndPassword()`     | MSAL: `acquireTokenByUsernamePassword()`       | Email/password-based sign-in.                                                           | ✅         |
| `FirebaseAuth.createUserWithEmailAndPassword()` | Microsoft Graph API: `POST /users`             | Register a new user in the directory.                                                   | ✅         |
| `FirebaseAuth.signOut()`                        | MSAL: Clear tokens                             | Logout functionality, including token invalidation.                                     | ✅         |
| `FirebaseAuth.setPersistence()`                 | Not Applicable                                 | Azure AD handles session duration via token expiration and refresh policies.            | ❌         |
| `FirebaseAuth.sendPasswordResetEmail()`         | Microsoft Graph API: `POST /me/sendMail`       | Password reset functionality.                                                           | ✅         |
| `FirebaseAuth.connectAuthEmulator`              | Not Applicable                                 | Azure AD does not support emulated authentication environments.                         | ❌         |
| `FirebaseAuth.beforeAuthStateChanged()`         | Not Applicable                                 | Azure AD does not provide a similar method for pre-auth state changes.                 | ❌         |

---

### **Token Management**

| Firebase Method                        | Entra ID Equivalent                             | Notes                                                                                 | Supported |
| -------------------------------------- | ----------------------------------------------- | ------------------------------------------------------------------------------------- | --------- |
| `FirebaseAuth.getIdToken()`            | MSAL: `acquireTokenSilent()`                    | Retrieve access tokens. Entra ID supports multiple token types (ID, access, refresh). | ✅         |
| `FirebaseAuth.onIdTokenChanged()`      | Not Applicable                                  | No direct event listener for token changes; monitor expiration programmatically.      | ❌         |
| `FirebaseAuth.revokeAccessToken()`     | Microsoft Graph API: `POST /oauth2/v2.0/logout` | Token revocation can be managed via Graph API or Azure AD portal.                     | ✅         |
| `FirebaseAuth.signInWithCustomToken()` | Not Applicable                                  | Azure AD does not use custom tokens in the same way as Firebase.                      | ❌         |
| `FirebaseAuth.setLanguageCode()`       | Not Applicable                                  | Azure AD does not natively support language code settings.                            | ❌         |

---

### **User Management**

| Firebase Method                        | Entra ID Equivalent                            | Notes                                                         | Supported |
| -------------------------------------- | ---------------------------------------------- | ------------------------------------------------------------- | --------- |
| `FirebaseUser.updateEmail()`           | Microsoft Graph API: `PATCH /me`               | Updates the user's email address.                             | ✅         |
| `FirebaseUser.updatePassword()`        | Microsoft Graph API: `POST /me/changePassword` | Updates the user's password.                                  | ✅         |
| `FirebaseUser.deleteUser()`            | Microsoft Graph API: `DELETE /users/{id}`      | Deletes the user account.                                     | ✅         |
| `FirebaseUser.updateProfile()`         | Microsoft Graph API: `PATCH /me`               | Updates user profile details like display name.               | ✅         |
| `FirebaseUser.sendEmailVerification()` | Not Applicable                                 | Azure AD does not require email verification in the same way. | ❌         |
| `FirebaseUser.unlink()`                | Not Applicable                                 | Unlinking accounts is not a common Azure AD concept.          | ❌         |
| `FirebaseUser.reload()`                | Microsoft Graph API: `GET /me`                 | Refreshes the user profile information.                       | ✅         |
| `FirebaseAuth.updateCurrentUser()`     | Microsoft Graph API: `PATCH /me`               | Updates the current user's details, such as their profile.    | ✅         |

---

### **Multi-Factor Authentication (MFA)**

| Firebase Method                               | Entra ID Equivalent                                   | Notes                                                                   | Supported |
| --------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------------------------- | --------- |
| `FirebaseAuth.getMultiFactorResolver()`       | Microsoft Graph API: `GET /me/authentication/methods` | Retrieve MFA configurations for a user.                                 | ✅         |
| `FirebaseAuth.initializeRecaptchaConfig()`    | Not Applicable                                        | Azure AD uses conditional access policies for MFA instead of Recaptcha. | ❌         |
| `FirebaseUser.multiFactor()`                  | Microsoft Graph API: `GET /me/authentication/methods` | Fetches available multi-factor methods for a user.                      | ✅         |
| `FirebaseUser.reauthenticateWithCredential()` | MSAL: `acquireTokenByUsernamePassword()`              | Reauthenticates the user for sensitive operations.                      | ✅         |
| `FirebaseUser.linkWithCredential()`           | Not Applicable                                        | Azure AD does not support direct credential linking.                    | ❌         |
| `FirebaseUser.reauthenticateWithPhoneNumber()`| Not Applicable                                        | Azure AD does not support phone-based reauthentication directly.        | ❌         |

---

### **Sign-In Methods**

| Firebase Method                        | Entra ID Equivalent                   | Notes                                                                     | Supported |
| -------------------------------------- | ------------------------------------- | ------------------------------------------------------------------------- | --------- |
| `FirebaseAuth.signInWithPopup()`       | Not Applicable                        | Azure AD does not support popup-based authentication flows.               | ❌         |
| `FirebaseAuth.signInWithRedirect()`    | MSAL: `acquireTokenInteractive()`     | Redirect-based federated login.                                           | ✅         |
| `FirebaseAuth.signInWithPhoneNumber()` | Microsoft Graph API with Azure AD B2C | Phone-based authentication (requires Azure AD B2C for consumer accounts). | ✅         |
| `FirebaseAuth.isSignInWithEmailLink()` | Not Applicable                        | Azure AD uses other mechanisms for email-based login.                     | ❌         |
| `FirebaseAuth.sendSignInLinkToEmail()` | Not Applicable                        | Azure AD does not support sign-in links.                                  | ❌         |

---

### **Action Code Handling**

| Firebase Method                          | Entra ID Equivalent | Notes                                                                                | Supported |
| ---------------------------------------- | ------------------- | ------------------------------------------------------------------------------------ | --------- |
| `FirebaseAuth.applyActionCode()`         | Not Applicable      | Azure AD does not use action codes in the same manner.                               | ❌         |
| `FirebaseAuth.checkActionCode()`         | Not Applicable      | Azure AD does not use action codes in the same manner.                               | ❌         |
| `FirebaseAuth.verifyPasswordResetCode()` | Not Applicable      | Azure AD does not use password reset codes; resets are handled through secure flows. | ❌         |
| `FirebaseLink.parseActionCodeURL()`      | Not Applicable      | Azure AD does not use URL-based action codes.                                        | ❌         |

---

### **Error Handling**

| Firebase Error         | Entra ID Equivalent | Notes                                    | Supported |
| ---------------------- | ------------------- | ---------------------------------------- | --------- |
| `ERROR_WRONG_PASSWORD` | `AADSTS50056`       | Password mismatch or expired password.   | ✅         |
| `ERROR_USER_DISABLED`  | `AADSTS50057`       | User account disabled.                   | ✅         |
| `ERROR_INVALID_EMAIL`  | `AADSTS50034`       | Invalid email or account does not exist. | ✅         |

---

### **Enterprise Features Unique to Entra ID**

| Feature                                     | Description                                      | Supported |
| ------------------------------------------- | ----------------------------------------------- | --------- |
| Conditional Access Policies                 | Enforce granular access control based on risk.  | ✅         |
| Role-Based Access Control (RBAC)            | Assign roles to limit access to resources.      | ✅         |
| B2B and B2C Support                         | Collaborate with external users and consumers.  | ✅         |
| Identity Protection                         | Detect and respond to suspicious activities.    | ✅         |
| Privileged Identity Management (PIM)        | Control access to sensitive resources.          | ✅         |
| Device Management Integration               | Enforce policies on managed devices.            | ✅         |

---


## Available Versions

Firebase Dart Admin Auth SDK is available in two versions to cater to different needs:

1. **Main - Stable Version**: Usually one release a month.  This version attempts to keep stability without introducing breaking changes.
2. **Pre-Release - Edge Version**: Provided as an early indication of a release when breaking changes are expect.  This release is inconsistent. Use only if you are looking to test new features.

## Documentation

For detailed guides, API references, and example projects, visit our [Firebase Dart Admin Auth SDK Documentation](https://aortem.gitbook.io/firebase-dart-auth-admin-sdk). Start building with  Firebase Dart Admin Auth SDK today and take advantage of its robust features and elegant syntax.

## Examples

Explore the `/example` directory in this repository to find sample applications demonstrating  Firebase Dart Admin Auth SDK's capabilities in real-world scenarios.

## Contributing

We welcome contributions of all forms from the community! If you're interested in helping improve  Firebase Dart Admin Auth SDK, please fork the repository and submit your pull requests. For more details, check out our [CONTRIBUTING.md](CONTRIBUTING.md) guide.  Our team will review your pull request. Once approved, we will integrate your changes into our primary repository and push the mirrored changes on the main github branch.

## Support Tiers

Firebase Dart Admin Auth SDK offers various support tiers for our open-source products with an Initial Response Service Level Agreement (IRSLA):

### Community Support
- **Cost**: Free
- **Features**: Access to community forums, basic documentation.
- **Ideal for**: Individual developers or small startups.
- **SLA**: NA

### Standard Support
- **Cost**: $10/month - Billed Annually.
- **Features**: Extended documentation, email support, 10 business days response SLA.
- **Ideal for**: Growing startups and small businesses.
- **SLA**: 10 business days (Monday-Friday) IRSLANA
- [Subscribe-Coming Soon]()

### Enhanced Support
- **Cost**: $100/month - Billed Annually
- **Features**: Access to roadmap, 72-hour response SLA, feature request prioritization.
- **Ideal for**: Medium-sized enterprises requiring frequent support.
- **SLA**: 5 business days IRSLA
- [Subscribe-Coming Soon]()

### Enterprise Support
- **Cost**: 450/month
- **Features**: 
  - 48-hour response SLA, 
  - Access to beta features:
  - Comprehensive support for all Aortem Open Source products.
  - Premium access to our exclusive enterprise customer forum.
  - Early access to cutting-edge features.
  - Exclusive access to Partner/Reseller/Channel Program..
- **Ideal for**: Large organizations and enterprises with complex needs.
- **SLA**: 48-hour IRSLA
- [Subscribe-Coming Soon]()

*Enterprise Support is designed for businesses, agencies, and partners seeking top-tier support across a wide range of Dart backend and server-side projects.  All Open Source projects that are part of the Aortem Collective are included in the Enterprise subscription, with more projects being added soon.

## Licensing

All  Firebase Dart Admin Auth SDK packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, which are licensed from third party software  Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with Firebase Dart Admin Auth SDK

We hope the Firebase Dart Admin Auth SDK helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!  test