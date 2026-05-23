# FarmConnect Frontend API Architecture

All frontend operations must use this response envelope.

Success:

```json
{
  "success": true,
  "message": "Data fetched successfully",
  "data": {},
  "timestamp": "2026-05-23T00:00:00.000Z"
}
```

Error:

```json
{
  "success": false,
  "message": "Unauthorized",
  "errorCode": "AUTH_401",
  "timestamp": "2026-05-23T00:00:00.000Z"
}
```

## Shared Frontend Rules

- HTTP client: Dio.
- State management: Riverpod async providers/controllers.
- Auth header: `Authorization: Bearer <token>` for private/protected routes.
- Timeouts: use app-level Dio timeout settings.
- Loading state: show progress indicator or skeleton-equivalent app surface.
- Empty state: show a non-demo message and retry/navigation action.
- Error state: show backend `message` when present, otherwise a safe fallback.
- Pagination: list endpoints should return `data.items`, `data.page`, `data.limit`, `data.total`, `data.hasMore`.
- Security: public preview endpoints must never return private phone, private address, tokens, password metadata, admin flags, or internal audit fields.

## Auth Module

### Login
- Endpoint: `/api/auth/login`
- Method: `POST`
- Access: Public
- Authentication Required: No
- Headers: `Content-Type: application/json`
- Request Body: `{ "email": "string", "password": "string", "role": "farmer|worker|admin" }`
- Success Response: `data.token`, optional `data.userProfile.role`
- Error Response: `AUTH_401`, `AUTH_EMAIL_UNVERIFIED`, `VALIDATION_400`
- Validation Rules: valid email, password min length, role required
- Frontend Screen Usage: Login page
- Triggering UI Action: submit login form
- Database Entity Recommendation: users, auth_sessions, refresh_tokens
- Pagination Structure: none
- Security Considerations: rate-limit, do not expose password state, return short-lived access token
- Loading/Error State Expectations: disable submit, show verification prompt on unverified email

### Signup
- Endpoint: `/api/auth/register/user`
- Method: `POST`
- Access: Public
- Authentication Required: No
- Headers: `Content-Type: application/json`
- Request Body: `{ "name": "string", "email": "string", "password": "string", "role": "farmer|worker" }`
- Success Response: optional `data.token`, `message`
- Error Response: `AUTH_EMAIL_EXISTS`, `VALIDATION_400`
- Validation Rules: name required, valid email, strong password, valid role
- Frontend Screen Usage: Signup page
- Triggering UI Action: submit signup form
- Database Entity Recommendation: users, user_profiles
- Pagination Structure: none
- Security Considerations: hash passwords, verify email before sensitive access
- Loading/Error State Expectations: disable submit, show backend validation message

### Logout
- Endpoint: `/api/auth/logout`
- Method: `POST`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Request Body: optional refresh token/session id
- Success Response: `message`
- Error Response: `AUTH_401`
- Validation Rules: valid active session
- Frontend Screen Usage: Dashboard/settings
- Triggering UI Action: logout button
- Database Entity Recommendation: auth_sessions, refresh_tokens
- Pagination Structure: none
- Security Considerations: revoke refresh token and clear secure storage
- Loading/Error State Expectations: clear local state on success

### Refresh Token
- Endpoint: `/api/auth/refresh`
- Method: `POST`
- Access: Private
- Authentication Required: refresh token
- Headers: `Content-Type: application/json`
- Request Body: `{ "refreshToken": "string" }`
- Success Response: `data.token`, optional rotated `data.refreshToken`
- Error Response: `AUTH_REFRESH_EXPIRED`, `AUTH_401`
- Validation Rules: token must be active and unexpired
- Frontend Screen Usage: Dio interceptor/session bootstrap
- Triggering UI Action: automatic on 401/expiry
- Database Entity Recommendation: refresh_tokens
- Pagination Structure: none
- Security Considerations: rotate tokens, detect reuse
- Loading/Error State Expectations: retry original request once, then redirect to login

### Forgot Password
- Endpoint: `/api/auth/forgot-password`
- Method: `POST`
- Access: Public
- Authentication Required: No
- Headers: `Content-Type: application/json`
- Request Body: `{ "email": "string" }`
- Success Response: generic `message`
- Error Response: `VALIDATION_400`
- Validation Rules: valid email
- Frontend Screen Usage: Forgot password page
- Triggering UI Action: submit email
- Database Entity Recommendation: password_reset_tokens
- Pagination Structure: none
- Security Considerations: do not reveal account existence
- Loading/Error State Expectations: show generic success

### Reset Password
- Endpoint: `/api/auth/reset-password`
- Method: `POST`
- Access: Public
- Authentication Required: reset token
- Headers: `Content-Type: application/json`
- Request Body: `{ "token": "string", "newPassword": "string" }`
- Success Response: `message`
- Error Response: `AUTH_RESET_EXPIRED`, `VALIDATION_400`
- Validation Rules: token required, password policy
- Frontend Screen Usage: Reset password page
- Triggering UI Action: submit new password
- Database Entity Recommendation: password_reset_tokens, users
- Pagination Structure: none
- Security Considerations: one-time token, revoke active sessions after reset
- Loading/Error State Expectations: redirect to login on success

