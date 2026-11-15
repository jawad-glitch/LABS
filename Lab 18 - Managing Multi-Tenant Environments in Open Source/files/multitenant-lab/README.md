# Multi-Tenant SaaS API Lab

## Tenant resolution
Every login and protected request uses the `X-Tenant-Name` HTTP header.
Allowed values are `alpha`, `beta`, and `gamma`. The tenant claim inside
the signed JWT must match this header; mismatches are rejected with HTTP 403.

## Isolation design
The shared PostgreSQL `public` schema contains `tenants` and `tenant_users`.
Business records are stored in separate PostgreSQL schemas:
`tenant_alpha`, `tenant_beta`, and `tenant_gamma`.
The API selects a schema from a fixed server-side allowlist and uses
psycopg2 SQL identifier composition for `search_path`. Client input is
never used directly as a schema identifier.

## Roles
`admin` can read and create items. `user` can read items only.
The role is read from the database at login and signed into the JWT.
Write authorization is enforced by the API.

## Redis
Redis stores revoked JWT identifiers until their expiry time.
The API checks the revocation list for every authenticated request.

## Demo accounts
For each tenant:
- admin / AdminPass123!
- user / UserPass123!

These credentials and the JWT secret are for local lab use only.
Change them before any real deployment.

## Start
`sudo docker compose up -d --build`

## API
- `GET /health`
- `POST /login` with `X-Tenant-Name`
- `GET /items` with bearer JWT and tenant header
- `POST /items` with bearer JWT and tenant header
- `POST /logout` with bearer JWT and tenant header
