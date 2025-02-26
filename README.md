# 📖 Proverbus - Proverb Application

**Proverbus** is a mobile application designed to help users explore and manage biblical proverbs. The app provides structured access to chapters and verses, allows note-taking, tracks achievements, and synchronizes data using Firebase.

---

## 🚀 Features

- ✅ **Explore Proverbs** – Browse and read biblical proverbs chapter by chapter.
- ✅ **Take Notes** – Save personal reflections on specific verses.
- ✅ **Track Achievements** – Keep track of progress and accomplishments.
- ✅ **Daily Proverb Notifications** – Get a verse of the day reminder.
- ✅ **Search Functionality** – Quickly find specific proverbs.
- ✅ **Cloud Sync** – Backup and restore data using Firebase Firestore.
- ✅ **Dark Mode** – Customize the reading experience.
- ✅ **Multi-language Support** – Available in multiple languages.

---

## 📥 Installation & Setup

### ✅ Prerequisites

- Install [Flutter](https://flutter.dev/docs/get-started/install).
- Set up a Firebase project and configure it for Flutter.

### ✅ Steps to Install

1. **Clone the repository**:
   ```sh
   git clone https://github.com/yourusername/proverbus.git
   cd proverb_application
2. **Install dependencies**:
   ```sh
   flutter pub get
3. **Configure Firebase**:
- Create a Firebase project at Firebase Console.
- Enable Authentication and Firestore Database.
- Download google-services.json (for Android) and GoogleService-Info.plist (for iOS).
- Place them inside the appropriate directories:
    ```sh
   android/app/
   ios/Runner/
4. **Run the application**:
   ```sh
   flutter run
## 🛠️ First-Time Setup for Users
1. **Sign Up / Sign In**
- Open the app and sign in using email and password.
- If you don’t have an account, tap Sign Up to create one.
2. **Browse Proverbs**
- Navigate through different chapters by selecting them from the home screen.
- Tap a chapter to see the list of verses inside.
3. **Taking Notes**
- Select a verse and tap on the Add Note button.
- Type your note and save it.
4. **Enabling Daily Proverbs Notifications**
- Go to Settings > Notifications.
- Toggle the Daily Verse Reminder switch ON.
5. **Language Selection**
- Navigate to Settings > Language.
- Choose your preferred language.
6. **Dark Mode**
- Enable dark mode in Settings > Dark Mode for a better reading experience.
## 🛠️ Troubleshooting
### ❓ App Doesn't Start After Installation
- Ensure you have Flutter installed correctly. Run:
    ```sh
    flutter doctor
  - Make sure dependencies are installed:
  ``sh
  flutter pub get
### ❓ Cannot Sign In or Sign Up
- Check your internet connection.
- Ensure Firebase Authentication is set up in the Firebase Console.
- If using email authentication, confirm that the email is valid and not already in use.
### ❓ Notes Not Saving
- Ensure that you are logged in to your account.
- Check your Firebase Firestore rules to ensure write permissions are enabled.
### ❓ Proverbs Not Loading
- Check your internet connection.
- Ensure Firebase Firestore is properly configured.
### ❓ Push Notifications Not Working
- Make sure notifications are enabled in your phone settings.
- Verify that Firebase Cloud Messaging (FCM) is set up.
## 📂 File Structure
      proverb_application/
      │── lib/                  # Main application directory  
      │   ├── Models/           # Data models (Chapter, Verse, User, etc.)  
      │   ├── services/         # Firebase and database-related services  
      │   ├── screens/          # UI Screens (Chapters, Verses, Settings, etc.)  
      │   ├── feeding data/     # data to fill on fire store
      │   ├── firebase_options.dart  # Firebase default options
      │   ├── main.dart         # Entry point of the application  
      │── assets/               # Images, icons, and Language assets  
      │── pubspec.yaml          # Dependencies and project metadata  
      │── README.md             # Project documentation  
      │── android/ & macos/ & web/ & linux/       # Native configurations for respective platforms  
### 🌍 Supported Languages
| Language |         Code | 
| :----------- |-------------:| 
| English | en |
| French| fr|
|Spanish|es|
 - To add a new language:
 - Create a JSON file in assets/lang (e.g., asset/lang/it.json for Italian).
 - Add the translated text following the format of existing language files.

 - Example (asset/lang/en.json):
     json
     {
     "hello": "Hello",
     "welcome": "Welcome to the app!",
     "settings": "Settings"
     }
 ### 🔧 Future Improvements
 - 📌 Offline Mode – Access proverbs without an internet connection.
 - 📌 Social Sharing – Share verses directly to social media.
 - 📌 Audio Proverbs – Listen to narrated proverbs.
 - 📌 More Language Support.

## 📜 License
- This project is licensed under the MIT License - see the LICENSE file for details.

## 🙌 Contributions
- Want to contribute? Follow these steps:
    1️⃣ Fork the repository.
    2️⃣ Create a new branch:
        ```sh
        git checkout -b feature-branch
    3️⃣ Make your changes and commit:
        ```sh
        git commit -m "Added new feature"
    4️⃣ Push to the branch:
        ```sh
        git push origin feature-branch
    5️⃣ Open a Pull Request.

- 📞 Contact
- 📌 Developer: Mbeumo Briand , Kpama Yves Patrick
- 📌 Email: mbeumobriand@gmail.com
- 📌 GitHub: Mbeumo


