
## Recommended feature set

### Phase 1 — MVP (ship this first)

|Area|Features|Owner|
|---|---|---|
|Auth & tenancy|Sign up/in, org creation, org switcher, membership required mode|Clerk|
|Invites|Invite by email, accept/revoke, role on invite|Clerk (`<OrganizationProfile />` or API)|
|Channels|`#general` auto-created, admins create/delete, all members join/leave|Convex|
|Messaging|Real-time messages in channels, edit/delete own messages|Convex|
|Presence|Online indicator (optional v1.1)|Convex|
|RBAC|Admin vs Member roles, permission checks on sensitive actions|Clerk|
|Billing shell|Free + Paid org plans, upgrade UI|Clerk Billing|

### Phase 2 — Slack parity (post-MVP)

- Threads — reply in thread on a message
- DMs — 1:1 and small group DMs
- Reactions — emoji on messages
- File uploads — Convex file storage
- Search — message history search
- Notifications — unread counts, @mentions
- Pinned messages — per channel

### Phase 3 — Enterprise (paid differentiators)

- SSO / verified domains — Clerk Enterprise
- Audit log — who did what, when
- Message retention policies
- Guest / external users
- Custom roles — e.g. `org:moderator` with channel-only admin powers

---

## Free vs paid — suggested gating

Use Clerk Organization Plans with Features (not raw plan checks everywhere). Billing gates permissions automatically: if a permission’s feature slug isn’t on the active plan, `has({ permission })` returns false even for admins.

### Suggested plans

||Free (`org:free`)|Pro (`org:pro`)|
|---|---|---|
|Seats|Up to 10 members|Up to 50 (or unlimited tier)|
|Channels|5 public channels|Unlimited|
|Message history|90 days|Unlimited|
|File uploads|❌|✅ (`files` feature)|
|Threads|❌|✅ (`threads` feature)|
|Search|Last 30 days|Full history (`search` feature)|
|SSO|❌|✅ (`sso` feature)|
|Audit log|❌|✅ (`audit_log` feature)|

### Clerk Dashboard setup

1. Enable Organizations → Membership required (B2B-only)
2. Enable Billing → Organization Plans tab
3. Create plans: `org:free` (default), `org:pro`
4. Attach features per plan in Dashboard → Billing → Plans → Features
5. Create custom permissions tied to those features:

|Permission|Feature slug|Who gets it|
|---|---|---|
|`org:channels:create`|`channels`|`org:admin`|
|`org:channels:delete`|`channels`|`org:admin`|
|`org:files:upload`|`files`|all members on Pro|
|`org:threads:use`|`threads`|all members on Pro|
|`org:search:full`|`search`|all members on Pro|

System permissions stay as Clerk defaults:

- `org:sys_memberships:manage` — invite/remove (admins)
- `org:sys_billing:manage` — billing page (admins)

---

## Who owns what: Clerk vs Convex

Clerk (identity, orgs, billing, RBAC)Convex (app data + real-time)Next.jsJWT with orgIdwebhookshas role/permission/featureAuth / sessionsOrganizationsInvitationsRoles & permissionsPlans & featuresChannelsChannel membershipsMessagesOrg sync via webhooksUI + middleware

Clerk handles: users, orgs, invites, roles, billing, `has({ role | permission | feature | plan })`

Convex handles: channels, messages, channel membership, real-time subscriptions, message history limits (enforce server-side too)

Rule of thumb: If it’s about _who the user is_ or _what they’re allowed to do org-wide_, use Clerk. If it’s _messaging data_, use Convex.

---

## RBAC model for your app

### Default roles (start here)

|Role|Capabilities|
|---|---|
|`org:admin`|Create/delete channels, manage members, billing, all messaging|
|`org:member`|Join/leave channels, send messages, read history (within plan limits)|

### Optional custom role (Phase 2)

|Role|Capabilities|
|---|---|
|`org:moderator`|Delete any message, pin messages — but not billing or member management|

### Where to enforce

|Layer|Use for|
|---|---|
|Next.js middleware|Signed in + has `orgId` on `/orgs/[slug]/*`|
|`<Show when={{ permission }}>`|Hide create-channel button, billing UI|
|`auth().has()` in Server Components|Page-level gates|
|Convex mutations|Authoritative checks — never trust the client|

Convex can read org context from the Clerk JWT (`identity.orgId`, custom claims for role if you add them to the JWT template). For permission checks in Convex, either:

- Pass org-scoped actions only after Next.js has gated them, and verify membership in Convex, or
- Use Clerk Backend API in a Convex action for sensitive ops (slower; prefer JWT claims)

