# MagicMirror house setup

Saved **config** and **CSS** per house (by person name), plus a simple step-by-step to set up a Raspberry Pi.

## Houses in this repo

| Folder | Person |
|--------|--------|
| `houses/Tushaer-bhai/` | Tushaer bhai — `config.js` + `custom.css` |
| `houses/Example/` | Template — copy this folder to add a new house |

To add someone new:

```bash
cp -r houses/Example houses/Their-Name
# edit houses/Their-Name/config.js (lat/lon/timezone)
# edit houses/Their-Name/custom.css if needed
```

---

## Step 1 — Install MagicMirror

On the Pi ([official docs](https://docs.magicmirror.builders)):

```bash
# Recommended: use the MagicMirror install script, OR:

curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs git

cd ~
git clone https://github.com/MagicMirrorOrg/MagicMirror.git
cd ~/MagicMirror
npm install
```

Test it once:

```bash
cd ~/MagicMirror
node --run start
```

Stop with `Ctrl+C` when it looks OK.

---

## Step 2 — Install modules

```bash
cd ~/MagicMirror/modules

git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..

git clone https://github.com/Zamy97/MMM-DailyDua.git

git clone https://github.com/Zamy97/MMM-DailyHadith.git
```

(Add more `git clone` lines here when you add modules later.)

---

## Step 3 — Config + CSS for this house

Clone or download **this** repo on the Pi (or copy the house folder over USB):

```bash
cd ~
git clone https://github.com/Zamy97/magicmirror-house-setup.git
```

Pick the house folder (example: **Tushaer bhai**):

```bash
# Config
cp ~/magicmirror-house-setup/houses/Tushaer-bhai/config.js ~/MagicMirror/config/config.js

# CSS
cp ~/magicmirror-house-setup/houses/Tushaer-bhai/custom.css ~/MagicMirror/css/custom.css
```

Edit coords if needed:

```bash
nano ~/MagicMirror/config/config.js
# change lat, lon, timezone for that house
```

Start MagicMirror again and confirm prayer times / styles look right.

---

## Step 4 — PM2 (auto-start on boot)

```bash
sudo npm install -g pm2

cd ~/MagicMirror
pm2 start "node --run start" --name magicmirror
pm2 save
pm2 startup
# run the sudo command that PM2 prints, then:
pm2 save
```

Useful later:

```bash
pm2 status
pm2 logs magicmirror
pm2 restart magicmirror
```

---

## Updating a house later

1. Edit the files in GitHub / this repo under `houses/<Name>/`
2. On the Pi:

```bash
cd ~/magicmirror-house-setup
git pull

cp houses/Tushaer-bhai/config.js ~/MagicMirror/config/config.js
cp houses/Tushaer-bhai/custom.css ~/MagicMirror/css/custom.css
pm2 restart magicmirror
```
