# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack

Static HTML/CSS, no framework or build tool. Deployed on Netlify via GitHub continuous deployment. Domain: jintangshen.com.

## Users

**Primary:** Recruiters and hiring managers in finance — either a corporate FP&A recruiter screening candidates or the finance team lead who receives the forwarded link. They spend 30–90 seconds on first scan; they are looking for evidence of real work, not just listed credentials.

**Secondary:** Cold-outreach targets — finance directors or CFOs who receive a direct message with the portfolio link attached.

## Product Purpose

A portfolio that closes the experience gap for a new MSF graduate by showing finished, real-company-data work rather than coursework. Every project here is something Tom built from scratch — a full Budget vs. Actual variance model, a three-statement model from TXN filings, and Power BI dashboards — to demonstrate FP&A readiness before holding a title.

## Positioning

The only FP&A candidate portfolio built on real company data rather than synthetic case data, with case studies that show the commentary and insight layer — not just the spreadsheet output.

## Operating Context

Visitors arrive from job applications (resume attachment), LinkedIn cold outreach, or direct referral. The primary action is **Download Resume + contact** (email or LinkedIn). Most visitors are on desktop; mobile is secondary but must not break.

## Capabilities and Constraints

- Static site: no CMS, no database, no server-side logic
- All projects are Excel/Power BI artifacts embedded via Google Sheets iframe or download links
- Google Analytics GA4 tracking active (G-GY1DFJFTY4)
- No CMS — new articles and projects require manual HTML edits

## Brand Commitments

- **Colors:** Corporate Trust palette — `--green: #1F4D3A`, `--amber: #B6822A`, `--paper: #F8FAFC`, `--ink: #0F172A`
- **Type:** IBM Plex Mono (nav, labels, monospace UI), IBM Plex Sans (body), Inter (headings)
- **Tone:** Direct, confident, evidence-first. No hedging language. No generic MBA-speak.
- **Anti-references:** Generic SaaS purple-gradient portfolios; Bootstrap-default card layouts; stock photo hero imagery

## Evidence on Hand

- NorthBeam Analytics BvA model (Excel, embedded via Google Sheets)
- TXN 3-Statement DCF model (Excel, downloadable)
- 2 published articles (article-1.html, article-2.html)
- 3 coming-soon project slots (placeholders)

## Product Principles

1. **Show the work, not the résumé.** Every claim on the site must be backed by a visible artifact.
2. **Finance-team legibility first.** Design decisions serve a skeptical, time-pressed hiring manager, not a design reviewer.
3. **Credibility over cleverness.** Visual restraint signals professional judgment; animation and decoration must earn their place.
4. **Real data only.** No synthetic or fabricated numbers in any project or example.
5. **One clear next action.** Every page end leads toward Download Resume or Contact.

## Accessibility & Inclusion

WCAG AA contrast compliance required. `prefers-reduced-motion` respected globally in style.css.