### Verify Email/OTP
- Endpoint: `/api/auth/verify-email`
- Method: `GET` or `POST`
- Access: Public
- Authentication Required: verification token/OTP
- Headers: `Content-Type: application/json` when POST
- Query Parameters: `token`
- Request Body: optional `{ "token": "string" }`
- Success Response: `message`
- Error Response: `AUTH_VERIFY_EXPIRED`, `VALIDATION_400`
- Validation Rules: token required
- Frontend Screen Usage: Verify email page
- Triggering UI Action: submit token
- Database Entity Recommendation: email_verification_tokens, users
- Pagination Structure: none
- Security Considerations: one-time token, rate-limit resends
- Loading/Error State Expectations: redirect to login on success

## User Module

### Get Profile
- Endpoint: `/api/users/profile`
- Method: `GET`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Success Response: `data.profile`
- Error Response: `AUTH_401`, `USER_404`
- Validation Rules: token user id must exist
- Frontend Screen Usage: profile, settings, role flows
- Triggering UI Action: page load/refresh
- Database Entity Recommendation: users, user_profiles, worker_profiles, farmer_profiles
- Pagination Structure: none
- Security Considerations: return private data only to owner
- Loading/Error State Expectations: full-page loading/error with retry

### Update Profile
- Endpoint: `/api/users/profile`
- Method: `PUT`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`, `Content-Type: application/json`
- Request Body: fullName, phone, location, address, bio, language
- Success Response: `data.profile`
- Error Response: `VALIDATION_400`, `AUTH_401`
- Validation Rules: fullName required, phone format, field length limits
- Frontend Screen Usage: edit profile
- Triggering UI Action: save profile
- Database Entity Recommendation: user_profiles
- Pagination Structure: none
- Security Considerations: sanitize bio/address fields
- Loading/Error State Expectations: disable save, show backend message

### Upload Image
- Endpoint: `/api/users/profile/image`
- Method: `POST`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`, `Content-Type: multipart/form-data`
- Request Body: `image`
- Success Response: `data.profileImageUrl`
- Error Response: `FILE_TOO_LARGE`, `UNSUPPORTED_MEDIA`, `AUTH_401`
- Validation Rules: image mime type, max size, dimensions
- Frontend Screen Usage: profile edit/header
- Triggering UI Action: choose/upload image
- Database Entity Recommendation: media_assets, user_profiles
- Pagination Structure: none
- Security Considerations: scan uploads, signed URLs
- Loading/Error State Expectations: image progress and retry

### Change Password
- Endpoint: `/api/users/password`
- Method: `PUT`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Request Body: `{ "currentPassword": "string", "newPassword": "string" }`
- Success Response: `message`
- Error Response: `AUTH_401`, `VALIDATION_400`
- Validation Rules: current password required, new password policy
- Frontend Screen Usage: settings
- Triggering UI Action: change password form
- Database Entity Recommendation: users, auth_sessions
- Pagination Structure: none
- Security Considerations: revoke sessions after change
- Loading/Error State Expectations: disable submit, show confirmation

### Preferences and Theme Settings
- Endpoint: `/api/users/settings/preferences`
- Method: `GET/PUT`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Request Body: notification/theme/language preferences
- Success Response: `data.settings`
- Error Response: `AUTH_401`, `VALIDATION_400`
- Validation Rules: enum validation
- Frontend Screen Usage: settings/theme controller sync
- Triggering UI Action: settings changes
- Database Entity Recommendation: user_settings
- Pagination Structure: none
- Security Considerations: owner-only
- Loading/Error State Expectations: optimistic update with rollback on error

## Worker Module

### List/Search/Filter Workers
- Endpoint: `/api/users/filter/workers/available`
- Method: `GET`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Query Parameters: `skill`, `location`, `page`, `limit`
- Success Response: `data.users`, pagination metadata
- Error Response: `AUTH_401`, `VALIDATION_400`
- Validation Rules: page >= 1, limit max enforced
- Frontend Screen Usage: active workers
- Triggering UI Action: page load, filters, load more
- Database Entity Recommendation: users, worker_profiles, skills
- Pagination Structure: required
- Security Considerations: hide private contact fields
- Loading/Error State Expectations: loading grid, empty state, retry

### Worker Details and Availability
- Endpoint: `/api/users/public/:id` or `/api/v1/workers/:id`
- Method: `GET`
- Access: Private/Public depending route
- Authentication Required: No for preview, yes for internal private detail if sensitive
- Path Parameters: `id`
- Success Response: public-safe worker profile
- Error Response: `USER_404`, `PROFILE_PRIVATE`
- Validation Rules: valid id
- Frontend Screen Usage: worker detail, `/preview/worker/:id`
- Triggering UI Action: open worker card or direct preview URL
- Database Entity Recommendation: worker_profiles, skills, availability
- Pagination Structure: none
- Security Considerations: public endpoint must omit private fields
- Loading/Error State Expectations: preview loading/error card

## Job Module

