# FarmConnect API Architecture

This document is the backend implementation contract for the FarmConnect Flutter frontend. It keeps the current mobile, tablet, and web product direction intact while defining production-ready REST APIs for auth, users, workers, jobs, notifications, and settings.

## Base Contract

- Base URL: `https://<api-host>/api/v1`
- Transport: HTTPS only
- Content types: `application/json`; use `multipart/form-data` only for binary uploads
- Time format: ISO-8601 UTC, for example `2026-05-23T10:30:00Z`
- IDs: UUID strings
- Roles: `farmer`, `worker`, `admin`
- Auth scheme: `Authorization: Bearer <accessToken>`
- Client platforms: `mobile`, `tablet`, `web`

## Standard Response

```json
{
  "success": true,
  "message": "Profile fetched successfully",
  "data": {},
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## Standard Error

```json
{
  "success": false,
  "message": "Validation failed",
  "error": {
    "code": "VALIDATION_ERROR",
    "details": [
      {
        "field": "email",
        "message": "Enter a valid email address"
      }
    ],
    "requestId": "req_01JZ..."
  },
  "timestamp": "2026-05-23T10:30:00Z"
}
```

## Status Codes

| Code | Use |
| --- | --- |
| `200` | Successful read, update, login, logout, status mutation |
| `201` | Resource created, such as signup, job creation, application, hiring request |
| `400` | Invalid request body, query, path parameter, or business rule |
| `401` | Missing, expired, or invalid access token |
| `403` | Authenticated user lacks role/ownership permission |
| `404` | Resource not found or not visible to the current user |
| `409` | Conflict, duplicate email, duplicate job application, invalid state transition |
| `500` | Unexpected server failure |

## JWT Flow

1. Login/signup returns `accessToken`, `refreshToken`, `expiresIn`, and the current user.
2. Frontend stores access token in secure storage and attaches it to authenticated requests.
3. When an API returns `401` with `TOKEN_EXPIRED`, the Dio auth interceptor calls `/api/v1/auth/refresh-token`.
4. Refresh token rotation is required. Return a new access token and refresh token every time.
5. If refresh fails, clear secure storage, reset auth state, and route the user to login.
6. Logout revokes the active refresh token server-side.

## Headers

| Header | Required | Description |
| --- | --- | --- |
| `Authorization` | Auth APIs only when specified | `Bearer <accessToken>` |
| `Content-Type` | Yes | `application/json` or `multipart/form-data` |
| `Accept` | Yes | `application/json` |
| `X-Client-Platform` | Recommended | `mobile`, `tablet`, or `web` |
| `X-App-Version` | Recommended | Flutter app version |
| `X-Request-Id` | Recommended | Client-generated UUID for tracing |

## Pagination

Use cursor pagination for high-change feeds and listings.

```json
{
  "items": [],
  "pagination": {
    "limit": 20,
    "nextCursor": "eyJjcmVhdGVkQXQiOiIyMDI2...",
    "hasMore": true,
    "total": 128
  }
}
```

Common query params: `limit`, `cursor`, `sort`, `order`. Maximum `limit` is `100`.

## Role And Ownership Rules

| Role | Permissions |
| --- | --- |
| `farmer` | Create/manage owned jobs, browse workers, send hiring requests, manage own profile/settings |
| `worker` | Browse jobs, apply to jobs, manage worker profile/skills/availability, respond to hiring requests |
| `admin` | Moderate users/jobs, access platform-level dashboards, manage unsafe content |

Ownership must be enforced on every update/delete endpoint. The frontend should not be trusted for role or owner checks.

## State Management Contract

Frontend controllers should follow this flow:

1. Set state to `loading` and clear stale command errors.
2. Call repository API method.
3. Normalize success data into domain entities.
4. Set state to `data`.
5. On error, map server `error.code` to UI copy and set state to `error`.
6. For list endpoints, maintain `loadingMore`, `refreshing`, `empty`, and `hasMore` flags separately.

## Database Entity Map

| Entity | Purpose |
| --- | --- |
| `users` | Identity, role, status, email verification, auth profile |
| `user_profiles` | Farmer/worker public profile details |
| `profile_images` | Uploaded media metadata and URLs |
| `refresh_tokens` | Rotated refresh token hashes, device metadata, expiry |
| `password_reset_tokens` | Hashed reset tokens and expiry |
| `email_verification_tokens` | Hashed verification tokens and expiry |
| `worker_skills` | Worker skill taxonomy and user mappings |
| `worker_availability` | Worker availability windows, locations, rates |
| `jobs` | Farmer-created job posts |
| `job_applications` | Worker applications to jobs |
| `hiring_requests` | Farmer-to-worker direct hiring requests |
| `notifications` | In-app notification records |
| `push_tokens` | Device push tokens by user/device |
| `user_preferences` | Theme, language, notifications, app preferences |
| `audit_logs` | Security-sensitive actions and admin operations |

## Security Baseline

- Hash passwords with Argon2id or bcrypt.
- Hash refresh/reset/verification tokens at rest.
- Rate-limit auth endpoints by IP, email, and device fingerprint.
- Validate all request bodies server-side with explicit schemas.
- Return generic auth errors for login and reset flows.
- Use signed upload URLs or server-side MIME validation for images.
- Add audit logs for login, logout, password changes, email changes, job deletion, and admin actions.
- Enforce CORS allow-list for web production domains.

