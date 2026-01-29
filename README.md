# SpiderFoot CI - Automated Competitive Intelligence

Zero-cost OSINT platform for automated competitor tech stack detection and hidden endpoint discovery.

## 🚀 Quick Deploy

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/breverdbidder/spiderfoot-ci)

## ✅ Deployment Status

| Component | Status |
|-----------|--------|
| GitHub Repository | ✅ Created |
| GitHub Secrets | ✅ Configured |
| Supabase Connection | ✅ REST API Working |
| **Supabase Table** | ⚠️ **Requires 1 Manual Step** |
| Weekly Scan Workflow | ✅ Ready |

## ⚠️ ONE-TIME SETUP (Required)

Run this SQL in Supabase Dashboard:

1. Go to: https://supabase.com/dashboard/project/mocerqjnksmhcjzxrewo/sql
2. Paste and run:

```sql
CREATE TABLE IF NOT EXISTS competitor_intelligence (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    competitor_name TEXT NOT NULL,
    domain TEXT NOT NULL,
    category TEXT NOT NULL,
    scan_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    scan_type TEXT NOT NULL DEFAULT 'passive',
    technologies JSONB DEFAULT '[]'::jsonb,
    subdomains JSONB DEFAULT '[]'::jsonb,
    emails JSONB DEFAULT '[]'::jsonb,
    ip_addresses JSONB DEFAULT '[]'::jsonb,
    open_ports JSONB DEFAULT '[]'::jsonb,
    ssl_info JSONB DEFAULT '{}'::jsonb,
    social_profiles JSONB DEFAULT '[]'::jsonb,
    vulnerabilities JSONB DEFAULT '[]'::jsonb,
    api_endpoints JSONB DEFAULT '[]'::jsonb,
    raw_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ci_competitor ON competitor_intelligence(competitor_name);
CREATE INDEX IF NOT EXISTS idx_ci_domain ON competitor_intelligence(domain);
```

3. Done! Workflow will now automatically store results.

---

## 💰 Cost Breakdown

| Component | Cost |
|-----------|------|
| SpiderFoot OSS | $0 (MIT License) |
| Render.com Hosting | $0 (Free tier) |
| GitHub Actions | $0 (2000 min/mo free) |
| Supabase Storage | $0 (Free tier) |
| **Total** | **$0/month** |

## 🔑 Free API Keys (Optional but Recommended)

Register for free tiers at:

| Service | Free Tier | Sign Up |
|---------|-----------|---------|
| Shodan | 100 queries/mo | https://shodan.io |
| Censys | 250 queries/mo | https://censys.io |
| VirusTotal | 500 queries/day | https://virustotal.com |
| Hunter.io | 25 searches/mo | https://hunter.io |
| SecurityTrails | 50 queries/mo | https://securitytrails.com |

## 📁 Repository Structure

```
spiderfoot-ci/
├── .github/
│   └── workflows/
│       ├── competitor-scan.yml    # Weekly automated scanning
│       └── setup-schema.yml       # One-time DB setup
├── supabase/
│   └── migrations/
│       └── 001_competitor_intelligence.sql
├── Dockerfile                      # Render.com deployment
├── entrypoint.sh                  # Config & auth setup
├── render.yaml                    # Render blueprint
└── README.md
```

## ⚙️ GitHub Secrets (Already Configured)

- ✅ `SUPABASE_URL`
- ✅ `SUPABASE_SERVICE_KEY`
- ✅ `SUPABASE_DB_PASSWORD`

### Add Optional API Keys
Go to: https://github.com/breverdbidder/spiderfoot-ci/settings/secrets/actions

- `SHODAN_API_KEY`
- `CENSYS_API_ID` / `CENSYS_API_SECRET`
- `VIRUSTOTAL_API_KEY`
- `HUNTER_API_KEY`
- `SECURITYTRAILS_API_KEY`

## 🎯 What It Scans

Weekly automated scans target:

| Competitor | Domain | Category |
|------------|--------|----------|
| GreenLite | greenlite.ai | permit-management |
| PropertyOnion | propertyonion.com | foreclosure |
| USForeclosure | usforeclosure.com | foreclosure |
| Auction.com | auction.com | foreclosure |

### Data Collected

- **Technologies**: CMS, frameworks, analytics, CDNs
- **Subdomains**: All discovered subdomains
- **API Endpoints**: Hidden routes and APIs
- **Open Ports**: Non-standard HTTP ports
- **SSL Info**: Certificate details
- **Email Addresses**: Corporate contacts
- **Social Profiles**: Company social media

## 📊 Supabase Queries

### Latest Intel Per Competitor
```sql
SELECT * FROM competitor_intelligence 
ORDER BY scan_date DESC LIMIT 10;
```

### Find Competitors Using Specific Tech
```sql
SELECT competitor_name, domain 
FROM competitor_intelligence 
WHERE technologies @> '["React"]'::jsonb;
```

## 🔄 Manual Trigger

Run a scan manually:

```bash
gh workflow run competitor-scan.yml \
  --field target=newcompetitor.com \
  --field scan_type=passive
```

Or via GitHub UI: `Actions > Competitor Intelligence Scan > Run workflow`

## 🔧 Adding New Competitors

Edit `.github/workflows/competitor-scan.yml`:

```yaml
matrix:
  competitor:
    - domain: newcompetitor.com
      name: NewCompetitor
      category: your-category
```

## 🔒 Security Notes

- All API keys stored in GitHub Secrets (encrypted)
- Supabase RLS enabled
- Passive scanning by default (non-intrusive)
- No credentials stored in code

## 📝 License

MIT License - Same as SpiderFoot

---

**Part of the Everest Capital USA Agentic AI Ecosystem**
