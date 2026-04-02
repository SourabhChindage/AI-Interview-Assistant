# 🤖 AI Interview Assistant

An AI-powered mobile application that simulates real technical interviews by generating dynamic questions and providing intelligent feedback based on user responses.

---

## 🚀 Features

- 🎯 Subject-based interview sessions (Flutter, Java, DBMS, etc.)
- 🧠 AI-generated dynamic questions (context-aware)
- 🎤 Voice input using Speech-to-Text
- 🔊 Text-to-Speech for questions
- 📊 AI-generated detailed feedback after interview
- 🔄 Adaptive difficulty (based on user answers)
- 📱 Clean and modern Flutter UI

---

## 🛠️ Tech Stack

### Frontend
- Flutter
- Dart
- Speech-to-Text
- Flutter TTS

### Backend
- FastAPI (Python)
- OpenRouter API (LLM integration)
- REST APIs (JSON-based communication)

---

## ⚙️ How It Works

1. User selects a subject and starts interview  
2. AI generates the first question  
3. User answers via voice input  
4. AI analyzes response and asks next question  
5. Process continues dynamically  
6. At the end, AI generates structured feedback report  

---

## 📦 Installation & Setup

### 🔹 Backend (FastAPI)

# Install dependencies
pip install fastapi uvicorn requests

# Run server
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

### 🔹 Frontend (Flutter)

flutter pub get
flutter run

---

## 🌐 Configuration

Update your backend IP in:

ApiService.dart

static const String baseUrl = "http://YOUR_IP:8000";

⚠️ Make sure your mobile and backend are on the same network.

---

---

## 📊 Sample Feedback Output

- Overall Performance Summary  
- Strengths & Weaknesses  
- Communication Skills  
- Confidence Level  
- Final Rating  
- Actionable Suggestions  

---

## 🔐 Notes

- Do NOT expose your API keys publicly  
- Use environment variables for backend secrets  

---

## 📌 Future Improvements

- User authentication  
- Interview history tracking  
- Multiple domains (HR, Aptitude, System Design)  
- Cloud deployment  
- Performance analytics dashboard  

---

## 👨‍💻 Author

Sourabh Chindage

---

## ⭐ If you like this project

Give it a ⭐ on GitHub!
