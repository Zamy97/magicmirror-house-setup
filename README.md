# MagicMirror house setup

One-command (ish) bring-up for Raspberry Pi MagicMirror² houses: Node → MagicMirror → modules → `config.js` + `custom.css` → PM2.

Your shared modules already wired in:

- [MMM-LocalPrayerTime](https://github.com/Zamy97/MMM-LocalPrayerTime)
- [MMM-DailyDua](https://github.com/Zamy97/MMM-DailyDua)
- [MMM-DailyHadith](https://github.com/Zamy97/MMM-DailyHadith)

## Layout

```
magicmirror-house-setup/
  config/
    config.js.template      # shared modules + layout
    houses/
      example.env           # copy → <house>.env per home
  css/
    custom.css              # shared wall styling
  modules.txt               # modules to clone
  ecosystem.config.cjs      # PM2
  scripts/
    bootstrap.sh            # full install for a new Pi
    apply-house.sh          # push config/css only
    update-all.sh           # pull updates + re-apply + restart
```

## New house / new Pi

### 1. Put this repo on the Pi

```bash
cd ~
git clone https://github.com/YOUR_USER/magicmirror-house-setup.git
cd magicmirror-house-setup
```

(Or `scp` / USB copy if the repo is private/local.)

### 2. Create a house env

```bash
cp config/houses/example.env config/houses/smith.env
nano config/houses/smith.env   # set LAT, LON, TIMEZONE, etc.
```

### 3. Bootstrap

```bash
./scripts/bootstrap.sh smith
```

Then enable boot start (PM2 will print the exact command):

```bash
pm2 startup
# run the sudo command it prints
pm2 save
```

## Everyday edits (no reinstall)

Edit once in this repo, then push to the Pi:

| Change | Edit | Apply |
|--------|------|--------|
| Layout / modules | `config/config.js.template` | `./scripts/apply-house.sh smith` |
| Look & feel | `css/custom.css` | `./scripts/apply-house.sh smith` |
| House coords / keys | `config/houses/smith.env` | `./scripts/apply-house.sh smith` |
| New third-party module | `modules.txt` + template | re-run clone section or full `bootstrap` |

Restart after apply:

```bash
pm2 restart magicmirror
```

## Update MagicsMirror + modules on a live Pi

```bash
cd ~/magicmirror-house-setup
./scripts/update-all.sh smith
```

## Per-house values

`config/houses/<id>.env` becomes `~/MagicMirror/config/config.env`.  
MagicMirror expands `${LAT}`, `${LON}`, etc. inside `config.js`.

Keep real `*.env` files **out of git** (only `example.env` is tracked).

## Notes

- Default weather uses **Open-Meteo** (free) via MagicMirror’s built-in weather module.
- Prayer times use **MMM-LocalPrayerTime** (offline calc).
- PM2 starts `node --run start` in `~/MagicMirror`. For a pure kiosk browser against `serveronly`, change `ecosystem.config.cjs` args to `--run server` and launch Chromium yourself.

## Replace placeholders with your real CSS

Drop your production `custom.css` into `css/custom.css` in this repo whenever you polish the mirror UI. Same for adjusting module positions in `config.js.template`.
