# MagicMirror house setup

Playbook for house Raspberry Pis. Configs live under `houses/`. Modules: [MODULES.md](MODULES.md).

**Repo:** https://github.com/Zamy97/magicmirror-house-setup  

**Official docs (source of truth for MM itself):**
- [Installation](https://docs.magicmirror.builders/getting-started/installation.html)
- [Requirements](https://docs.magicmirror.builders/getting-started/requirements.html) — Pi OS **Desktop** (not Lite)
- [Autostart](https://docs.magicmirror.builders/configuration/autostart.html) — **user systemd** + Electron
- [Raspberry / Trixie](https://docs.magicmirror.builders/configuration/raspberry.html)

**Stable method we use:** Raspberry Pi OS Desktop (Trixie) → MagicMirror Electron (`node --run start`) → user systemd autostart → house config from this repo. No Chromium kiosk, no `serveronly` unless we explicitly choose it later.

---

## Soft wipe (start clean, keep the OS)

Run on the Pi when an old install is messy:

```bash
# Stop old process managers / browsers
pm2 delete all 2>/dev/null || true
pm2 unstartup systemd -u pi --hp /home/pi 2>/dev/null || true
systemctl --user disable --now magicmirror.service 2>/dev/null || true
pkill chromium 2>/dev/null || true
pkill -f "MagicMirror" 2>/dev/null || true

# Remove kiosk leftovers
rm -f ~/bin/start-mirror-kiosk.sh
sed -i '/start-mirror-kiosk/d' ~/.config/labwc/autostart 2>/dev/null || true

# Remove MagicMirror tree
rm -rf ~/MagicMirror
```

Then follow **Fresh install** below.

---

## Fresh install

### 0. Pi desktop basics

```bash
sudo raspi-config
```

- **System Options → Boot / Auto Login → Desktop autologin**
- **Display Options → Screen Blanking → No**

### 1. Node.js + git

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs git
node -v
npm -v
```

### 2. Clone and install MagicMirror

```bash
cd ~
git clone https://github.com/MagicMirrorOrg/MagicMirror.git
cd ~/MagicMirror
node --run install-mm
```

This can take a long time with little output — do not interrupt.

### 3. Network hardening (every house Pi)

Stops `ENETUNREACH` on broken IPv6 and flaky Wi‑Fi sleep:

```bash
# Prefer IPv4
grep -q 'precedence :ffff:0:0/96' /etc/gai.conf 2>/dev/null || \
  echo 'precedence :ffff:0:0/96  100' | sudo tee -a /etc/gai.conf

# Disable IPv6
sudo tee /etc/sysctl.d/99-disable-ipv6.conf >/dev/null <<'EOF'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sudo sysctl --system

# Wi-Fi powersave off (Pi OS Trixie / NetworkManager)
sudo tee /etc/NetworkManager/conf.d/powersave.conf >/dev/null <<'EOF'
[connection]
wifi.powersave=2
EOF
sudo systemctl restart NetworkManager
```

Or: `bash ~/magicmirror-house-setup/scripts/fix-ipv4-on-pi.sh` after cloning this repo.

### 4. Clone this playbook + apply a house

```bash
cd ~
git clone https://github.com/Zamy97/magicmirror-house-setup.git
# later updates:
# cd ~/magicmirror-house-setup && git pull

HOUSE=Example   # or: Tushar-bhai-Magic-Mirror-Config
cp ~/magicmirror-house-setup/houses/$HOUSE/config.js ~/MagicMirror/config/config.js
cp ~/magicmirror-house-setup/houses/$HOUSE/custom.css ~/MagicMirror/config/custom.css
```

Edit secrets / lat-lon / Wi‑Fi / OpenWeather keys on the Pi only (do not commit real keys):

```bash
nano ~/MagicMirror/config/config.js
```

### 5. Install modules

```bash
cd ~/MagicMirror/modules
```

Follow **[MODULES.md](MODULES.md)** for everything that house’s `config.js` references. Typical set:

```bash
git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..
git clone https://github.com/Zamy97/MMM-DailyDua.git
git clone https://github.com/Zamy97/MMM-DailyHadith.git
git clone https://github.com/Zamy97/MMM-QuranAyah.git

git clone https://github.com/KirAsh4/calendar_monthly.git
git clone https://github.com/eulhaque/currentislamicdate.git
git clone https://github.com/scottcl88/MMM-DynamicWeather.git
git clone https://github.com/sathyarajv/MMM-OpenmapWeather.git
git clone https://github.com/MarcLandis/MMM-OpenWeatherMapForecast.git
git clone https://github.com/TeraTech/MMM-WiFiPassword.git
git clone https://github.com/ulrichwisser/MMM-Worldclock.git
```

**DynamicWeather holiday scrape:** if the module still 403s, either keep `effects: []` in config, or patch once:

```bash
python3 - <<'PY'
from pathlib import Path
p = Path.home() / "MagicMirror/modules/MMM-DynamicWeather/MMM-DynamicWeather.js"
t = p.read_text()
old = "_this_1.allHolidays.push(effect.holiday);"
new = "if (effect.holiday) { _this_1.allHolidays.push(effect.holiday); }"
if old in t:
    p.write_text(t.replace(old, new, 1))
    print("patched")
else:
    print("already patched or different version")
PY
```

### 6. Test Electron once

```bash
cd ~/MagicMirror
NODE_OPTIONS='--dns-result-order=ipv4first' node --run start
```

You should see the mirror window. Stop with `Ctrl+C`.

### 7. Autostart (official: user systemd)

Per [Autostart docs](https://docs.magicmirror.builders/configuration/autostart.html) — starts after desktop login so Electron has Wayland:

```bash
mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/magicmirror.service
```

```ini
[Unit]
Description=MagicMirror
After=graphical-session.target

[Service]
Type=simple
Restart=always
RestartSec=15
WorkingDirectory=%h/MagicMirror
Environment=NODE_OPTIONS=--dns-result-order=ipv4first
ExecStart=/usr/bin/node --run start

[Install]
WantedBy=default.target
```

```bash
systemctl --user daemon-reload
systemctl --user enable --now magicmirror.service
systemctl --user status magicmirror.service
```

Useful:

```bash
systemctl --user restart magicmirror.service
journalctl --user -u magicmirror.service -n 50 --no-pager
```

Enable lingering so user services behave predictably after reboot (optional but recommended):

```bash
sudo loginctl enable-linger pi
```

### 8. Display lock (portrait TV example)

If the house uses HDMI-A-2 at 1080p rotated 270°:

```bash
mkdir -p ~/.config/labwc
nano ~/.config/labwc/autostart
```

```bash
wlr-randr --output HDMI-A-2 --mode 1920x1080 --transform 270
```

Do **not** put Chromium or a second MagicMirror start here.

### 9. Adhkar audio (optional)

See [ADHKAR-AUDIO.md](ADHKAR-AUDIO.md) and `houses/HOUSE-FOLDER/LOCATION.md`.

```bash
sudo apt-get install -y mpv
cd ~/MagicMirror/modules/MMM-DailyDua
bash scripts/install-cron.sh --lat YOUR_LAT --lon YOUR_LON --morning 7:15 --offset 40
```

---

## Updating later

```bash
cd ~/magicmirror-house-setup && git pull
HOUSE=Example   # or the house folder name
cp houses/$HOUSE/config.js ~/MagicMirror/config/config.js
cp houses/$HOUSE/custom.css ~/MagicMirror/config/custom.css
systemctl --user restart magicmirror.service

cd ~/MagicMirror/modules/MMM-QuranAyah && git pull
cd ~/MagicMirror/modules/MMM-DailyDua && git pull
cd ~/MagicMirror/modules/MMM-DailyHadith && git pull
cd ~/MagicMirror/modules/MMM-LocalPrayerTime && git pull
```

---

## Houses

| Folder | Notes |
|--------|--------|
| `Example` | Template |
| `Tushar-bhai-Magic-Mirror-Config` | Tushar bhai’s house |
