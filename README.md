# ResQNet — README

## Overview

**ResQNet** is a world-class premium Flutter emergency response application with ultra-modern soft neumorphic UI.

## Design System

- **Primary Palette**: Soft Mint Green · Powder Blue · Warm Cream · Light Aqua · Soft Beige
- **UI Style**: Neumorphism + Glassmorphism blend
- **Typography**: DM Sans via Google Fonts
- **Theme**: Full light + dark mode support

## Architecture

```
lib/
├── core/
│   ├── constants/          # App-wide constants
│   ├── theme/              # Colors, text styles, Material 3 theme
│   └── widgets/            # Shared reusable widgets
│       ├── neumorphic_card.dart    # Neumorphic container
│       ├── glass_card.dart         # Glassmorphism card
│       ├── animated_button.dart    # Scale-press buttons
│       ├── shared_widgets.dart     # Common UI components
│       └── bottom_nav.dart         # Premium rounded nav bar
├── features/
│   ├── home/               # Dashboard screen
│   ├── sos/                # SOS emergency screen
│   │   └── providers/      # SOS Riverpod state
│   ├── first_aid/          # First Aid Center
│   │   ├── data/           # First aid content
│   │   ├── providers/      # Search & filter state
│   │   └── widgets/        # Article detail screen
│   ├── maps/               # Offline Maps screen
│   └── profile/            # Profile & settings
├── providers/              # Global Riverpod providers
├── app.dart                # App shell + navigation
└── main.dart               # Entry point
```

## Features

### 🏠 Home Dashboard
- Animated welcome hero card
- Emergency status indicator
- Quick action 2×2 grid
- Nearby help horizontal scroll
- Daily safety tip card

### 🚨 SOS Screen
- Large animated emergency button with glow rings
- 5-second countdown with cancel option
- Emergency type selector grid (Medical, Fire, Flood, Crime, Quake, Other)
- Live location card with GPS coordinates
- Emergency contacts with one-tap call

### 🩺 First Aid Center
- Neumorphic search bar with live filtering
- Featured CPR card
- 6-category grid: CPR, Burns, Fractures, Flood, Fire, Choking
- Article detail with numbered step cards + warning section

### 🗺️ Offline Maps
- Custom-painted map with grid and road lines
- 4 interactive location markers
- Floating zoom/location controls
- Filter chips (All, Hospitals, Shelters, Police, Fire)
- Nearby shelter horizontal card list

### 👤 Profile Screen
- Premium avatar card with gradient
- Notification & location toggles
- Dark mode toggle (live theme switch)
- Language picker (5 languages)
- Emergency contact manager (add/remove)
- About & legal links

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on device/simulator
flutter run

# Build for release
flutter build apk       # Android
flutter build ios       # iOS
```

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.5.1 | State management |
| `google_fonts` | ^6.2.1 | DM Sans typography |
| `flutter_animate` | ^4.5.0 | Smooth animations |
| `shared_preferences` | ^2.2.3 | Theme persistence |
| `geolocator` | ^12.0.0 | GPS location |
| `url_launcher` | ^6.3.0 | Emergency calls |