Recommended: add `org_id` and `org_role` to the Clerk JWT template for Convex so mutations can check role without extra API calls.

---

## Convex data model (sketch)

// organizations — synced from Clerk webhooks

{ clerkOrgId, name, slug, planSlug?, createdAt }

// channels

{ orgId, name, slug, type: "public" | "private", createdBy, createdAt, isDefault? }

// channelMembers

{ channelId, userId, joinedAt }

// messages

{ channelId, authorId, body, createdAt, editedAt?, threadId?, deletedAt? }

// users — optional mirror of Clerk users for display names/avatars

{ clerkUserId, name, imageUrl, tokenIdentifier }

Indexes you’ll want early:

- `channels.by_org`
- `messages.by_channel_and_created`
- `channelMembers.by_channel_and_user`
- `organizations.by_clerk_org_id`

---

## User flows

### Invite flow (Clerk-owned)

1. Admin opens `<OrganizationProfile />` Members tab or calls invite API
2. Clerk sends email; invitee signs up / signs in
3. Webhook `organizationMembership.created` → Convex creates/updates user + org record
4. User lands in org workspace with `#general` already joined

### Channel flow

1. Admin with `org:channels:create` (Pro + admin role) creates `#engineering`
2. All org members can join public channels
3. Messages stream via `useQuery(api.messages.list, { channelId })` — reactive by default

### Billing flow (Clerk Billing)

1. Admin visits `/orgs/[slug]/billing` → `<PricingTable for="organization" />`
2. Checkout in Clerk drawer
3. `has({ feature: 'threads' })` unlocks thread UI
4. Seat cap enforced by Clerk on invite (`maxAllowedMemberships` on plan)

---

## Suggested route structure

/sign-in, /sign-up

/session-tasks/choose-organization # Clerk task if needed

/orgs/[slug]/

├── (workspace) # channel list + message pane

├── channels/new # admin only

├── settings/members # OrganizationProfile

└── settings/billing # PricingTable for="organization"

Always verify `auth().orgSlug === params.slug` on org-scoped pages.

---

## Implementation order

1. Clerk + Convex wiring — `ClerkProvider`, `ConvexProviderWithClerk`, middleware, `convex/auth.config.ts`
2. Clerk Dashboard — enable orgs, billing, roles, custom permissions, 2 org plans
3. Webhooks — sync org/user/membership to Convex
4. Core messaging — channels CRUD, join/leave, send/list messages
5. RBAC in UI + Convex — permission checks on create/delete channel
6. Billing gates — feature-gated threads/files/search when you add them
7. Polish — unread counts, typing indicators, mobile layout

---

## Decisions to make now

1. Membership mode: `Membership required` (pure B2B) — recommended for you
2. Channel types: public only for MVP, or public + private from day one?
3. Free seat limit: 10 is a common default; Clerk enforces via plan seat cap
4. History retention: enforce in Convex queries (`createdAt > cutoff`) based on plan synced from Clerk webhook

---

## What I’d gate vs keep free

Keep free (drives adoption):

- Unlimited messages within seat/channel limits
- Real-time messaging in public channels
- Basic member management (within seat cap)

Gate on Pro (clear upgrade value):

- More seats + unlimited channels
- Threads, files, full search
- SSO + audit log for enterprise upsell

Avoid gating core messaging on the free tier — that hurts activation. Gate scale (seats, channels, history) and power features (threads, files, SSO).


## Phase 0: Account & application

### 1. Create a Clerk account and application

