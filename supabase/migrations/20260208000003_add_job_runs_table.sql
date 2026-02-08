-- Job Runs Table
-- Tracks execution of recurring jobs to prevent duplicate processing

CREATE TABLE job_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_name VARCHAR(100) NOT NULL, -- e.g., 'daily_price_update', 'calculate_balances'
  user_id UUID, -- NULL for system-wide jobs
  account_id UUID, -- NULL for user-level or system jobs
  run_date DATE NOT NULL, -- Date of the job run
  input_hash VARCHAR(64), -- Hash of input parameters to detect changes
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  status VARCHAR(20) NOT NULL DEFAULT 'running', -- 'running', 'completed', 'failed'
  error_message TEXT
);

-- Unique constraint to prevent duplicate job runs for same date
CREATE UNIQUE INDEX idx_job_runs_unique
  ON job_runs(job_name, COALESCE(user_id, '00000000-0000-0000-0000-000000000000'::UUID),
              COALESCE(account_id, '00000000-0000-0000-0000-000000000000'::UUID), run_date);

-- Index for querying job status
CREATE INDEX idx_job_runs_name_completed
  ON job_runs(job_name, completed_at);

-- Add comments
COMMENT ON TABLE job_runs IS 'Tracks execution of recurring jobs to prevent duplicate processing';
COMMENT ON COLUMN job_runs.job_name IS 'Identifier for the job type';
COMMENT ON COLUMN job_runs.input_hash IS 'Hash of input parameters to detect if rerun is needed';
COMMENT ON COLUMN job_runs.status IS 'Job status: running, completed, failed';
