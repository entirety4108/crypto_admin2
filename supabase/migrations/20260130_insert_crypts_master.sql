-- 暗号通貨マスタデータの初期登録
-- CoinGecko API と連携するため coingecko_id を設定

INSERT INTO crypts (symbol, project_name, coingecko_id, icon_url, color, is_active) VALUES
  ('BTC', 'Bitcoin', 'bitcoin', 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png', '#F7931A', true),
  ('BNB', 'BNB', 'binancecoin', 'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png', '#F3BA2F', true),
  ('ETH', 'Ethereum', 'ethereum', 'https://assets.coingecko.com/coins/images/279/large/ethereum.png', '#627EEA', true),
  ('SOL', 'Solana', 'solana', 'https://assets.coingecko.com/coins/images/4128/large/solana.png', '#14F195', true),
  ('10SET', 'Tenset', 'tenset', 'https://assets.coingecko.com/coins/images/13974/large/tenset.png', '#FF6B00', true),
  ('USDT', 'Tether', 'tether', 'https://assets.coingecko.com/coins/images/325/large/Tether.png', '#26A17B', true),
  ('USDC', 'USD Coin', 'usd-coin', 'https://assets.coingecko.com/coins/images/6319/large/USD_Coin_icon.png', '#2775CA', true),
  ('DAI', 'Dai', 'dai', 'https://assets.coingecko.com/coins/images/9956/large/Badge_Dai.png', '#F4B731', true),
  ('SUI', 'Sui', 'sui', 'https://assets.coingecko.com/coins/images/26375/large/sui_asset.jpeg', '#6FBCF0', true),
  ('CETUS', 'Cetus Protocol', 'cetus-protocol', 'https://assets.coingecko.com/coins/images/31545/large/cetus.png', '#00D4AA', true),
  ('HYPE', 'Hyperliquid', 'hyperliquid', 'https://assets.coingecko.com/coins/images/42539/large/hype.png', '#2D2D2D', true),
  ('EURC', 'Euro Coin', 'euro-coin', 'https://assets.coingecko.com/coins/images/26045/large/euro-coin.png', '#003399', true)
ON CONFLICT (symbol) DO NOTHING;
