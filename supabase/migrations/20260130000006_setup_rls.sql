-- Row Level Security (RLS) Setup

-- =============================================
-- Master Tables (Read-only for all users)
-- =============================================

-- crypts: All users can read, only service_role can write
ALTER TABLE crypts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view crypts" ON crypts FOR SELECT USING (true);

-- prices: All users can read, only service_role can write
ALTER TABLE prices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view prices" ON prices FOR SELECT USING (true);

-- =============================================
-- User Tables
-- =============================================

-- accounts
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "accounts_select" ON accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "accounts_insert" ON accounts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "accounts_update" ON accounts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "accounts_delete" ON accounts FOR DELETE USING (auth.uid() = user_id);

-- addresses
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "addresses_select" ON addresses FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "addresses_insert" ON addresses FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "addresses_update" ON addresses FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "addresses_delete" ON addresses FOR DELETE USING (auth.uid() = user_id);

-- crypt_categories
ALTER TABLE crypt_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "crypt_categories_select" ON crypt_categories FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "crypt_categories_insert" ON crypt_categories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "crypt_categories_update" ON crypt_categories FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "crypt_categories_delete" ON crypt_categories FOR DELETE USING (auth.uid() = user_id);

-- user_crypt_categories
ALTER TABLE user_crypt_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_crypt_categories_select" ON user_crypt_categories FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "user_crypt_categories_insert" ON user_crypt_categories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "user_crypt_categories_delete" ON user_crypt_categories FOR DELETE USING (auth.uid() = user_id);

-- =============================================
-- Transaction Tables
-- =============================================

-- purchases
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "purchases_select" ON purchases FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "purchases_insert" ON purchases FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "purchases_update" ON purchases FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "purchases_delete" ON purchases FOR DELETE USING (auth.uid() = user_id);

-- sells
ALTER TABLE sells ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sells_select" ON sells FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "sells_insert" ON sells FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "sells_update" ON sells FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "sells_delete" ON sells FOR DELETE USING (auth.uid() = user_id);

-- transfers
ALTER TABLE transfers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "transfers_select" ON transfers FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "transfers_insert" ON transfers FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "transfers_update" ON transfers FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "transfers_delete" ON transfers FOR DELETE USING (auth.uid() = user_id);

-- airdrops
ALTER TABLE airdrops ENABLE ROW LEVEL SECURITY;
CREATE POLICY "airdrops_select" ON airdrops FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "airdrops_insert" ON airdrops FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "airdrops_update" ON airdrops FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "airdrops_delete" ON airdrops FOR DELETE USING (auth.uid() = user_id);

-- commissions
ALTER TABLE commissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "commissions_select" ON commissions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "commissions_insert" ON commissions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "commissions_update" ON commissions FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "commissions_delete" ON commissions FOR DELETE USING (auth.uid() = user_id);

-- =============================================
-- Cache/Aggregation Tables
-- =============================================

-- daily_balances
ALTER TABLE daily_balances ENABLE ROW LEVEL SECURITY;
CREATE POLICY "daily_balances_select" ON daily_balances FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "daily_balances_insert" ON daily_balances FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "daily_balances_update" ON daily_balances FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "daily_balances_delete" ON daily_balances FOR DELETE USING (auth.uid() = user_id);

-- dm_crypts
ALTER TABLE dm_crypts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "dm_crypts_select" ON dm_crypts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "dm_crypts_insert" ON dm_crypts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "dm_crypts_update" ON dm_crypts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "dm_crypts_delete" ON dm_crypts FOR DELETE USING (auth.uid() = user_id);

-- dm_accounts
ALTER TABLE dm_accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "dm_accounts_select" ON dm_accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "dm_accounts_insert" ON dm_accounts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "dm_accounts_update" ON dm_accounts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "dm_accounts_delete" ON dm_accounts FOR DELETE USING (auth.uid() = user_id);

-- =============================================
-- Integration Tables
-- =============================================

-- price_alerts
ALTER TABLE price_alerts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "price_alerts_select" ON price_alerts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "price_alerts_insert" ON price_alerts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "price_alerts_update" ON price_alerts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "price_alerts_delete" ON price_alerts FOR DELETE USING (auth.uid() = user_id);

-- zaim_credentials
ALTER TABLE zaim_credentials ENABLE ROW LEVEL SECURITY;
CREATE POLICY "zaim_credentials_select" ON zaim_credentials FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "zaim_credentials_insert" ON zaim_credentials FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "zaim_credentials_update" ON zaim_credentials FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "zaim_credentials_delete" ON zaim_credentials FOR DELETE USING (auth.uid() = user_id);

-- zaim_accounts
ALTER TABLE zaim_accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "zaim_accounts_select" ON zaim_accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "zaim_accounts_insert" ON zaim_accounts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "zaim_accounts_update" ON zaim_accounts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "zaim_accounts_delete" ON zaim_accounts FOR DELETE USING (auth.uid() = user_id);
