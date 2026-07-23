# House location (for prayer times, weather, adhkar audio)

Keep these in sync with `config.js` (`lat` / `lon` on prayer + weather modules).

| Field | Value |
|-------|--------|
| House / label | Tushar bhai Magic Mirror |
| Latitude | `42.4710579` |
| Longitude | `-83.0133362` |
| Timezone | `America/Detroit` |
| Morning adhkar time | `7:15` |
| Evening offset before sunset | `40` minutes |

## Install adhkar cron on this Pi

```bash
sudo apt-get install -y mpv
cd ~/MagicMirror/modules/MMM-DailyDua
git pull
bash scripts/install-cron.sh \
  --lat 42.4710579 \
  --lon -83.0133362 \
  --morning 7:15 \
  --offset 40
```

Full guide: [ADHKAR-AUDIO.md](../../ADHKAR-AUDIO.md)
