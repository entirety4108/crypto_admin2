-- Row Level Security (RLS) Setup for Phase 2.5 New Tables

-- =============================================
-- Cost Basis Tracking Table
-- =============================================

-- cost_basis_history: Track cost basis changes for tax calculations
ALTER TABLE cost_basis_history ENABLE ROW LEVEL SECURITY;

-- Allow users to read only their own cost basis history
CREATE POLICY "cost_basis_history_select" ON cost_basis_history
  FOR SELECT USING (auth.uid() = user_id);

-- Allow users to insert only their own cost basis history
CREATE POLICY "cost_basis_history_insert" ON cost_basis_history
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Allow users to update only their own cost basis history
CREATE POLICY "cost_basis_history_update" ON cost_basis_history
  FOR UPDATE USING (auth.uid() = user_id);

-- Allow users to delete only their own cost basis history
CREATE POLICY "cost_basis_history_delete" ON cost_basis_history
  FOR DELETE USING (auth.uid() = user_id);

-- =============================================
-- Swap Transaction Table
-- =============================================

-- swaps: Track crypto-to-crypto swap transactions
ALTER TABLE swaps ENABLE ROW LEVEL SECURITY;

-- Allow users to read only their own swaps
CREATE POLICY "swaps_select" ON swaps
  FOR SELECT USING (auth.uid() = user_id);

-- Allow users to insert only their own swaps
CREATE POLICY "swaps_insert" ON swaps
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Allow users to update only their own swaps
CREATE POLICY "swaps_update" ON swaps
  FOR UPDATE USING (auth.uid() = user_id);

-- Allow users to delete only their own swaps
CREATE POLICY "swaps_delete" ON swaps
  FOR DELETE USING (auth.uid() = user_id);

-- =============================================
-- Job Execution Tracking Table
-- =============================================

-- job_runs: Track scheduled job execution history
ALTER TABLE job_runs ENABLE ROW LEVEL SECURITY;

-- Allow users to read only their own job runs
CREATE POLICY "job_runs_select" ON job_runs
  FOR SELECT USING (auth.uid() = user_id);

-- Allow users to insert only their own job runs
CREATE POLICY "job_runs_insert" ON job_runs
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Allow users to update only their own job runs
CREATE POLICY "job_runs_update" ON job_runs
  FOR UPDATE USING (auth.uid() = user_id);

-- Allow users to delete only their own job runs
CREATE POLICY "job_runs_delete" ON job_runs
  FOR DELETE USING (auth.uid() = user_id);