### Create Job
- Endpoint: `/api/v1/jobs`
- Method: `POST`
- Access: Protected
- Authentication Required: Yes
- Headers: `Authorization`
- Request Body: title, location, wage, description
- Success Response: `data.job`
- Error Response: `AUTH_401`, `AUTH_403`, `VALIDATION_400`
- Validation Rules: farmer role, title required, wage numeric
- Frontend Screen Usage: post job
- Triggering UI Action: save job
- Database Entity Recommendation: jobs, job_requirements
- Pagination Structure: none
- Security Considerations: farmer-only guard
- Loading/Error State Expectations: disable submit, snackbar error/success

### Update/Delete/Apply Job
- Endpoint: `/api/v1/jobs/:id`, `/api/v1/jobs/:id/applications`
- Method: `PUT`, `DELETE`, `POST`
- Access: Protected
- Authentication Required: Yes
- Headers: `Authorization`
- Path Parameters: `id`
- Request Body: update fields or application payload
- Success Response: `data.job` or `message`
- Error Response: `AUTH_401`, `AUTH_403`, `JOB_404`, `VALIDATION_400`
- Validation Rules: owner/role checks
- Frontend Screen Usage: job management/detail
- Triggering UI Action: edit/delete/apply
- Database Entity Recommendation: jobs, job_applications
- Pagination Structure: none
- Security Considerations: owner-only updates, worker-only applications
- Loading/Error State Expectations: disable action, show retry

### Job Listing and Details
- Endpoint: `/api/v1/jobs/my`, `/api/v1/jobs/:id`
- Method: `GET`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Query Parameters: `status`, `page`, `limit`
- Success Response: `data.jobs` or `data.job`
- Error Response: `AUTH_401`, `JOB_404`
- Validation Rules: status enum
- Frontend Screen Usage: manage jobs
- Triggering UI Action: tab load/refresh
- Database Entity Recommendation: jobs
- Pagination Structure: required for list
- Security Considerations: return owner-visible jobs only
- Loading/Error State Expectations: tab-level loading/error/empty states

## Notification Module

### Notifications List
- Endpoint: `/api/v1/notifications`
- Method: `GET`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Query Parameters: `page`, `limit`, `unreadOnly`
- Success Response: `data.notifications`, pagination metadata
- Error Response: `AUTH_401`
- Validation Rules: pagination constraints
- Frontend Screen Usage: notifications screen/menu
- Triggering UI Action: open notifications
- Database Entity Recommendation: notifications
- Pagination Structure: required
- Security Considerations: user-scoped only
- Loading/Error State Expectations: loading list, empty state

### Read/Unread and Push Token Registration
- Endpoint: `/api/v1/notifications/:id/read`, `/api/v1/notifications/push-token`
- Method: `PUT`, `POST`
- Access: Private
- Authentication Required: Yes
- Headers: `Authorization`
- Path Parameters: notification `id`
- Request Body: push token/device metadata for registration
- Success Response: `message`
- Error Response: `AUTH_401`, `NOTIFICATION_404`
- Validation Rules: id required, token required
- Frontend Screen Usage: notifications/settings
- Triggering UI Action: mark read/register device
- Database Entity Recommendation: notifications, device_tokens
- Pagination Structure: none
- Security Considerations: token belongs to current user
- Loading/Error State Expectations: optimistic update with rollback

## Preview Module

### Public Profile Preview
- Endpoint: `/api/users/public/:id`
- Method: `GET`
- Access: Public temporary preview
- Authentication Required: No
- Path Parameters: `id`
- Success Response: public-safe profile
- Error Response: `USER_404`, `PROFILE_PRIVATE`
- Validation Rules: valid id
- Frontend Screen Usage: `/preview/profile/:id`
- Triggering UI Action: direct URL/share link
- Database Entity Recommendation: users, user_profiles, privacy_settings
- Pagination Structure: none
- Security Considerations: omit private fields
- Loading/Error State Expectations: public loading/error state card

### Public Worker Preview
- Endpoint: `/api/users/public/:id` or `/api/v1/public/workers/:id`
- Method: `GET`
- Access: Public temporary preview
- Authentication Required: No
- Path Parameters: `id`
- Success Response: public-safe worker profile
- Error Response: `WORKER_404`, `PROFILE_PRIVATE`
- Validation Rules: valid worker id
- Frontend Screen Usage: `/preview/worker/:id`
- Triggering UI Action: direct URL/share link
- Database Entity Recommendation: worker_profiles
- Pagination Structure: none
- Security Considerations: omit private contact data
- Loading/Error State Expectations: public loading/error state card

### Public Job Preview
- Endpoint: `/api/v1/public/jobs/:id`
- Method: `GET`
- Access: Public temporary preview
- Authentication Required: No
- Path Parameters: `id`
- Success Response: public-safe job
- Error Response: `JOB_404`, `JOB_PRIVATE`
- Validation Rules: valid job id
- Frontend Screen Usage: `/preview/job/:id`
- Triggering UI Action: direct URL/share link
- Database Entity Recommendation: jobs
- Pagination Structure: none
- Security Considerations: omit applicant and farmer private data
- Loading/Error State Expectations: public loading/error state card
