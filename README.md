# SpiderFoot CI - Automated Competitive Intelligence

Zero-cost OSINT platform for automated competitor tech stack detection and hidden endpoint discovery.

## 🚀 Quick Deploy

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/breverdbidder/spiderfoot-ci)

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
│       └── competitor-scan.yml    # Weekly automated scanning
├── supabase/
│   └── migrations/
│       └── 001_competitor_intelligence.sql
├── Dockerfile                      # Render.com deployment
├── entrypoint.sh                  # Config & auth setup
├── render.yaml                    # Render blueprint
└── README.md
```

## ⚙️ GitHub Secrets Required

Add these to your repository secrets (`Settings > Secrets > Actions`):

### Required
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_SERVICE_KEY` - Supabase service role key

### Optional (Free Tier API Keys)
- `SHODAN_API_KEY`
- `CENSYS_API_ID`
- `CENSYS_API_SECRET`
- `VIRUSTOTAL_API_KEY`
- `HUNTER_API_KEY`
- `SECURITYTRAILS_API_KEY`

## 🎯 What It Scans

The automated weekly scan targets these competitors:

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
SELECT * FROM latest_competitor_intel;
```

### Technology Trends Over Time
```sql
SELECT * FROM competitor_tech_trends 
WHERE competitor_name = 'GreenLite'
ORDER BY scan_date DESC
LIMIT 10;
```

### What Changed Since Last Scan
```sql
SELECT * FROM get_competitor_changes('GreenLite');
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

## 🛡️ Scan Types

| Type | Description | Duration |
|------|-------------|----------|
| `passive` | No direct probing, OSINT only | ~10 min |
| `active` | Port scanning, brute force | ~30 min |
| `full` | All 200+ modules | ~2 hours |

## 🔧 Adding New Competitors

Edit `.github/workflows/competitor-scan.yml`:

```yaml
matrix:
  competitor:
    - domain: newcompetitor.com
      name: NewCompetitor
      category: your-category
```

## 📈 Integration with BidDeed.AI

Results are stored in Supabase and can be queried by:
- ZoneWise CI dashboard
- BidDeed.AI analysis pipeline
- Weekly summary reports

## 🔒 Security Notes

- All API keys stored in GitHub Secrets (encrypted)
- Supabase RLS enabled
- Passive scanning by default (non-intrusive)
- No credentials stored in code

## 📝 License

MIT License - Same as SpiderFoot

---

**Part of the Everest Capital USA Agentic AI Ecosystem**
