# FarmConnect Frontend-To-Backend API Documentation

Each endpoint below includes the implementation fields needed by backend engineers: API name, URL, method, auth, headers, body/query/path schema, responses, validation, frontend screen/action, state flow, UI states, database entity, security, pagination, caching, and example payloads.

## Shared Schemas

Common success envelope:

```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {},
  "timestamp": "2026-05-23T10:30:00Z"
}
```

Common error envelope:

```json
{
  "success": false,
  "message": "Validation failed",
  "error": {
    "code": "VALIDATION_ERROR",
    "details": [{"field": "email", "message": "Invalid email"}],
    "requestId": "req_01JZ..."
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

Default headers:

```json
{
  "Accept": "application/json",
  "Content-Type": "application/json",
  "X-Client-Platform": "mobile|tablet|web",
  "X-App-Version": "1.0.0",
  "X-Request-Id": "uuid"
}
```

Auth headers add:

```json
{
  "Authorization": "Bearer <accessToken>"
}
```

List pagination response shape:

```json
{
  "items": [],
  "pagination": {
    "limit": 20,
    "nextCursor": "cursor",
    "hasMore": true,
    "total": 120
  }
}
```

## Auth Module

### Login

| Field | Contract |
| --- | --- |
| API name | Login |
| Endpoint URL | `/api/v1/auth/login` |
| HTTP method | `POST` |
| Authentication | Not required |
| Request headers | Default headers |
| Request body schema | `{ "email": "string", "password": "string", "deviceId": "string?", "pushToken": "string?" }` |
| Query parameters | None |
| Path parameters | None |
| Success response | `200`, auth session with user, access token, refresh token, expiry |
| Error response | `400`, `401`, `403`, `500` |
| Validation rules | Email format; password required; blocked users return `403` |
| Frontend screen | Login screen |
| Frontend action trigger | User taps login button |
| State management flow | `idle -> loading -> authenticated`; on error `loading -> error` |
| Loading/error/empty states | Disable form while loading; inline auth error; no empty state |
| Recommended database entity | `users`, `refresh_tokens`, `push_tokens`, `audit_logs` |
| Security considerations | Rate-limit; generic invalid credentials message; rotate refresh token |
| Pagination requirements | None |
| Caching recommendations | Do not cache response; store tokens in secure storage |

Request:

```json
{
  "email": "farmer@example.com",
  "password": "StrongPass123!",
  "deviceId": "device-uuid",
  "pushToken": "fcm-token"
}
```

Response:

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "accessToken": "jwt-access-token",
    "refreshToken": "opaque-refresh-token",
    "expiresIn": 900,
    "user": {
      "id": "user-uuid",
      "name": "Asha Patel",
      "email": "farmer@example.com",
      "role": "farmer",
      "emailVerified": true
    }
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

### Signup

| Field | Contract |
| --- | --- |
| API name | Signup |
| Endpoint URL | `/api/v1/auth/signup` |
| HTTP method | `POST` |
| Authentication | Not required |
| Request headers | Default headers |
| Request body schema | `{ "name": "string", "email": "string", "phone": "string?", "password": "string", "role": "farmer|worker" }` |
| Query parameters | None |
| Path parameters | None |
| Success response | `201`, created user and verification status |
| Error response | `400`, `409`, `500` |
| Validation rules | Unique email; strong password; valid role; name 2-80 chars |
| Frontend screen | Signup screen |
| Frontend action trigger | User submits registration form |
| State management flow | `idle -> loading -> pendingVerification/authenticated` |
| Loading/error/empty states | Disable form; field validation errors; no empty state |
| Recommended database entity | `users`, `user_profiles`, `email_verification_tokens`, `audit_logs` |
| Security considerations | Hash password; send verification token; rate-limit by IP/email |
| Pagination requirements | None |
| Caching recommendations | Do not cache |

Request:

```json
{
  "name": "Ravi Kumar",
  "email": "ravi@example.com",
  "phone": "+919876543210",
  "password": "StrongPass123!",
  "role": "worker"
}
```

Response:

```json
{
  "success": true,
  "message": "Signup successful. Verify your email to continue.",
  "data": {
    "userId": "user-uuid",
    "email": "ravi@example.com",
    "role": "worker",
    "emailVerified": false
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

### Forgot Password

| Field | Contract |
| --- | --- |
| API name | Forgot Password |
| Endpoint URL | `/api/v1/auth/forgot-password` |
| HTTP method | `POST` |
| Authentication | Not required |
| Request headers | Default headers |
| Request body schema | `{ "email": "string" }` |
| Query parameters | None |
| Path parameters | None |
| Success response | `200`, generic reset instruction message |
| Error response | `400`, `500` |
| Validation rules | Email format required |
| Frontend screen | Forgot password screen |
| Frontend action trigger | User taps send reset link |
| State management flow | `idle -> loading -> submitted` |
| Loading/error/empty states | Disable button; show generic success; no account enumeration |
| Recommended database entity | `users`, `password_reset_tokens`, `audit_logs` |
| Security considerations | Always return generic success; token hash at rest; short expiry |
| Pagination requirements | None |
| Caching recommendations | Do not cache |

Request:

```json
{ "email": "ravi@example.com" }
```

Response:

```json
{
  "success": true,
  "message": "If the account exists, password reset instructions have been sent.",
  "data": {},
  "timestamp": "2026-05-23T10:30:00Z"
}
```

### Reset Password

| Field | Contract |
| --- | --- |
| API name | Reset Password |
| Endpoint URL | `/api/v1/auth/reset-password` |
| HTTP method | `POST` |
| Authentication | Not required |
| Request headers | Default headers |
| Request body schema | `{ "token": "string", "password": "string" }` |
| Query parameters | None |
| Path parameters | None |
| Success response | `200`, reset confirmation |
| Error response | `400`, `401`, `409`, `500` |
| Validation rules | Valid non-expired token; strong new password |
| Frontend screen | Reset password screen |
| Frontend action trigger | User submits new password |
| State management flow | `idle -> loading -> completed` |
| Loading/error/empty states | Disable form; token expired error; no empty state |
| Recommended database entity | `users`, `password_reset_tokens`, `refresh_tokens`, `audit_logs` |
| Security considerations | Revoke refresh tokens after reset; hash password; one-time token |
| Pagination requirements | None |
| Caching recommendations | Do not cache |

Request:

```json
{
  "token": "reset-token",
  "password": "NewStrongPass123!"
}
```

Response:

```json
{
  "success": true,
  "message": "Password reset successfully",
  "data": {},
  "timestamp": "2026-05-23T10:30:00Z"
}
```

### Verify Email

| Field | Contract |
| --- | --- |
| API name | Verify Email |
| Endpoint URL | `/api/v1/auth/verify-email` |
| HTTP method | `POST` |
| Authentication | Not required |
| Request headers | Default headers |
| Request body schema | `{ "token": "string" }` |
| Query parameters | None |
| Path parameters | None |
| Success response | `200`, verified user status |
| Error response | `400`, `401`, `409`, `500` |
| Validation rules | Valid non-expired token; user not already verified |
| Frontend screen | Verify email screen |
| Frontend action trigger | User opens verification link or submits code |
| State management flow | `idle -> loading -> verified` |
| Loading/error/empty states | Full-screen loading; expired token retry; no empty state |
| Recommended database entity | `users`, `email_verification_tokens`, `audit_logs` |
| Security considerations | One-time token; avoid leaking account status |
| Pagination requirements | None |
| Caching recommendations | Invalidate cached profile/session |

Request:

```json
{ "token": "verify-token" }
```

Response:

```json
{
  "success": true,
  "message": "Email verified successfully",
  "data": { "emailVerified": true },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

### Refresh Token

| Field | Contract |
| --- | --- |
| API name | Refresh Token |
| Endpoint URL | `/api/v1/auth/refresh-token` |
| HTTP method | `POST` |
| Authentication | Refresh token required in body, access token not required |
| Request headers | Default headers |
| Request body schema | `{ "refreshToken": "string", "deviceId": "string?" }` |
| Query parameters | None |
| Path parameters | None |
| Success response | `200`, new access and refresh token |
| Error response | `400`, `401`, `403`, `500` |
| Validation rules | Valid active token; device must match if provided |
| Frontend screen | Global auth interceptor |
| Frontend action trigger | Access token expired |
| State management flow | `request401 -> refreshing -> retryOriginalRequest`; failure logs out |
| Loading/error/empty states | Silent refresh; session expired dialog on failure |
| Recommended database entity | `refresh_tokens`, `users`, `audit_logs` |
| Security considerations | Refresh token rotation; reuse detection; revoke token family on theft |
| Pagination requirements | None |
| Caching recommendations | Do not cache |

Request:

```json
{
  "refreshToken": "opaque-refresh-token",
  "deviceId": "device-uuid"
}
```

Response:

```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "accessToken": "new-jwt-access-token",
    "refreshToken": "new-opaque-refresh-token",
    "expiresIn": 900
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

### Logout

| Field | Contract |
| --- | --- |
| API name | Logout |
| Endpoint URL | `/api/v1/auth/logout` |
| HTTP method | `POST` |
| Authentication | Required |
| Request headers | Default auth headers |
| Request body schema | `{ "refreshToken": "string?", "deviceId": "string?" }` |
| Query parameters | None |
| Path parameters | None |
| Success response | `200`, logout confirmation |
| Error response | `401`, `500` |
| Validation rules | Authenticated user required |
| Frontend screen | Settings/Profile/global session |
| Frontend action trigger | User taps logout or session cleanup |
| State management flow | `authenticated -> loggingOut -> unauthenticated` |
| Loading/error/empty states | Disable logout button; local logout even if server revoke fails after retry |
| Recommended database entity | `refresh_tokens`, `push_tokens`, `audit_logs` |
| Security considerations | Revoke refresh token and optionally push token |
| Pagination requirements | None |
| Caching recommendations | Clear all user-scoped caches |

Request:

```json
{
  "refreshToken": "opaque-refresh-token",
  "deviceId": "device-uuid"
}
```

Response:

```json
{
  "success": true,
  "message": "Logged out successfully",
  "data": {},
  "timestamp": "2026-05-23T10:30:00Z"
}
```

### Session Validation

| Field | Contract |
| --- | --- |
| API name | Session Validation |
| Endpoint URL | `/api/v1/auth/session` |
| HTTP method | `GET` |
| Authentication | Required |
| Request headers | Default auth headers |
| Request body schema | None |
| Query parameters | None |
| Path parameters | None |
| Success response | `200`, current user and permissions |
| Error response | `401`, `403`, `500` |
| Validation rules | Active user and valid JWT required |
| Frontend screen | Splash screen, app boot, route guard |
| Frontend action trigger | App starts or resumes |
| State management flow | `unknown -> validating -> authenticated/unauthenticated` |
| Loading/error/empty states | Splash animation while loading; route to login on unauthenticated |
| Recommended database entity | `users`, `user_preferences` |
| Security considerations | Do not return sensitive auth token hashes |
| Pagination requirements | None |
| Caching recommendations | Cache in memory only; refresh on app resume |

Request: none

Response:

```json
{
  "success": true,
  "message": "Session valid",
  "data": {
    "user": {
      "id": "user-uuid",
      "name": "Asha Patel",
      "role": "farmer",
      "emailVerified": true
    },
    "permissions": ["jobs:create", "workers:read"]
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## User Module

### User Endpoints

| API name | Endpoint URL | Method | Auth | Body schema | Query/path params | Success | Errors | Frontend screen/action | State flow and UI states | DB entity | Security | Pagination | Caching |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Get Profile | `/api/v1/users/profile` | `GET` | Required | None | None | `200`, user profile | `401`, `404`, `500` | Profile screen loads | `loading -> data`; skeleton, error retry, no empty unless profile incomplete | `users`, `user_profiles` | Owner-only | None | Cache in memory; invalidate after profile update |
| Update Profile | `/api/v1/users/profile` | `PATCH` | Required | `{ "name": "string?", "phone": "string?", "location": "object?", "farmerProfile": "object?", "workerProfile": "object?" }` | None | `200`, updated profile | `400`, `401`, `403`, `409`, `500` | Edit profile submit | `editing -> saving -> saved`; disable form, field errors | `users`, `user_profiles`, `worker_skills` | Owner-only; validate role-specific fields | None | Invalidate profile/dashboard cache |
| Upload Profile Image | `/api/v1/users/profile/image` | `POST` | Required | `multipart/form-data: image` | None | `200`, image URL | `400`, `401`, `413`, `500` | Profile image picker upload | `idle -> uploading -> uploaded`; progress, retry | `profile_images`, `users` | MIME/size validation; scan file | None | CDN cache with URL versioning |
| Change Password | `/api/v1/users/change-password` | `POST` | Required | `{ "currentPassword": "string", "newPassword": "string" }` | None | `200`, changed | `400`, `401`, `403`, `500` | Settings security action | `idle -> loading -> success`; form errors | `users`, `refresh_tokens`, `audit_logs` | Re-auth current password; revoke other sessions | None | Do not cache |
| Notification Preferences | `/api/v1/users/preferences/notifications` | `PATCH` | Required | `{ "pushEnabled": "boolean", "emailEnabled": "boolean", "jobAlerts": "boolean", "hiringUpdates": "boolean" }` | None | `200`, preferences | `400`, `401`, `500` | Settings notification toggles | Optimistic toggle; rollback on error | `user_preferences` | Owner-only | None | Cache with profile/preferences |
| Theme Preferences | `/api/v1/users/preferences/theme` | `PATCH` | Required | `{ "themeMode": "system|light|dark" }` | None | `200`, theme preference | `400`, `401`, `500` | Theme toggle/settings | Optimistic local apply; sync in background | `user_preferences` | Owner-only | None | Local-first cache; sync on login |
| User Dashboard Data | `/api/v1/users/dashboard` | `GET` | Required | None | Query: `role`, `from`, `to` optional | `200`, dashboard metrics | `400`, `401`, `403`, `500` | Farmer dashboard | `loading -> data`; cards skeleton, retry, empty metrics as zeros | `jobs`, `job_applications`, `hiring_requests`, `notifications` | Role-scoped aggregation | None | Cache 60 seconds; refresh on job/application changes |

Example update profile request:

```json
{
  "name": "Asha Patel",
  "phone": "+919876543210",
  "location": {
    "village": "Anand",
    "district": "Anand",
    "state": "Gujarat",
    "lat": 22.5645,
    "lng": 72.9289
  },
  "farmerProfile": {
    "farmSizeAcres": 8.5,
    "cropTypes": ["wheat", "cotton"]
  }
}
```

Example profile response:

```json
{
  "success": true,
  "message": "Profile fetched successfully",
  "data": {
    "id": "user-uuid",
    "name": "Asha Patel",
    "email": "asha@example.com",
    "role": "farmer",
    "profileImageUrl": "https://cdn.example.com/profile.jpg",
    "preferences": {
      "themeMode": "system",
      "language": "en",
      "pushEnabled": true
    }
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## Worker Module

### Worker Endpoints

| API name | Endpoint URL | Method | Auth | Body schema | Query/path params | Success | Errors | Frontend screen/action | State flow and UI states | DB entity | Security | Pagination | Caching |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Worker Listing | `/api/v1/workers` | `GET` | Required | None | Query: `limit`, `cursor`, `sort`, `district`, `availableFrom`, `availableTo` | `200`, paginated workers | `400`, `401`, `500` | Active workers screen loads | `loading -> list`; skeleton, retry, empty list copy | `users`, `user_profiles`, `worker_availability` | Authenticated users only; hide private fields | Required cursor pagination | Cache per filter for 60 seconds |
| Worker Search | `/api/v1/workers/search` | `GET` | Required | None | Query: `q`, `skills`, `minRate`, `maxRate`, `district`, `limit`, `cursor` | `200`, paginated workers | `400`, `401`, `500` | Search/filter interaction | Debounced `typing -> searching -> results`; empty state | `worker_skills`, `user_profiles` | Sanitize search query | Required cursor pagination | Cache query pages briefly |
| Worker Details | `/api/v1/workers/{workerId}` | `GET` | Required | None | Path: `workerId` | `200`, public worker profile | `401`, `404`, `500` | Worker details/public profile | `loading -> data`; skeleton, retry | `users`, `user_profiles`, `worker_skills`, `worker_availability` | Do not expose private contact unless allowed | None | Cache 5 minutes; invalidate after hiring request |
| Skill Filtering | `/api/v1/workers/skills` | `GET` | Required | None | Query: `q` optional | `200`, skill catalog | `401`, `500` | Skill picker/filter chips | `loading -> data`; empty if no skills | `worker_skills` | Authenticated users only | None | Cache for 24 hours |
| Worker Availability | `/api/v1/workers/{workerId}/availability` | `GET` | Required | None | Path: `workerId`; Query: `from`, `to` | `200`, availability windows | `400`, `401`, `404`, `500` | Worker details availability section | `loading -> data`; no availability empty state | `worker_availability` | Worker public visibility rules | None | Cache 2 minutes |
| Worker Hiring Request | `/api/v1/workers/{workerId}/hiring-requests` | `POST` | Required, farmer/admin | `{ "jobId": "uuid?", "message": "string", "startDate": "date", "endDate": "date?", "offeredRate": "number" }` | Path: `workerId` | `201`, hiring request | `400`, `401`, `403`, `404`, `409`, `500` | Worker details hire CTA | `idle -> submitting -> sent`; disable CTA, conflict error | `hiring_requests`, `jobs`, `notifications` | Farmer role; prevent duplicate pending request | None | Invalidate worker detail and notifications |

Example worker search request:

```text
GET /api/v1/workers/search?q=tractor&skills=harvesting,irrigation&district=Anand&limit=20
```

Example worker response:

```json
{
  "success": true,
  "message": "Workers fetched successfully",
  "data": {
    "items": [
      {
        "id": "worker-uuid",
        "name": "Ravi Kumar",
        "skills": ["harvesting", "tractor"],
        "rating": 4.8,
        "dailyRate": 700,
        "available": true,
        "location": { "district": "Anand", "state": "Gujarat" }
      }
    ],
    "pagination": {
      "limit": 20,
      "nextCursor": "cursor",
      "hasMore": true,
      "total": 42
    }
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## Job Module

### Job Endpoints

| API name | Endpoint URL | Method | Auth | Body schema | Query/path params | Success | Errors | Frontend screen/action | State flow and UI states | DB entity | Security | Pagination | Caching |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Create Job | `/api/v1/jobs` | `POST` | Required, farmer/admin | `{ "title": "string", "description": "string", "skills": ["string"], "location": "object", "startDate": "date", "endDate": "date?", "wage": "number", "slots": "number" }` | None | `201`, created job | `400`, `401`, `403`, `500` | Post job screen submit | `draft -> submitting -> created`; validation errors | `jobs`, `notifications` | Farmer role; validate location/date/wage | None | Invalidate job listings/dashboard |
| Update Job | `/api/v1/jobs/{jobId}` | `PATCH` | Required, owner/admin | Partial create schema | Path: `jobId` | `200`, updated job | `400`, `401`, `403`, `404`, `409`, `500` | Manage jobs edit action | `editing -> saving -> saved`; conflict if locked | `jobs`, `audit_logs` | Owner/admin; block updates after completed/cancelled as needed | None | Invalidate job detail/list |
| Delete Job | `/api/v1/jobs/{jobId}` | `DELETE` | Required, owner/admin | `{ "reason": "string?" }` optional | Path: `jobId` | `200`, deleted/cancelled | `401`, `403`, `404`, `409`, `500` | Manage jobs delete action | `confirm -> deleting -> removed`; show conflict on active work | `jobs`, `job_applications`, `audit_logs` | Soft delete preferred; notify applicants | None | Invalidate job caches |
| Job Listing | `/api/v1/jobs` | `GET` | Required | None | Query: `limit`, `cursor`, `status`, `skills`, `district`, `ownerId`, `availableOnly` | `200`, paginated jobs | `400`, `401`, `500` | Manage jobs/job browse | `loading -> list`; skeleton, empty state, loadingMore | `jobs`, `job_applications` | Role-scoped visibility | Required cursor pagination | Cache per filter 60 seconds |
| Job Details | `/api/v1/jobs/{jobId}` | `GET` | Required | None | Path: `jobId` | `200`, job detail | `401`, `403`, `404`, `500` | Job details card/page | `loading -> data`; retry on error | `jobs`, `job_applications`, `users` | Hide applicant private data unless owner/admin | None | Cache 2 minutes |
| Apply Job | `/api/v1/jobs/{jobId}/applications` | `POST` | Required, worker/admin | `{ "message": "string?", "expectedRate": "number?" }` | Path: `jobId` | `201`, application | `400`, `401`, `403`, `404`, `409`, `500` | Job details apply button | `idle -> applying -> applied`; duplicate conflict state | `job_applications`, `notifications` | Worker role; prevent applying to own/closed job | None | Invalidate job detail/list/dashboard |
| Job Status Updates | `/api/v1/jobs/{jobId}/status` | `PATCH` | Required, owner/admin | `{ "status": "draft|open|assigned|in_progress|completed|cancelled", "reason": "string?" }` | Path: `jobId` | `200`, updated status | `400`, `401`, `403`, `404`, `409`, `500` | Manage jobs status action | Optimistic status chip; rollback on conflict | `jobs`, `audit_logs`, `notifications` | Enforce state machine and ownership | None | Invalidate job/dashboard caches |

Example create job request:

```json
{
  "title": "Cotton harvesting support",
  "description": "Need experienced workers for cotton harvest.",
  "skills": ["harvesting"],
  "location": {
    "village": "Borsad",
    "district": "Anand",
    "state": "Gujarat",
    "lat": 22.407,
    "lng": 72.898
  },
  "startDate": "2026-06-01",
  "endDate": "2026-06-05",
  "wage": 750,
  "slots": 4
}
```

Example job response:

```json
{
  "success": true,
  "message": "Job created successfully",
  "data": {
    "id": "job-uuid",
    "title": "Cotton harvesting support",
    "status": "open",
    "wage": 750,
    "slots": 4,
    "applicationsCount": 0
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## Notification Module

### Notification Endpoints

| API name | Endpoint URL | Method | Auth | Body schema | Query/path params | Success | Errors | Frontend screen/action | State flow and UI states | DB entity | Security | Pagination | Caching |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Register Push Notifications | `/api/v1/notifications/push-tokens` | `POST` | Required | `{ "token": "string", "platform": "ios|android|web", "deviceId": "string" }` | None | `200`, token registered | `400`, `401`, `500` | App boot/settings notification enable | Background sync; silent errors logged | `push_tokens` | Owner-only; rotate token per device | None | Do not cache |
| In-App Notifications | `/api/v1/notifications` | `GET` | Required | None | Query: `limit`, `cursor`, `status=read|unread|all`, `type` | `200`, paginated notifications | `400`, `401`, `500` | Notification panel/history | `loading -> list`; unread badge, empty state | `notifications` | User-scoped only | Required cursor pagination | Cache first page 30 seconds |
| Read/Unread Status | `/api/v1/notifications/{notificationId}/read-state` | `PATCH` | Required | `{ "read": "boolean" }` | Path: `notificationId` | `200`, updated notification | `400`, `401`, `403`, `404`, `500` | Notification row tap/mark unread | Optimistic update; rollback on error | `notifications` | Owner-only | None | Invalidate notification count |
| Notification History | `/api/v1/notifications/history` | `GET` | Required | None | Query: `limit`, `cursor`, `from`, `to`, `type` | `200`, paginated history | `400`, `401`, `500` | Settings/history screen | `loading -> history`; date empty state | `notifications` | User-scoped only | Required cursor pagination | Cache per date filter |

Example notification response:

```json
{
  "success": true,
  "message": "Notifications fetched successfully",
  "data": {
    "items": [
      {
        "id": "notification-uuid",
        "type": "job_application",
        "title": "New worker application",
        "body": "Ravi applied to Cotton harvesting support.",
        "read": false,
        "createdAt": "2026-05-23T10:30:00Z"
      }
    ],
    "pagination": {
      "limit": 20,
      "nextCursor": null,
      "hasMore": false,
      "total": 1
    }
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## Settings Module

### Settings Endpoints

| API name | Endpoint URL | Method | Auth | Body schema | Query/path params | Success | Errors | Frontend screen/action | State flow and UI states | DB entity | Security | Pagination | Caching |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Theme Settings | `/api/v1/settings/theme` | `GET`/`PATCH` | Required | PATCH: `{ "themeMode": "system|light|dark" }` | None | `200`, theme settings | `400`, `401`, `500` | Settings/theme toggle | Local optimistic apply; sync result | `user_preferences` | Owner-only | None | Local-first; sync on login |
| App Preferences | `/api/v1/settings/preferences` | `GET`/`PATCH` | Required | PATCH: `{ "compactMode": "boolean?", "defaultDashboard": "string?", "dateFormat": "string?" }` | None | `200`, app preferences | `400`, `401`, `500` | Settings preferences | `loading/saving -> data`; rollback failed optimistic edits | `user_preferences` | Owner-only | None | Cache with profile |
| Device Settings | `/api/v1/settings/devices` | `GET`/`DELETE` | Required | DELETE: none | Path for DELETE: `/api/v1/settings/devices/{deviceId}` | `200`, devices or removed device | `401`, `403`, `404`, `500` | Settings active sessions/devices | `loading -> list`; empty if no extra devices | `refresh_tokens`, `push_tokens` | Owner-only; revoke selected device token | None | Do not cache longer than session |
| Language Preferences | `/api/v1/settings/language` | `GET`/`PATCH` | Required | PATCH: `{ "language": "en|hi|gu|mr|..." }` | None | `200`, language preference | `400`, `401`, `500` | Settings language picker | Optimistic apply; fallback to previous language on error | `user_preferences` | Owner-only | None | Local-first; sync on login |

Example app preferences request:

```json
{
  "compactMode": false,
  "defaultDashboard": "farmer",
  "dateFormat": "dd MMM yyyy"
}
```

Example settings response:

```json
{
  "success": true,
  "message": "Settings updated successfully",
  "data": {
    "themeMode": "system",
    "language": "en",
    "compactMode": false,
    "defaultDashboard": "farmer"
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## Backend Module Layout Recommendation

```text
src/
  modules/
    auth/
      auth.controller.ts
      auth.service.ts
      auth.routes.ts
      auth.validation.ts
    users/
    workers/
    jobs/
    notifications/
    settings/
  middleware/
    authenticate.ts
    authorizeRole.ts
    validateRequest.ts
    errorHandler.ts
  database/
    entities/
    migrations/
  shared/
    response.ts
    pagination.ts
    security.ts
```

## Frontend Integration Checklist

- Keep endpoint constants in `lib/src/core/constants`.
- Keep Dio auth refresh in the auth interceptor.
- Repositories return domain entities, not raw DTO maps.
- Controllers expose `loading`, `error`, `data`, `empty`, and pagination flags.
- Mutations invalidate affected profile, dashboard, listing, and detail caches.
- Every command endpoint should surface backend validation details by field where possible.

