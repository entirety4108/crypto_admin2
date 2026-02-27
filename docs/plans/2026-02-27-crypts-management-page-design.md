# Crypts Management Page Design

**Date**: 2026-02-27
**Status**: Approved

## Overview

A new dashboard page for managing the `crypts` master table (cryptocurrency master records).
Allows listing, adding, editing, and toggling active/inactive status of cryptocurrencies.

## Requirements

- **Table**: `crypts` (shared master table, RLS: read by all, write by service_role only)
- **Features**: List + Add + Edit + is_active toggle (no hard delete)
- **UI Pattern**: Same collapsible card design as accounts/categories pages

## Architecture

```
src/app/[locale]/(dashboard)/crypts/
├── page.tsx        # Server Component (list display)
└── actions.ts      # Server Actions (CRUD with service_role client)
```

Also: update `src/components/dashboard-nav.tsx` to add "Crypts" nav item.

## Data / Permissions

Since `crypts` only allows writes via `service_role`, the Server Actions will use:

```ts
import { createClient as createSupabaseClient } from '@supabase/supabase-js'

const supabase = createSupabaseClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
)
```

Note: Server Actions run only on the server side, so using service_role key is safe here.

## Form Fields

| Field | Required | Description |
|-------|----------|-------------|
| `symbol` | ✓ | Ticker symbol (e.g., BTC, ETH) - unique |
| `project_name` | - | Full project name (e.g., Bitcoin) |
| `coingecko_id` | - | CoinGecko ID (used by price update batch) |
| `icon_url` | - | Icon image URL |
| `color` | - | Color code (color picker, default #6366f1) |

## UI Design

- Page header: "Crypts" title with description
- Collapsible "Add New Crypt" form at top
- List of crypt cards (collapsible), each showing:
  - Color swatch + symbol + project_name
  - Active/inactive badge
  - Edit form inside (symbol, project_name, coingecko_id, icon_url, color, is_active checkbox)
  - Update button
- Inactive crypts (is_active = false) displayed with greyed-out styling
- Navigation: Add "Crypts" item to DashboardNav

## Server Actions

1. `createCryptAction(formData)` — INSERT into crypts using service_role client
2. `updateCryptAction(formData)` — UPDATE crypts by id using service_role client

## Security Considerations

- `SUPABASE_SERVICE_ROLE_KEY` is server-side only (no `NEXT_PUBLIC_` prefix)
- Actions are Server Actions (server-only), never exposed to client
- No hard delete to preserve referential integrity with purchases/sells/etc.