- Sign up: [dashboard.clerk.com/sign-up](https://dashboard.clerk.com/sign-up)
- Create an app: [dashboard.clerk.com/apps/new](https://dashboard.clerk.com/apps/new)
- Name it something like WorkSyndicate (dev instance is fine for now)

Alternative (CLI): If you have the Clerk CLI linked locally:

clerk auth login

clerk link # or clerk link --app app_xxx

clerk env pull # writes keys to .env.local

---

## Phase 1: API keys & environment variables

### 2. Copy API keys

Dashboard: [API Keys](https://dashboard.clerk.com/last-active?path=api-keys)

Add these to `.env.local` in your project root:

NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...

CLERK_SECRET_KEY=sk_test_...

### 3. Set Clerk redirect URLs (paths)

In Dashboard → Configure → Paths (or Domains & URLs), set:

|Setting|Suggested value|
|---|---|
|Sign-in URL|`/sign-in`|
|Sign-up URL|`/sign-up`|
|After sign-in|`/dashboard` (or `/orgs` — I'll align routes when building)|
|After sign-up|`/dashboard`|

Also add Allowed redirect URLs for local dev:

http://localhost:3000/*

---

## Phase 2: Organizations (multi-tenant core)

### 4. Enable Organizations

Dashboard: [Organizations settings](https://dashboard.clerk.com/last-active?path=organizations-settings)

|Setting|Recommended for you|
|---|---|
|Enable Organizations|On|
|Membership mode|Membership required (pure B2B — users must belong to an org)|
|Who can create orgs|All members (or restrict to admins if you prefer)|
|Max memberships per org|Leave default for now; billing seat caps will override per plan|

CLI alternative:

clerk enable orgs

### 5. Configure default roles

Dashboard: [Roles & Permissions](https://dashboard.clerk.com/last-active?path=organizations-settings/roles)

Clerk creates these automatically:

|Role|Default access|
|---|---|
|`org:admin`|Full org control (members, profile, billing)|
|`org:member`|Read members + read billing only|

Verify Creator role has at minimum:

- `org:sys_memberships:manage`
- `org:sys_memberships:read`
- `org:sys_profile:delete`

### 6. Create custom permissions (for messaging app)

Dashboard → Roles & Permissions → Permissions tab → Add permission

Create these (naming must follow `org:<resource>:<action>`):

|Permission key|Purpose|Assign to|
|---|---|---|
|`org:channels:create`|Create channels|`org:admin`|
|`org:channels:delete`|Delete channels|`org:admin`|
|`org:channels:manage`|Archive/rename channels (optional)|`org:admin`|

You can add more later (`org:messages:delete_any` for moderators, etc.).

Optional custom role (Phase 2):

|Role|Permissions|
|---|---|
|`org:moderator`|`org:channels:manage`, custom delete-any-message permission|

---

## Phase 3: Billing (free + paid plans)

### 7. Enable Billing

Dashboard: [Billing → Settings](https://dashboard.clerk.com/last-active?path=billing/settings)

- Turn Billing on
- Dev instances can use Clerk's shared dev gateway (no Stripe account needed yet)
- Production will require connecting Stripe later

CLI alternative:

clerk enable billing --for org

This auto-creates default `free_org` plan.

### 8. Create Organization Plans (not User Plans)

Dashboard: [Billing → Plans](https://dashboard.clerk.com/last-active?path=billing/plans) → Organization Plans tab

Create two plans:

|Plan slug|Name|Price|Seat limit|
|---|---|---|---|
|`org:free`|Free|$0|10 members|
|`org:pro`|Pro|Your price (e.g. $12/mo)|50 members (or unlimited)|

Important:

- Plans must be under Organization Plans, not User Plans
- Seat limit is set at plan creation and cannot be changed later — pick carefully
- Plan slug cannot be moved between tabs after creation

### 9. Create Features and attach to plans

For each plan → Features section → add features:

Suggested feature slugs:

|Feature slug|Free plan|Pro plan|
|---|---|---|
|`channels`|✅ (basic)|✅|
|`threads`|❌|✅|
|`files`|❌|✅|
|`search`|❌|✅|
|`sso`|❌|✅ (later)|
|`audit_log`|❌|✅ (later)|

### 10. Link permissions to features (billing gates RBAC)

When Billing is enabled, a custom permission only works if its feature slug is on the org's active plan.

Example: permission `org:channels:create` → requires feature `channels` on the plan.

Attach features to permissions in Dashboard when prompted, or name permissions so the feature segment matches (e.g. `org:threads:use` → feature `threads`).

---

## Phase 4: Convex integration

### 11. Activate Clerk ↔ Convex integration

Dashboard: [Clerk Convex setup](https://dashboard.clerk.com/apps/setup/convex)

- Click Activate Convex integration
- Copy the Frontend API URL (looks like `https://your-app.clerk.accounts.dev`)

Add to `.env.local`:

CLERK_JWT_ISSUER_DOMAIN=https://your-app.clerk.accounts.dev

(This is the same value Clerk docs sometimes call `CLERK_FRONTEND_API_URL`.)

You'll also need Convex env vars (I will wire these when building):

NEXT_PUBLIC_CONVEX_URL=https://....convex.cloud

CONVEX_DEPLOYMENT=dev:.... # set by npx convex dev

### 12. Configure JWT template for Convex

Dashboard → Configure → JWT Templates → create or edit the Convex template

The Convex integration usually pre-creates this. Ensure the template:

- Is named `convex` (Convex expects this name)
- Includes claims Convex needs for org scoping

Recommended custom claims (add to the Convex JWT template):

{

"org_id": "{{org.id}}",

"org_slug": "{{org.slug}}",

"org_role": "{{org.role}}"

}

This lets Convex mutations verify org context without extra Clerk API calls.

After any JWT template change: sign out and sign back in before testing.

---

## Phase 5: Webhooks (sync orgs/users to Convex)

### 13. Create a webhook endpoint

Dashboard: [Webhooks](https://dashboard.clerk.com/last-active?path=webhooks) → Add Endpoint

For local dev, use a tunnel (ngrok, Cloudflare Tunnel, etc.):

https://your-tunnel.ngrok.io/api/webhooks/clerk

For production:

https://yourdomain.com/api/webhooks/clerk

(I will create this route when building.)

### 14. Subscribe to these events

Organizations & membership:

- `organization.created`
- `organization.updated`
- `organization.deleted`
- `organizationMembership.created`
- `organizationMembership.updated`
- `organizationMembership.deleted`
- `organizationInvitation.created`
- `organizationInvitation.accepted`
- `organizationInvitation.revoked`

Users:

- `user.created`
- `user.updated`
- `user.deleted`

Billing (optional but recommended for Convex plan sync):

- `subscription.created`
- `subscription.updated`
- `subscription.active`
- `subscriptionItem.canceled`
- `subscriptionItem.active`

### 15. Copy webhook signing secret

Add to `.env.local`:

CLERK_WEBHOOK_SIGNING_SECRET=whsec_...

---

## Phase 6: Sign-in experience (B2B UX)

### 16. Configure session task for org selection

With Membership required, users without an org hit a `choose-organization` task after sign-in.

You can use Clerk's built-in flow inside `<SignIn />`, or a dedicated page with `<TaskChooseOrganization />` (I'll add this when building).

No Dashboard config required — it's automatic when Membership required is on.

### 17. Decide on built-in vs custom UI

Clerk provides prebuilt components you'll likely use:

|Component|Purpose|
|---|---|
|`<OrganizationSwitcher />`|Switch/create orgs|
|`<OrganizationProfile />`|Members, invites, billing, roles|
|`<UserButton />`|Profile + sign out|
|`<PricingTable for="organization" />`|Upgrade flow|
|`<Show when={{ permission }}>`|RBAC in UI|

Dashboard → Customization → Appearance (optional): logo, colors, branding.

---

## Phase 7: Verify before triggering build

### 18. Quick sanity checks

Run through this checklist and confirm each item:

-  `.env.local` has `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`
-  `.env.local` has `CLERK_SECRET_KEY`
-  `.env.local` has `CLERK_JWT_ISSUER_DOMAIN` (Frontend API URL)
-  `.env.local` has `CLERK_WEBHOOK_SIGNING_SECRET` (if webhooks ready)
-  Organizations enabled, Membership required
-  Custom permissions created (`org:channels:create`, etc.)
-  Billing enabled
-  Two Organization Plans: `org:free` and `org:pro` with seat limits
-  Features attached to plans
-  Convex integration activated
-  Convex JWT template exists and includes org claims
-  Redirect URLs include `http://localhost:3000/*`

### 19. Optional: run Convex dev

If you haven't already:

npx convex dev

This creates your Convex deployment and writes `NEXT_PUBLIC_CONVEX_URL` to `.env.local`. I need this before wiring `ConvexProviderWithClerk`.

---

## What I will build after you approve

Once you confirm Clerk setup is done, I will handle all code — you won't need to touch Dashboard again unless you want to tweak plans/permissions.

|Area|What I'll implement|
|---|---|
|Next.js|`ClerkProvider`, middleware, sign-in/sign-up routes, org-scoped layout|
|Convex|`auth.config.ts`, schema, org sync, channels, messages|
|Providers|`ConvexProviderWithClerk`|
|Webhooks|`/api/webhooks/clerk` handler|
|RBAC|`<Show>` + Convex auth checks using JWT org claims|
|Billing UI|`<PricingTable for="organization" />` + feature gates|
|Workspace|Channel list, messaging, admin channel management|

---

## What I need from you when you're ready

Reply with something like "Clerk setup is done, build it" and optionally confirm:

1. Plan slugs you used (`org:free` / `org:pro` or different names)
2. Seat limits you set (10 free / 50 pro?)
3. Webhook tunnel — are you using ngrok locally, or skip webhooks for first pass?
4. Convex — have you run `npx convex dev` and have a deployment URL?