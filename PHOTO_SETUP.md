# Photo Capture Setup Guide

## 📸 Photo Feature Implementation

The CoffeeMio app now supports taking photos and selecting from the photo library!

---

## ✅ What's Been Implemented

### 1. **Image Picker Component** (`Utilities/ImagePicker.swift`)
- Modern PhotosPicker for photo library access
- Camera integration using UIImagePickerController
- Beautiful image preview with remove button
- Seamless integration with forms

### 2. **Image Compression** (`Utilities/ImageCompression.swift`)
- Automatic image resizing (max 1200px)
- JPEG compression (target 500KB)
- Smart quality adjustment
- Maintains aspect ratio

### 3. **Updated Views**
- ✅ **AddEntryView** - Photo capture when creating entries
- ✅ **EditEntryView** - Photo editing for existing entries
- ✅ **HomeView** - Photos display in entry cards (already working!)
- ✅ **EntryDetailView** - Full photo display (already working!)

---

## 🔐 Required: Add Permissions in Xcode

Since iOS 14+, you must request user permission to access the camera and photo library.

### Steps to Add Permissions

1. **Open the Xcode Project**
   ```bash
   open CoffeeMio.xcodeproj
   ```

2. **Select the Project**
   - Click on `CoffeeMio` in the Project Navigator (top-left)
   - Select the `CoffeeMio` target under "TARGETS"

3. **Open Info Tab**
   - Click the "Info" tab at the top

4. **Add Privacy Descriptions**

   Click the "+" button next to "Custom iOS Target Properties" and add these keys:

   **Key 1: Camera Permission**
   - **Key**: `Privacy - Camera Usage Description`
   - **Type**: String
   - **Value**: `We need access to your camera to take photos of your coffee, bags, and brewing setups.`

   **Key 2: Photo Library Permission**
   - **Key**: `Privacy - Photo Library Usage Description`
   - **Type**: String
   - **Value**: `We need access to your photo library to select images of your coffee experiences.`

   **Key 3: Photo Library Add-Only Permission** (iOS 14+)
   - **Key**: `Privacy - Photo Library Additions Usage Description`
   - **Type**: String
   - **Value**: `We need permission to save photos to your library.`

### Alternative Method (if Info tab doesn't show)

1. Right-click on `CoffeeMio` folder in Project Navigator
2. Select "New File..."
3. Choose "Property List"
4. Name it `Info.plist`
5. Add the following XML:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSCameraUsageDescription</key>
    <string>We need access to your camera to take photos of your coffee, bags, and brewing setups.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>We need access to your photo library to select images of your coffee experiences.</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>We need permission to save photos to your library.</string>
</dict>
</plist>
```

---

## 🎯 How to Use

### Taking Photos in the App

1. **Create New Entry**
   - Tap "+" button to create a new entry
   - Scroll to the "Photo" section
   - Choose:
     - **Photo Library** - Select existing photo
     - **Camera** - Take a new photo

2. **Photo Preview**
   - After selecting/taking a photo, it displays with a preview
   - Tap the ❌ button in the corner to remove and select a different photo

3. **Photo Storage**
   - Photos are automatically compressed to ~500KB
   - Resized to max 1200px (maintains quality)
   - Stored directly in the app's database

4. **Edit Photos**
   - Open any entry
   - Tap "..." menu → Edit
   - Scroll to "Photo" section
   - Change or remove the photo

---

## 🎨 Features

### Automatic Compression
- Original: 5-10MB → Compressed: ~500KB
- No quality loss visible to the eye
- Faster loading and less storage

### Smart Resizing
- Maintains aspect ratio
- Max dimension: 1200px
- Perfect for retina displays

### User Experience
- Photo Library uses modern PhotosPicker (iOS 16+)
- Camera uses UIImagePickerController
- Beautiful preview with remove button
- Smooth animations

---

## 📱 Testing the Feature

1. **Build and Run**
   ```bash
   # In Xcode, press Cmd + R
   ```

2. **Grant Permissions**
   - First time you tap Camera or Photo Library
   - iOS will show permission dialog
   - Tap "Allow" to grant access

3. **Test Photo Library**
   - Create or edit an entry
   - Tap "Photo Library"
   - Select a photo from your device
   - Photo appears in preview

4. **Test Camera** (Real Device Only)
   - Camera requires physical device (not simulator)
   - Tap "Camera" button
   - Take a photo
   - Photo appears in preview

5. **Test Display**
   - Save the entry
   - See photo in card on home feed
   - Tap entry to see full-size photo

---

## 🔧 Troubleshooting

**Permission Dialog Doesn't Appear?**
- Make sure you added the privacy descriptions
- Delete the app and reinstall
- Check Settings → Privacy → Camera/Photos

**Camera Not Working on Simulator?**
- Camera only works on real iOS devices
- Use Photo Library on simulator for testing

**Photos Not Displaying?**
- Check that photo was saved successfully
- Look for photoData in the entry
- Ensure image compression succeeded

**Permission Denied?**
- User can reset: Settings → Privacy → Camera/Photos
- Find your app and toggle permissions

**Build Errors About Missing Keys?**
- You forgot to add privacy descriptions
- Follow the "Add Permissions" steps above

---

## 📂 New Files Created

```
CoffeeMio/
├── Utilities/
│   ├── ImagePicker.swift        # Photo picker + camera
│   └── ImageCompression.swift   # Image compression utility
```

---

## 🎉 What's Next?

Photo feature is complete! Optional enhancements:

- **Multiple Photos** - Allow multiple photos per entry
- **Photo Editing** - Crop, rotate, filters
- **Photo Gallery** - View all coffee photos
- **Share Photos** - Export to social media
- **OCR** - Extract text from coffee bag labels

---

Enjoy capturing your coffee moments! ☕️📸
