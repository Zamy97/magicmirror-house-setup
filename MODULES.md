# MagicMirror modules

Quick reference: modules we use / have used on house Pis, with install commands.

Skip **`default`** — it comes with MagicMirror. Skip backup folders like **`MMM-PrayerTime.bak`**.

## Install on a Pi

```bash
cd ~/MagicMirror/modules
```

Then clone what you need.

### Our modules (Zamy97)

```bash
git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..

git clone https://github.com/Zamy97/MMM-DailyDua.git

git clone https://github.com/Zamy97/MMM-DailyHadith.git
```

**Adhkar audio (after DailyDua is installed):** see [ADHKAR-AUDIO.md](ADHKAR-AUDIO.md) and each house’s `LOCATION.md` for lat/lon + cron.

```bash
sudo apt-get install -y mpv
cd ~/MagicMirror/modules/MMM-DailyDua
bash scripts/install-cron.sh --lat YOUR_LAT --lon YOUR_LON --morning 7:15 --offset 40
```

### Third-party modules

```bash
# Monthly calendar
git clone https://github.com/KirAsh4/calendar_monthly.git

# Islamic date
git clone https://github.com/eulhaque/currentislamicdate.git

# Weather effects (needs OpenWeather API key)
git clone https://github.com/scottcl88/MMM-DynamicWeather.git

# Current weather images (OpenWeather)
git clone https://github.com/sathyarajv/MMM-OpenmapWeather.git

# Weather forecast (OpenWeather)
git clone https://github.com/MarcLandis/MMM-OpenWeatherMapForecast.git

# Prayer times via API (aladhan) + adhan audio
git clone https://github.com/slametps/MMM-PrayerTime.git

# Random Quran ayah
git clone https://github.com/slametps/MMM-RandomQuranAyah.git

# Wi‑Fi password / QR
git clone https://github.com/TeraTech/MMM-WiFiPassword.git

# World clock
git clone https://github.com/ulrichwisser/MMM-Worldclock.git
```

## Folder → repo cheat sheet

| Folder on Pi | Install from |
|--------------|--------------|
| `calendar_monthly` | https://github.com/KirAsh4/calendar_monthly |
| `currentislamicdate` | https://github.com/eulhaque/currentislamicdate |
| `MMM-DailyDua` | https://github.com/Zamy97/MMM-DailyDua |
| `MMM-DailyHadith` | https://github.com/Zamy97/MMM-DailyHadith |
| `MMM-DynamicWeather` | https://github.com/scottcl88/MMM-DynamicWeather |
| `MMM-LocalPrayerTime` | https://github.com/Zamy97/MMM-LocalPrayerTime (`npm install`) |
| `MMM-OpenmapWeather` | https://github.com/sathyarajv/MMM-OpenmapWeather |
| `MMM-OpenWeatherMapForecast` | https://github.com/MarcLandis/MMM-OpenWeatherMapForecast |
| `MMM-PrayerTime` | https://github.com/slametps/MMM-PrayerTime |
| `MMM-RandomQuranAyah` | https://github.com/slametps/MMM-RandomQuranAyah |
| `MMM-WiFiPassword` | https://github.com/TeraTech/MMM-WiFiPassword |
| `MMM-Worldclock` | https://github.com/ulrichwisser/MMM-Worldclock |
| `default` | Built into MagicMirror — do not clone |
| `*.bak` | Backup only — do not clone |

## Typical minimum set

Prayer + dua + hadith (matches most house configs in this repo):

```bash
cd ~/MagicMirror/modules
git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..
git clone https://github.com/Zamy97/MMM-DailyDua.git
git clone https://github.com/Zamy97/MMM-DailyHadith.git
```

Only add the other clones when that house’s `config.js` uses them.
