# MagicMirror house setup

Step-by-step Pi setup, a **modules list** for easy installs, and saved **config + CSS** per house.

## Houses

| Folder | What it is |
|--------|------------|
| [`houses/Tushar-bhai-Magic-Mirror-Config/`](houses/Tushar-bhai-Magic-Mirror-Config/) | **Tushar bhai** — `config.js` + `custom.css` |
| [`houses/Example/`](houses/Example/) | Template — copy for a new house |

Add a new house:

```bash
cp -r houses/Example "houses/Someone-Name-Magic-Mirror-Config"
# edit that folder’s config.js (lat / lon / timezone) and custom.css
```

---

## Step 1 — Install MagicMirror

On the Pi ([docs](https://docs.magicmirror.builders)):

```bash
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs git

cd ~
git clone https://github.com/MagicMirrorOrg/MagicMirror.git
cd ~/MagicMirror
npm install
```

Quick test:

```bash
cd ~/MagicMirror
node --run start
```

Stop with `Ctrl+C` when it looks OK.

---

## Step 2 — Install modules

See the full list (with clone URLs) in **[MODULES.md](MODULES.md)**.

Minimum set used by the house configs in this repo:

```bash
cd ~/MagicMirror/modules

git clone https://github.com/Zamy97/MMM-LocalPrayerTime.git
cd MMM-LocalPrayerTime && npm install && cd ..

git clone https://github.com/Zamy97/MMM-DailyDua.git
git clone https://github.com/Zamy97/MMM-DailyHadith.git
```

For everything that was on Tushar bhai’s Pi, copy the third-party clone block from [MODULES.md](MODULES.md).

---

## Step 3 — Config + CSS

Clone this repo (or copy the house folder over):

```bash
cd ~
git clone https://github.com/Zamy97/magicmirror-house-setup.git
```

**Tushar bhai** example:

```bash
cp ~/magicmirror-house-setup/houses/Tushar-bhai-Magic-Mirror-Config/config.js ~/MagicMirror/config/config.js
cp ~/magicmirror-house-setup/houses/Tushar-bhai-Magic-Mirror-Config/custom.css ~/MagicMirror/css/custom.css
```

Edit location if needed:

```bash
nano ~/MagicMirror/config/config.js
```

---

## Step 4 — PM2 (auto-start)

```bash
sudo npm install -g pm2

cd ~/MagicMirror
pm2 start "node --run start" --name magicmirror
pm2 save
pm2 startup
# run the sudo line PM2 prints, then:
pm2 save
```

Later:

```bash
pm2 status
pm2 logs magicmirror
pm2 restart magicmirror
```

---

## Updating config/CSS later

```bash
cd ~/magicmirror-house-setup
git pull

cp houses/Tushar-bhai-Magic-Mirror-Config/config.js ~/MagicMirror/config/config.js
cp houses/Tushar-bhai-Magic-Mirror-Config/custom.css ~/MagicMirror/css/custom.css
pm2 restart magicmirror
```
