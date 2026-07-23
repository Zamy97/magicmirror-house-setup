# MagicMirror house setup

Simple step-by-step to set up MagicMirror on a Raspberry Pi. House `config.js` and `custom.css` files live under `houses/`. Module install links are in [MODULES.md](MODULES.md).

Official MagicMirror install docs: https://docs.magicmirror.builders/getting-started/installation.html

---

## Step 1 — Install MagicMirror

### 1. Download and install a required Node.js version

See the official documentation:

- [Linux based distributions](https://nodejs.org/en/download)
- [Others](https://nodejs.org/en/download)

On Raspberry Pi OS / Debian, a common approach:

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v
```

(Use a current LTS major version that MagicMirror supports — check the [installation docs](https://docs.magicmirror.builders/getting-started/installation.html) if unsure.)

### 2. Make sure `git` is installed

```bash
git --version
```

If that fails:

```bash
sudo apt-get install -y git
```

### 3. Clone MagicMirror

```bash
cd ~
git clone https://github.com/MagicMirrorOrg/MagicMirror.git
```

### 4. Enter the repository

```bash
cd ~/MagicMirror
```

### 5. Install the application

```bash
node --run install-mm
```

This can take a long time on a Pi with little terminal output. Do not interrupt it.

### 6. Make a copy of the config sample file

```bash
cp config/config.js.sample config/config.js
```

### 7. Start MagicMirror (optional test)

```bash
node --run start
```

Stop with `Ctrl+C` when you are done testing.

---

## Step 2 — Install modules

```bash
cd ~/MagicMirror/modules
```

Clone the modules you need. Full list with install commands: **[MODULES.md](MODULES.md)**.

Example (our common set):

```bash
git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..

git clone https://github.com/Zamy97/MMM-DailyDua.git
git clone https://github.com/Zamy97/MMM-DailyHadith.git
```

Add any other modules from [MODULES.md](MODULES.md) that your house `config.js` uses.

---

## Step 3 — Config and CSS

Clone this setup repo (or copy files another way):

```bash
cd ~
git clone https://github.com/Zamy97/magicmirror-house-setup.git
```

Copy the house folder you want into MagicMirror (replace `HOUSE-FOLDER` with the folder name under `houses/`):

```bash
cp ~/magicmirror-house-setup/houses/HOUSE-FOLDER/config.js ~/MagicMirror/config/config.js
cp ~/magicmirror-house-setup/houses/HOUSE-FOLDER/custom.css ~/MagicMirror/config/custom.css
```

New MagicMirror versions load custom CSS from `config/custom.css` ([docs](https://docs.magicmirror.builders/configuration/customcss.html)). If the Pi runs an **older** MagicMirror that still uses `css/custom.css`, copy it there too:

```bash
cp ~/magicmirror-house-setup/houses/HOUSE-FOLDER/custom.css ~/MagicMirror/css/custom.css
```

Edit lat / lon / timezone if needed (prayer + weather modules in `config.js`):

```bash
nano ~/MagicMirror/config/config.js
```

Also update that house’s `LOCATION.md` in this repo so adhkar cron stays documented.

---

## Step 4 — Configure PM2

So MagicMirror starts on boot and restarts if it crashes:

```bash
sudo npm install -g pm2

cd ~/MagicMirror
pm2 start "node --run start" --name magicmirror
pm2 save
pm2 startup
```

Run the `sudo` command that `pm2 startup` prints, then:

```bash
pm2 save
```

Useful commands:

```bash
pm2 status
pm2 logs magicmirror
pm2 restart magicmirror
# on some Pis the process is named mm:
pm2 restart mm
# or: pm2 restart all
```

---

## Step 5 — Adhkar audio (location + cron)

Full guide: **[ADHKAR-AUDIO.md](ADHKAR-AUDIO.md)**  
Per-house copy-paste: `houses/HOUSE-FOLDER/LOCATION.md`

```bash
sudo apt-get install -y mpv
cd ~/MagicMirror/modules/MMM-DailyDua
git pull
# Use the lat/lon from that house's LOCATION.md / config.js
bash scripts/install-cron.sh --lat YOUR_LAT --lon YOUR_LON --morning 7:15 --offset 40
```

- `--lat` / `--lon` — house location (same as prayer times)
- `--morning` — morning play time (e.g. `7:15`)
- `--offset` — minutes before sunset for evening adhkar (default `40`)

---

## Updating later

```bash
cd ~/magicmirror-house-setup
git pull

cp houses/HOUSE-FOLDER/config.js ~/MagicMirror/config/config.js
cp houses/HOUSE-FOLDER/custom.css ~/MagicMirror/config/custom.css
pm2 restart all

cd ~/MagicMirror/modules/MMM-DailyDua && git pull
# If lat/lon or morning time changed, re-run install-cron.sh (see LOCATION.md)
```
