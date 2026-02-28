<div align="center">
  <img src="https://raw.githubusercontent.com/FusionWowCMS/FusionCMS/main/writable/uploads/logo.png" alt="BlizzGeeks-CMS Logo" width="280" />
</div>

<h1 align="center">⚡ BlizzGeeks-CMS ⚡</h1>

<div align="center">
  <strong>The Ultimate Next-Generation CMS for World of Warcraft Private Servers</strong><br>
  Built on CodeIgniter 4 | Secure | Fast | Highly Customizable
</div>

<br>

<div align="center">
  <img src="https://img.shields.io/badge/PHP-8.1%2B-blue.svg?style=flat-square&logo=php" alt="PHP Version">
  <img src="https://img.shields.io/badge/Bootstrap-5.x-purple.svg?style=flat-square&logo=bootstrap" alt="Bootstrap">
  <img src="https://img.shields.io/badge/Emulator-AzerothCore%20%7C%20TrinityCore-success.svg?style=flat-square" alt="Emulators">
  <img src="https://img.shields.io/badge/Status-Fully%20Optimized-orange.svg?style=flat-square" alt="Status">
</div>

---

## 📖 What is BlizzGeeks-CMS?

**BlizzGeeks-CMS** is a heavily modified and modernized fork of FusionCMS, meticulously crafted to provide Server Owners with the most reliable, visually stunning, and feature-rich web platform. 

We took the core framework and stripped away all the annoying bugs, outdated layouts, and clunky mechanics, replacing them with optimized, beautiful features ready for production environments right out of the box.

---

## 🔥 Exclusive New Features & Overhauls

### ✉️ Mass Marketing Built-In
No more relying on third-party tools. Reach your players directly from your Admin Panel.
- **Smart Queues:** Built-in email batching with customizable hourly limits to protect your server from being blacklisted.
- **Campaign Dashboard:** Track active and pending campaigns via the `mail_campaigns` and `mail_queue` system natively integrated into the ACL permissions grid.

### 📰 Modernized News Feeds
We trashed the old "boxy" news layout that forced pixelated thumbnails. 
- **Sleek List View:** News articles now display in a wide, gorgeous format focusing strictly on typography and content readability.
- **Unified Aesthetics:** Perfect integration with both `Default` and `Heaven` themes without sacrificing responsiveness.

### 🛡️ Ironclad Security & Core Fixes
- **Intelligent Captcha Regeneration:** Exterminated the dreaded `Call to undefined function imagecreatefromjpeg()` error by implementing a dynamic GD Library `.png` fallback system.
- **Password Recovery Saved:** Completely rebuilt the JSON output headers to prevent 500 errors and SMTP protocol clashes when users try to recover their accounts. Your password resets *actually* send emails now.

### 🛍️ Plug-and-Play WOTLK Store
Your database shouldn't be empty on a fresh install. Start monetizing or rewarding players instantly!
- The fresh installation comes pre-loaded with **"Mounts & Pets"** and **"VIP & Services"** categories.
- Features highly sought-after demo items: *Invincible's Reins, Reins of the Swift Spectral Tiger, and Lil' K.T.* configured seamlessly with Vote Points (VP) and Donation Points (DP).

### ⚡ Caching Perfected
Smarty Template caching has been reworked to eliminate the need for endless "Cache Clearing" during development or daily adjustments.

---

## ⚙️ Server Requirements

To run **BlizzGeeks-CMS** flawlessly, your environment should meet the following specifications:

| Requirement | Minimum Version | Required Extensions |
| :--- | :---: | :--- |
| **PHP** | `8.1` | `gd`, `mbstring`, `curl`, `intl`, `json`, `mysqli` |
| **Database** | MySQL `5.7` / MariaDB `10.4` | |
| **Web Server** | Apache / Nginx | `mod_rewrite` enabled |

---

## 🚀 Quick Setup Guide

1. **Clone the Source Code**  
   Pull the code directly into your web root:
   ```bash
   git clone https://github.com/kambire/FusionCMS-reload.git /var/www/html
   ```

2. **Environment Configuration**  
   Copy the `env` file, rename it to `.env`, and configure your base URL. Set your database credentials in `.env` or `application/config/Database.php`.

3. **Database Installation**  
   Import the structural foundation into your empty website database:
   ```text
   📁 application/modules/install/SQL/fusion_final_full.sql
   ```

4. **Permissions & Security**  
   Ensure the following directories are fully writable by the web server (`chmod -R 775`):
   - `/writable`
   - `/public/uploads`  
   
   ⚠️ *Crucial: Delete the `application/modules/install` folder after setup to prevent unwanted re-installations.*

---

## 🎨 Theme Customization
BlizzGeeks-CMS supports full customization. Tweak colors, layouts, and components directly from the Admin Panel or dive into the `.tpl` files located in the `application/themes/` directory for full HTML/Smarty control.

<br>

<div align="center">
  <sub>Developed with 💙 for the World of Warcraft Emulation Community by <b>Kambire</b> & Contributors.</sub>
</div>
