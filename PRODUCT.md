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

A portfolio that closes the experience gap for a new MSF graduate by showing finished analyst work rather than coursework. Every project here is something Tom built from scratch: a full Budget vs. Actual variance model, a three-statement model with DCF built from TXN filings, and Power BI dashboards. Together they demonstrate FP&A readiness before holding the title.

## Positioning

An evidence-first FP&A portfolio combining public-company filings, clearly labeled operating simulations, and public datasets. Each project shows the model, the assumptions behind it, the analysis, and decision-ready commentary, not just the spreadsheet output.

## Operating Context

Visitors arrive from job applications (resume attachment), LinkedIn cold outreach, or direct referral. The primary action is **Download Resume + contact** (email or LinkedIn). Most visitors are on desktop; mobile is secondary but must not break.

## Capabilities and Constraints

- Static site: no CMS, no database, no server-side logic
- All projects are Excel/Power BI artifacts embedded via Google Sheets iframe or download links
- Google Analytics GA4 tracking active (G-GY1DFJFTY4)
- No CMS — new articles and projects require manual HTML edits

## Brand Commitments

- **Colors:** `--green: #1F3864` (navy, the variable name is historical), `--amber: #B6822A`, `--brick: #9C4632`, `--paper: #F4F6F9`, `--ink: #111827`. `style.css` `:root` is the source of truth.
- **Type:** IBM Plex Mono (nav, labels, monospace UI), IBM Plex Sans (body), Inter (headings)
- **Tone:** Direct, confident, evidence-first. No hedging language. No generic MBA-speak.
- **Anti-references:** Generic SaaS purple-gradient portfolios; Bootstrap-default card layouts; stock photo hero imagery

## Evidence on Hand

- NorthBeam Analytics BvA model (Excel, embedded via Google Sheets). NorthBeam is a fictional B2B SaaS company, disclosed as such on the site.
- TXN 3-Statement model and DCF (Excel, downloadable). Built from Texas Instruments public filings.
- Retail Financial Performance Analytics (Power BI). Uses the public Sample Superstore dataset.
- 5 published articles (article-1.html through article-5.html)

## Product Principles

1. **Show the work, not the résumé.** Every claim on the site must be backed by a visible artifact.
2. **Finance-team legibility first.** Design decisions serve a skeptical, time-pressed hiring manager, not a design reviewer.
3. **Credibility over cleverness.** Visual restraint signals professional judgment; animation and decoration must earn their place.
4. **Transparent data provenance.** Public filings, simulated operating cases, and public sample datasets are each labeled for what they are, and never presented as something they are not.
5. **One clear next action.** Every page end leads toward Download Resume or Contact.

## Accessibility & Inclusion

WCAG AA contrast compliance required. `prefers-reduced-motion` respected globally in style.css.
