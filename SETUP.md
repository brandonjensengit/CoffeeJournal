# CoffeeMio App - Setup Guide

## ☕️ Your CoffeeMio MVP is Ready!

A sleek, modern coffee journaling app with a warm, cozy aesthetic built with SwiftUI and SwiftData.

### 🎨 What's Included (MVP)

#### Core Features
- ✅ **Beautiful Entry Form** - Log coffee sessions with detailed brewing parameters
- ✅ **Home Feed** - Gorgeous card-based layout showing recent entries
- ✅ **Detailed Entry View** - Full information display with edit/delete
- ✅ **Search & Filter** - Search by name/roaster/origin, filter by brew method
- ✅ **Quick/Detailed Modes** - Toggle between quick logging and comprehensive tracking
- ✅ **Favorites** - Mark and track your favorite coffees
- ✅ **Smart Defaults** - Sensible pre-filled values for faster logging

#### Design System
- 🎨 Warm color palette (coffee browns, creams, warm oranges)
- 🌙 **Dark Mode** - Warm, cozy dark theme (deep browns, not pure black)
- 🎯 Beautiful reusable components
- 💫 Smooth animations and transitions
- 📱 Native iOS design patterns
- ⚙️ Theme settings (Light, Dark, System)

#### Data Tracking
- Coffee name, origin, roaster
- Brew method (9 options with icons)
- Roast level (visual indicator)
- Grind size (visual scale)
- Brew ratio, water temp, brew time
- 5-star rating system
- Tasting notes (20+ suggestions)
- Personal notes
- Date/time logging
- Favorite marking

### 🚀 Next Steps

1. **Open the Xcode Project**
   ```bash
   open CoffeeMio.xcodeproj
   ```

2. **Add New Files to Xcode Project**
   All files have been created in the correct folders, but Xcode needs to know about them:

   - In Xcode, right-click on the `CoffeeMio` folder in the Project Navigator
   - Select "Add Files to 'CoffeeMio'..."
   - Select these folders (check "Create folder references"):
     - `Models/`
     - `Views/`
     - `Components/`
     - `Theme/`
   - Make sure "Copy items if needed" is UNCHECKED
   - Click "Add"

3. **Build and Run**
   - Select a simulator (iPhone 15 recommended)
   - Press `Cmd + R` or click the Play button
   - The app should build and launch!

### 📁 Project Structure

```
CoffeeMio/
├── CoffeeMioApp.swift          # App entry point with SwiftData setup
├── Models/
│   └── CoffeeEntry.swift          # SwiftData model for coffee entries
├── Views/
│   ├── HomeView.swift             # Main feed with search/filter
│   ├── AddEntryView.swift         # New entry form
│   ├── EditEntryView.swift        # Edit existing entry
│   ├── EntryDetailView.swift      # Detailed entry display
│   └── SettingsView.swift         # Settings with dark mode toggle
├── Components/
│   ├── RatingView.swift           # Star rating component
│   ├── BrewMethodPicker.swift     # Visual brew method selector
│   ├── RoastLevelIndicator.swift  # Roast level selector
│   ├── GrindSizeSlider.swift      # Grind size visual slider
│   └── TastingNotesSelector.swift # Tasting notes chips
├── Theme/
│   ├── Theme.swift                # Color palette with dark mode support
│   └── AppearanceManager.swift    # Theme preference manager
└── ContentView.swift              # (can be deleted)
```

### 🎯 Phase 2 Features (Optional Enhancements)

✅ **Dark Mode** - Already implemented! (See DARK_MODE.md for details)

Additional features you can add:

- 📊 **Statistics Dashboard**
  - Total coffees logged
  - Favorite brew method
  - Average rating
  - Brewing streaks
  - Charts with Chart.js

- 📸 **Photo Upload**
  - Coffee bag photos
  - Setup shots
  - Final cup photos
  - Image compression

- 💾 **Export/Import**
  - JSON backup
  - Share entries

- 🔔 **Notifications**
  - Brew reminders
  - Daily logging streaks

### 🎨 Color Palette Reference

```swift
Primary Coffee Browns:
- Primary: #6F4E37
- Dark: #3E2723

Warm Creams:
- Cream: #F5E6D3
- Light Cream: #E4D5C7

Warm Accents:
- Orange: #D4A574
- Golden Brown: #C19A6B

Roast Levels:
- Light: #C8A882
- Medium: #8B6F47
- Medium-Dark: #5D4037
- Dark: #3E2723
```

### ⚡️ Quick Tips

- The app uses **SwiftData** for local-first storage - no backend needed!
- All data persists automatically on the device
- Search is instant and real-time
- Forms auto-save on every change when editing
- Pull to refresh on the home feed
- Swipe actions for quick favorites

### 🐛 Troubleshooting

**Build Errors?**
- Make sure all files are added to the Xcode project target
- Clean build folder: `Cmd + Shift + K`
- Rebuild: `Cmd + B`

**Files not found?**
- Check that files are in the correct folders
- Verify they're checked in the Target Membership panel

### 📖 Usage Guide

1. **Add Your First Coffee**
   - Tap the "+" button in the top right
   - Toggle between Quick and Detailed mode
   - Fill in the coffee details
   - Tap "Save"

2. **Browse Entries**
   - Scroll through the beautiful card feed
   - Tap a card to see full details
   - Use the filter menu to show specific brew methods

3. **Search**
   - Pull down to reveal the search bar
   - Search by coffee name, origin, or roaster
   - Results update instantly

4. **Edit or Delete**
   - Tap an entry to view details
   - Tap the "..." menu in the top right
   - Choose Edit or Delete

5. **Mark Favorites**
   - Tap the heart icon on any entry
   - Favorites show a badge on the card

6. **Switch to Dark Mode** 🌙
   - Tap the gear icon (⚙️) in the top right
   - Choose Light, Dark, or System
   - Theme persists across app launches
   - See DARK_MODE.md for full details

Enjoy tracking your coffee journey! ☕️✨
