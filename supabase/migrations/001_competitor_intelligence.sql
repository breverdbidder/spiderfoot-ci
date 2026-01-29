-- Competitor Intelligence Table for SpiderFoot CI
-- Stores automated OSINT scan results from weekly scans

CREATE TABLE IF NOT EXISTS competitor_intelligence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    competitor_name TEXT NOT NULL,
    domain TEXT NOT NULL,
    category TEXT NOT NULL,
    scan_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    scan_type TEXT NOT NULL DEFAULT 'passive',
    
    -- Discovered data
    technologies JSONB DEFAULT '[]'::jsonb,
    subdomains JSONB DEFAULT '[]'::jsonb,
    emails JSONB DEFAULT '[]'::jsonb,
    ip_addresses JSONB DEFAULT '[]'::jsonb,
    open_ports JSONB DEFAULT '[]'::jsonb,
    ssl_info JSONB DEFAULT '{}'::jsonb,
    social_profiles JSONB DEFAULT '[]'::jsonb,
    vulnerabilities JSONB DEFAULT '[]'::jsonb,
    api_endpoints JSONB DEFAULT '[]'::jsonb,
    
    -- Metadata
    raw_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Indexes for common queries
    CONSTRAINT unique_scan UNIQUE (competitor_name, scan_date)
);

-- Index for fast lookups by competitor
CREATE INDEX IF NOT EXISTS idx_ci_competitor ON competitor_intelligence(competitor_name);
CREATE INDEX IF NOT EXISTS idx_ci_domain ON competitor_intelligence(domain);
CREATE INDEX IF NOT EXISTS idx_ci_scan_date ON competitor_intelligence(scan_date DESC);
CREATE INDEX IF NOT EXISTS idx_ci_category ON competitor_intelligence(category);

-- GIN indexes for JSONB array searches
CREATE INDEX IF NOT EXISTS idx_ci_technologies ON competitor_intelligence USING GIN (technologies);
CREATE INDEX IF NOT EXISTS idx_ci_subdomains ON competitor_intelligence USING GIN (subdomains);

-- View for latest scan per competitor
CREATE OR REPLACE VIEW latest_competitor_intel AS
SELECT DISTINCT ON (competitor_name)
    *
FROM competitor_intelligence
ORDER BY competitor_name, scan_date DESC;

-- View for technology trends
CREATE OR REPLACE VIEW competitor_tech_trends AS
SELECT 
    competitor_name,
    domain,
    scan_date,
    jsonb_array_length(technologies) as tech_count,
    jsonb_array_length(subdomains) as subdomain_count,
    jsonb_array_length(api_endpoints) as endpoint_count
FROM competitor_intelligence
ORDER BY scan_date DESC;

-- Function to compare latest vs previous scan
CREATE OR REPLACE FUNCTION get_competitor_changes(p_competitor TEXT)
RETURNS TABLE (
    field_name TEXT,
    added JSONB,
    removed JSONB
) AS $$
DECLARE
    latest_scan RECORD;
    previous_scan RECORD;
BEGIN
    SELECT * INTO latest_scan
    FROM competitor_intelligence
    WHERE competitor_name = p_competitor
    ORDER BY scan_date DESC
    LIMIT 1;
    
    SELECT * INTO previous_scan
    FROM competitor_intelligence
    WHERE competitor_name = p_competitor
    ORDER BY scan_date DESC
    OFFSET 1
    LIMIT 1;
    
    IF previous_scan IS NULL THEN
        RETURN;
    END IF;
    
    -- Compare technologies
    RETURN QUERY SELECT 
        'technologies'::TEXT,
        (SELECT jsonb_agg(t) FROM jsonb_array_elements(latest_scan.technologies) t 
         WHERE NOT latest_scan.technologies @> previous_scan.technologies),
        (SELECT jsonb_agg(t) FROM jsonb_array_elements(previous_scan.technologies) t 
         WHERE NOT previous_scan.technologies @> latest_scan.technologies);
    
    -- Compare subdomains
    RETURN QUERY SELECT 
        'subdomains'::TEXT,
        (SELECT jsonb_agg(s) FROM jsonb_array_elements(latest_scan.subdomains) s 
         WHERE NOT latest_scan.subdomains @> previous_scan.subdomains),
        (SELECT jsonb_agg(s) FROM jsonb_array_elements(previous_scan.subdomains) s 
         WHERE NOT previous_scan.subdomains @> latest_scan.subdomains);
         
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- RLS Policies
ALTER TABLE competitor_intelligence ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow service role full access" ON competitor_intelligence
    FOR ALL
    USING (auth.role() = 'service_role');

CREATE POLICY "Allow authenticated read access" ON competitor_intelligence
    FOR SELECT
    USING (auth.role() = 'authenticated');

COMMENT ON TABLE competitor_intelligence IS 'Automated OSINT scan results from SpiderFoot CI weekly scans';
