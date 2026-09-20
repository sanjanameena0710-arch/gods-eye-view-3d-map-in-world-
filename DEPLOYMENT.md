# 🚀 Deploying God's Eye View

> **TL;DR (daily phone use):** Deploy free on Render → open the URL on your
> phone → browser menu → **"Add to Home screen"** → full-screen daily map app.

---

## Why not GitHub Pages / Netlify / Vercel (static)?

This app is **not a static site**. Its data relays — flights (ADS-B), ships
(AIS), earthquakes, wildfires, CCTV, radio, voice proxies — are **Vite
dev-server middleware** defined in `vite.config.js`. A static export gives you
an empty globe with no live data. You need a **Node server** (this repo ships
a Dockerfile that runs exactly that).

---

## Option A — Render (free, easiest for 24/7 personal use)

1. Push this repo to **your** GitHub account.
2. Go to [render.com](https://render.com) → sign in with GitHub →
   **New + → Blueprint** → select the repo → **Apply** (uses `render.yaml`).
3. Wait ~5 min for the first build. Done — you get a `https://<name>.onrender.com` URL.

**Free-plan notes:**
- Sleeps after ~15 min idle; first visit after that takes ~1 min to wake.
- 512 MB RAM — fine for one or two simultaneous viewers.

**Add API keys later** (optional): Render dashboard → your service →
**Environment** → add `GOOGLE_MAPS_API_KEY` / `CESIUM_ION_TOKEN` /
`OPENAI_API_KEY` → save (auto redeploys). Keyless mode works on Esri imagery.

### Phone pe daily use
1. Chrome mein Render URL kholo.
2. Menu (⋮) → **"Add to Home screen"**.
3. Ab home screen icon se full-screen map app ki tarah khulega. 📱

---

## Option B — Any VPS with Docker (Hetzner / DigitalOcean / Oracle free tier)

```bash
git clone https://github.com/<you>/gods-eye-view.git && cd gods-eye-view
docker compose up -d --build
```

- App: `http://<server-ip>:4173`
- 24/7 chalta rahega (`restart: unless-stopped`).
- HTTPS/domain ke liye nginx + certbot lagao.

---

## Option C — Tunnel from your own PC (free, PC-on-only)

```bash
npm install
HOST=0.0.0.0 npm run dev      # terminal 1
cloudflared tunnel --url http://localhost:4173   # terminal 2 (or: ngrok http 4173)
```

You get a temporary public HTTPS URL. Good for demos, not for 24/7.

---

## ⚠️ Security (SECURITY.md summary)

God's Eye View is a **local-first explorer, not a hardened production
service**. Anyone who can reach the server can **spend your API quotas**
(OpenAI / Google / OpenSky / AISStream). So:

- **Public URL:** fine for personal use, but keep API keys minimal + set
  provider budget alerts, or put basic-auth (nginx/Caddy) in front.
- **LAN only:** run `HOST=0.0.0.0 npm run dev` on your own machine — nothing
  leaves your network.

---

## Verify the deployment

- `GET /` → 200 (globe loads, keyless Esri imagery)
- Open devtools Network → ADS-B/earthquake relays should return JSON, not 404
  (proves the middleware is live — static hosts would 404 here).
