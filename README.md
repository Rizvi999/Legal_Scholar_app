Legal Scholar App
The Legal Scholar App is a powerful tool designed to provide quick access to legal information, such as laws, statutes, and legal sections. Using AI technology, it answers queries related to specific legal topics and provides relevant information based on user input. The app is built to streamline access to legal knowledge, enabling users to easily search and retrieve detailed legal data.

Features
AI-Powered Legal Search: Ask questions and get answers about specific laws or legal sections.
Query History: Keep track of your previous searches for future reference.
Intuitive UI: Simple and user-friendly interface for easy navigation.
Real-Time Results: Instant responses powered by AI and integrated with a robust backend system.
Technologies Used
Frontend: Flutter
Backend: Firebase
Database: Firebase Firestore & SQL for structured data storage
Search Integration: Custom search engine configuration using Firebase
AI Integration: Custom AI model for answering legal queries

Installation and Setup
To get started with the Legal Scholar App project, follow the steps below to install the required dependencies and set up the necessary configurations.

Step 1: Clone the Repository
Clone this repository to your local machine:


paste this in terminal
git clone https://github.com/Rizvi999/Legal_Scholar_app.git
Navigate into the project directory:


Copy code
cd Legal_Scholar_app
Step 2: Install Dependencies
Make sure that you have Flutter installed on your machine. If not, you can follow the official Flutter installation guide here.

Once you have Flutter installed, run the following command to install the project dependencies:

bash
Copy code
flutter pub get
This will fetch the necessary packages from pub.dev. Below are the dependencies used in the Legal Scholar App:

yaml
Copy code
dependencies:
  flutter:
    sdk: flutter

  # Cupertino Icons for iOS style icons
  cupertino_icons: ^1.0.8

  # Firebase Auth for authentication
  firebase_auth: ^5.3.1

  # Logger for logging events and activities
  logger: ^2.4.0

  # Firebase Core for Firebase initialization
  firebase_core: ^3.6.0

  # Firebase Database for realtime database functionality
  firebase_database: 11.1.4

  # HTTP package for making HTTP requests
  http: 1.2.2

  # Logging package for app events
  logging: ^1.2.0

  # URL Launcher for opening URLs in a browser
  url_launcher: ^6.3.0

  # Google Generative AI for AI-powered responses
  google_generative_ai: ^0.4.6

  # Flutter Dotenv for environment variable management
  flutter_dotenv: ^5.0.5

  # Google Fonts for custom fonts
  google_fonts: ^6.2.1

  # Flutter Animate for animations
  flutter_animate: ^4.5.0
Step 3: Set Up Firebase and Create API Key
For Firebase integration, follow the steps below:

1. Create a Firebase Project:
Go to the Firebase Console.
Create a new Firebase project or select an existing one.
Add an Android/iOS app to the Firebase project, depending on your platform.

2. Add Firebase SDK to Your App:
For Android, download the google-services.json file and place it in the android/app/ directory of your Flutter project.
For iOS, download the GoogleService-Info.plist file and add it to the ios/Runner/ directory.

3. Enable Required Firebase Services:
Enable Firebase Authentication, Realtime Database, or Firestore (depending on what your app uses) in the Firebase Console.

4. Generate an API Key for Google Generative AI:

Visit the Google Cloud Console.
Create a new project or use an existing one.
Enable the "Google Generative AI" API.
Go to APIs & Services > Credentials and create an API key.

Add the API key to the .env file in your project (or environment configuration) using the flutter_dotenv package. Example:

makefile
Copy code
GOOGLE_API_KEY=your_api_key_here

Step 4: Run the App
Once the dependencies are installed and your Firebase and API keys are set up:


Copy code
flutter run
Your app should now be up and running on the simulator or your physical device.





Acknowledgements
Firebase for backend and database management.
Flutter for building the cross-platform mobile app.
Google Generative AI for powering legal search functionality.
Various Flutter packages for seamless integration and app performance.

