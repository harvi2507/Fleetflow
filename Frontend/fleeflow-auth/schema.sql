-- ════════════════════════════════════════════
--  FleetFlow — Users Table
--  Run in: Supabase Dashboard → SQL Editor
-- ════════════════════════════════════════════

CREATE TABLE users (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name   TEXT NOT NULL,
  email       TEXT UNIQUE NOT NULL,
  phone       TEXT,
  username    TEXT UNIQUE NOT NULL,
  password    TEXT NOT NULL,                          -- bcrypt hashed
  role        TEXT CHECK (role IN ('manager', 'dispatcher')),  -- assigned by manager
  is_active   BOOLEAN DEFAULT FALSE,                 -- manager must activate account
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- ════════════════════════════════════════════
--  Seed: Create the first manager account
--  Password below is bcrypt hash of: "admin123"
--  Change this immediately after first login!
-- ════════════════════════════════════════════

INSERT INTO users (full_name, email, phone, username, password, role, is_active)
VALUES (
  'Fleet Manager',
  'manager@fleetflow.io',
  '9999999999',
  'admin',
  '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',  -- password: "admin123"
  'manager',
  TRUE
);
