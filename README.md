
# Renova Platform — Construction & Renovation System

<p align="center">
  <b>Full-stack multi-role platform connecting Customers, Contractors, Engineers, and Administrators</b>
</p>

<p align="center">
  <!-- Backend Badges -->
  <a href="#-backend-api-laravel-11"><img src="https://img.shields.io/badge/Backend-Laravel%2011-red?style=for-the-badge&logo=laravel"></a>
  <a href="#-backend-api-laravel-11"><img src="https://img.shields.io/badge/PHP-8%2B-blue?style=for-the-badge&logo=php"></a>
  <a href="#-backend-api-laravel-11"><img src="https://img.shields.io/badge/MySQL-Database-orange?style=for-the-badge&logo=mysql"></a>
  <a href="#-backend-api-laravel-11"><img src="https://img.shields.io/badge/Auth-Sanctum-green?style=for-the-badge"></a>
  <br>
  <!-- Mobile Badges -->
  <a href="#-mobile-app-flutter"><img src="https://img.shields.io/badge/Mobile-Flutter-02569B?style=for-the-badge&logo=flutter"></a>
  <a href="#-mobile-app-flutter"><img src="https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart"></a>
  <a href="#-mobile-app-flutter"><img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-lightgrey?style=for-the-badge&logo=android"></a>
<br>
  <!-- Web Badges -->
  <a href="#-web-dashboard-react"><img src="https://img.shields.io/badge/Web%20Dashboard-React-61DAFB?style=for-the-badge&logo=react"></a>
  <a href="#-web-dashboard-react"><img src="https://img.shields.io/badge/Language-JavaScript-F7DF1E?style=for-the-badge&logo=javascript"></a>
</p>

---

## Overview

**Renova** is a construction and renovation platform that connects customers with contractors, while engineers provide technical oversight and administrators manage the entire system.

The platform consists of four main components:

| Component              | Technology     | Purpose                                      |
|------------------------|----------------|----------------------------------------------|
| **Backend API**        | Laravel 11     | Core business logic, wallets, security       |
| **Mobile App**         | Flutter        | Customers & Contractors                      |
| **Engineer App**       | Flutter        | Engineers                                    |
| **Web Dashboard**      | React          | Platform Admin                               |

---

## Repository Structure

```text
renova/
├── backend/          # Laravel 11 REST API
├── mobile-app/       # Flutter app (Customers + Contractors)
├── engineer_app/     # Flutter app (Engineers)
└── web-dashboard/    # React Admin Dashboard
```

---

## Backend API (Laravel 11)

### Architecture

#### Service Layer
Business logic is fully isolated in dedicated service classes. Controllers remain thin — they only validate input, call a service, and return a response.

#### Role-Based Access Control
Four roles enforced via custom middleware:

| Role         | Access                                              |
|--------------|-----------------------------------------------------|
| `user`       | Post requests, approve forms, pay, file complaints  |
| `contractor` | Browse requests, send inspection offers, create forms |
| `engineer`   | Review forms, manage site visits, update progress   |
| `admin`      | Full platform management via React dashboard        |

#### Wallet & Escrow System
All money movements go through `WalletService` using:
- **Pessimistic locking** (`lockForUpdate`)
- **Database transactions**
- **Full transaction logging**

The admin wallet acts as platform escrow and holds **30%** of each project’s cost during the warranty period.

#### Concurrency & Data Integrity

| Mechanism           | Purpose                            |
|---------------------|------------------------------------|
| `lockForUpdate()`   | Prevent race conditions on wallets |
| `DB::transaction()` | Atomic payment & release operations |

#### Redis (Caching + Queues)
- **Caching**: Used to cache frequently accessed data (analytics, listings, etc.) to reduce database load.
- **Queues**: Background jobs (emails) are handled via Redis queues for better performance and responsiveness.

#### Real-time Notifications (Firebase)
Push notifications are sent to Customers, Contractors and Engineers using **Firebase Cloud Messaging**.

---

### Features

- **Authentication** — Register, login, OTP verification, password reset, Sanctum auth
- **Reconstruction Requests** — Create, update, browse with filters
- **Inspection Requests** — Contractor applies → Customer accepts one
- **Site Visits** — Admin assigns engineers, engineers accept/reject, no-show reporting
- **Construction Forms** — Full lifecycle (create → review → approve → payment)
- **Payments & Escrow** — OTP payments, partial/full release, warranty lock
- **Complaints** — Project complaints + No-show warnings (account deactivation at 3 warnings)
- **Notifications** — Real-time Firebase push notifications.
- **Background Jobs** — Redis queues for emails and asynchronous processing

---

### Tech Stack (Backend)

| Layer          | Technology              |
|----------------|-------------------------|
| Backend        | Laravel 11              |
| Language       | PHP 8+                  |
| Database       | MySQL                   |
| Cache & Queues | Redis                   |
| Auth           | Sanctum                 |
| Notifications  | Firebase Cloud Messaging|
| Testing        | PHPUnit + SQLite        |
| API Testing    | Postman                 |

---

### Testing

**170 tests** (Feature + Unit) running on in-memory SQLite.

```bash
cd backend
php artisan test
```

---

### Installation (Backend)

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

Make sure Redis is running:

```bash
sudo service redis-server start
# or
redis-server
```

Then start the queue worker:

```bash
php artisan queue:work
```

---

## Mobile App (Customers & Contractors)

> **Location:** `mobile-app/`  
> **Maintained by:** Mobile Development Team

Flutter application serving two roles: **Customers** and **Contractors**.

### Key Features
- Post reconstruction requests with photos
- Browse contractor profiles
- Send & accept inspection requests
- Approve construction forms
- Make OTP-secured payments
- File complaints
- Receive real-time Firebase notifications

```bash
cd mobile-app
flutter pub get
flutter run
```

---

## Engineer App

> **Location:** `engineer_app/`  
> **Maintained by:** Mobile Development Team

Separate Flutter application dedicated to **Engineers**.

### Key Features
- Accept / reject site visits
- Review construction forms
- Update project progress
- Manage assigned tasks
- Receive real-time Firebase notifications

```bash
cd engineer_app
flutter pub get
flutter run
```

---

## Web Dashboard (Admin)

> **Location:** `web-dashboard/`  
> **Maintained by:** Frontend Team

React-based admin panel for full platform oversight.

### Key Features
- Approve contractor & engineer registrations
- Assign engineers to site visits
- Manage escrow & payments
- Resolve complaints and no-show warnings
- View platform analytics

```bash
cd web-dashboard
npm install
npm run dev
```

