-- pg_cron拡張を有効化
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- http拡張を有効化（Edge Function呼び出しに必要）
CREATE EXTENSION IF NOT EXISTS http;

-- update-prices Edge Functionを1時間ごとに実行するCronジョブを作成
-- ジョブが既に存在する場合は削除してから作成
DO $$
BEGIN
  -- 既存のジョブを削除
  PERFORM cron.unschedule('update-prices-hourly');
EXCEPTION
  WHEN undefined_table THEN NULL;
  WHEN others THEN NULL;
END $$;

-- 1時間ごとに実行するCronジョブを作成
SELECT cron.schedule(
  'update-prices-hourly',           -- ジョブ名
  '0 * * * *',                       -- Cron式: 毎時0分に実行
  $$
  SELECT
    net.http_post(
      url := 'https://uiugjfeldwvlujphbios.supabase.co/functions/v1/update-prices',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || current_setting('app.settings.service_role_key', true)
      ),
      body := '{}'::jsonb
    ) AS request_id;
  $$
);

-- Cronジョブの確認
SELECT * FROM cron.job WHERE jobname = 'update-prices-hourly';

-- Cron実行履歴を確認するためのビュー（オプション）
COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';
