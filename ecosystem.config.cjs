/**
 * PM2 process file for MagicMirror² (server-only + Chromium kiosk is typical on Pi).
 * Start from this setup repo OR after bootstrap points PM2 at ~/MagicMirror.
 *
 * Usage on Pi (after bootstrap):
 *   pm2 start ~/magicmirror-house-setup/ecosystem.config.cjs
 *   pm2 save
 *   pm2 startup
 */
module.exports = {
  apps: [
    {
      name: "magicmirror",
      cwd: process.env.HOME + "/MagicMirror",
      script: "node",
      args: "--run start",
      // Use serveronly if you launch Chromium separately:
      // args: "--run server",
      autorestart: true,
      max_restarts: 20,
      min_uptime: "10s",
      env: {
        NODE_ENV: "production",
        Display: ":0",
      },
    },
  ],
};
