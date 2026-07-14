# MagicMirror modules (from Tushar bhai’s Pi)

Quick reference: what was installed under `~/MagicMirror/modules`, and how to install each one on a new Pi.

Skip **`default`** — it comes with MagicMirror. Skip **`MMM-PrayerTime.bak`** — that was only a backup folder.

## Install on a new Pi

```bash
cd ~/MagicMirror/modules
```

Then clone what you need (copy/paste lines below).

### Our modules (Zamy97)

```bash
git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..

git clone https://github.com/Zamy97/MMM-DailyDua.git

git clone https://github.com/Zamy97/MMM-DailyHadith.git
```

### Third-party modules (as on the Pi)

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
| `MMM-PrayerTime.bak` | Backup only — do not clone |

## Typical “minimum” set for a new house

If you only want prayer + dua + hadith (matches the saved house configs):

```bash
cd ~/MagicMirror/modules
git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..
git clone https://github.com/Zamy97/MMM-DailyDua.git
git clone https://github.com/Zamy97/MMM-DailyHadith.git
```

Add the other clones above only when that house’s `config.js` uses them.
