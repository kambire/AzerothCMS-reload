<div align="center">
  <img src="https://raw.githubusercontent.com/FusionWowCMS/FusionCMS/main/writable/uploads/logo.png" alt="FusionCMS Logo" width="300" />
  <h1>FusionCMS: Reloaded & Enhanced Edition</h1>
  <p><strong>A beautifully enhanced open-source CMS for World of Warcraft Emulators, built on CodeIgniter 4 and Bootstrap. 🚀</strong></p>
</div>

---

## 🌟 About This Fork

Welcome to **FusionCMS: Reloaded**, a specialized version of the original FusionCMS project tailored to offer a significantly improved user experience, enhanced features, and critical bug fixes. We optimized it to be faster, more secure, and ready-to-deploy for modern World of Warcraft private servers.

---

## 🚀 Key Improvements & Features Added

### 📧 1. Marketing & Mass Mail System (New Module)
We built an entirely new system right into the Admin Panel to manage your server's marketing campaigns:
- **Admin Integration:** Accessible directly via the "Marketing" tab for server administrators.
- **Queue System:** Implements batch email sending with configurable `emails_per_hour` limits to prevent spam-blockers and timeout issues.
- **Campaign Tracking:** Keep track of your sent emails, subjects, and statuses inside the `mail_campaigns` and `mail_queue` tables.

### 🖼️ 2. Revamped News Layout
We replaced the default, cluttered news layout with a much cleaner, responsive **List View Layout**.
- **No more broken thumbnails:** Removed forced thumbnails to give more space for the content.
- **Typography focus:** Bigger headlines, readable text (`1.15rem`), and emphasized tags using the primary theme color.
- **Global applicability:** This cleaner format was applied across the `default`, `heaven`, and core news themes.

### 🔧 3. Critical Password Recovery & Captcha Fixes
- **Captcha Generation Fixed:** Solved the notorious `imagecreatefromjpeg()` missing function error. The system now gracefully detects and generates `.png` fallbacks dynamically through GD library.
- **SMTP & JSON Responses:** Fixed a core bug where password recovery emails would be sent, but the front-end would fail to parse the `JSON` response due to unexpected output headers.
- **Clean Sender Names:** Emails are now sent with proper custom Server Names (e.g. `ServerName - Gaming Life`) instead of just generic tags, avoiding 500/503 errors from modern mail clients.

### 🛍️ 4. Ready-to-use WOTLK Demo Store
The `fusion_final_full.sql` was expanded to include a set of highly-requested demo items to test the Store system immediately after a fresh install:
- **New Categories:** "Mounts & Pets" and "VIP & Services" with `FontAwesome` icons.
- **Demo Items included:** `Invincible's Reins`, `Reins of the Swift Spectral Tiger`, and `Lil' K.T.`. Prices are fully pre-configured in Vote Points (VP) and Donation Points (DP).

### ⚡ 5. Performance Improvements
- Real-time Smarty caching has been properly configured for development and deployment to avoid the need of clearing Minify/Cache folders constantly.

---

## 🛠️ Requirements
- PHP 8.1 / 8.2 (with `gd`, `mbstring`, `curl`, `intl`, `json`, `mysqli` extensions enabled)
- MySQL 5.7+ / MariaDB 10.4+
- Apache / Nginx
- World of Warcraft Emulator Database (AzerothCore, TrinityCore, etc.)

---

## ⚙️ Installation

1. Clone this repository into your web root directory.
   ```bash
   git clone https://github.com/kambire/FusionCMS-reload.git /var/www/html
   ```
2. Configure your environment by copying `env` to `.env`.
3. Give writable permissions to the `writable` and `public/uploads` directories.
4. Import the `application/modules/install/SQL/fusion_final_full.sql` file into your empty website database.
5. In your `.env` or `application/config/Database.php`, correctly link the Database to the newly created DB and to your `auth` / `characters` Emulator databases.
6. Delete the `application/modules/install` folder for security reasons.

Enjoy your server!

---

## 🤝 Contributing
Contributions, issues, and feature requests are always welcome! Feel free to check the issues page or submit PRs.

## 📝 License
This project is licensed under the MIT License - see the LICENSE file for details.
