-- 主要テーブルのRLS権限テスト（最小セット）
-- 実行例:
--   supabase test db --file supabase/tests/rls_policies.sql

begin;

create extension if not exists pgtap;
select plan(4);

select ok(
  exists(
    select 1 from pg_policies where schemaname = 'public' and tablename = 'accounts'
  ),
  'accounts has RLS policy'
);

select ok(
  exists(
    select 1 from pg_policies where schemaname = 'public' and tablename = 'purchases'
  ),
  'purchases has RLS policy'
);

select ok(
  exists(
    select 1 from pg_policies where schemaname = 'public' and tablename = 'sells'
  ),
  'sells has RLS policy'
);

select ok(
  exists(
    select 1 from pg_policies where schemaname = 'public' and tablename = 'transfers'
  ),
  'transfers has RLS policy'
);

select * from finish();
rollback;
