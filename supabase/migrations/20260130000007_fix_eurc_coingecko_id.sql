-- EURCのCoinGecko IDを修正
-- 'eurc' → 'euro-coin' に変更

UPDATE crypts
SET coingecko_id = 'euro-coin'
WHERE symbol = 'EURC' AND coingecko_id = 'eurc';
