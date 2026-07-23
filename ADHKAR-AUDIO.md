# Adhkar audio — location & cron setup

Morning and evening adhkar audio lives in **MMM-DailyDua** (`audio/*.m4a`) and is scheduled with **cron + mpv**.  
MagicMirror `config.js` does **not** control the audio — only the on-screen dua text.

## Per-house checklist (new Pi)

### 1. Find the house latitude / longitude

Use the same values as prayer times / weather in that house’s `config.js` (`lat` / `lon`).

Or look them up: [latlong.net](https://www.latlong.net/) / Google Maps (right-click → coordinates).

Write them down in the house folder (see `houses/*/LOCATION.md`).

### 2. Install mpv (once per Pi)

```bash
sudo apt-get update
sudo apt-get install -y mpv
```

### 3. Update the module (audio files come with git pull)

```bash
cd ~/MagicMirror/modules/MMM-DailyDua
git pull
```

### 4. Install / update cron for this house

Replace `LAT`, `LON`, and optionally morning time:

```bash
cd ~/MagicMirror/modules/MMM-DailyDua
bash scripts/install-cron.sh \
  --lat LAT \
  --lon LON \
  --morning 7:15 \
  --offset 40
```

| Flag | Meaning | Example |
|------|---------|---------|
| `--lat` | House latitude | `42.4710579` |
| `--lon` | House longitude | `-83.0133362` |
| `--morning` | Local time to play morning adhkar | `7:15` (use anything in ~7:00–7:30) |
| `--offset` | Minutes **before sunset** for evening adhkar | `40` |

Running `install-cron.sh` again **replaces** the previous MMM-DailyDua cron block (safe to re-run when you move houses or change times).

### 5. Verify

```bash
crontab -l
bash ~/MagicMirror/modules/MMM-DailyDua/scripts/play-adhkar.sh morning
bash ~/MagicMirror/modules/MMM-DailyDua/scripts/play-adhkar.sh evening
```

Logs: `~/.local/state/mmm-dailydua/cron.log`

## What the cron jobs do

| Job | When |
|-----|------|
| Morning | Every day at `--morning` (fixed clock time) |
| Evening | Every 5 minutes cron checks; plays **once** when local time ≈ sunset − `--offset` for that lat/lon |

Sunset is estimated from lat/lon (close enough for Maghrib-ish timing). It shifts through the year automatically — you do **not** need to edit cron for seasons.

## Changing location later

1. Update `lat` / `lon` in `~/MagicMirror/config/config.js` (prayer + weather modules).
2. Update `houses/HOUSE-FOLDER/LOCATION.md` in this repo.
3. Re-run `install-cron.sh` with the new `--lat` / `--lon`.
4. Commit the house folder changes so the next Pi setup stays correct.

## Example (Warren / Detroit-area house)

```bash
bash scripts/install-cron.sh \
  --lat 42.4710579 \
  --lon -83.0133362 \
  --morning 7:15 \
  --offset 40
```

## Remove adhkar cron

```bash
crontab -l | awk '/BEGIN MMM-DailyDua adhkar/{skip=1; next} /END MMM-DailyDua adhkar/{skip=0; next} !skip' | crontab -
```

Or edit with `crontab -e` and delete the block between `# BEGIN MMM-DailyDua adhkar` and `# END MMM-DailyDua adhkar`.
