# 📄 Accessible PDF Report Generator – Proof of Concept

## 🧩 Overview

This proof-of-concept (PoC) application enables the GACPD Data Team to generate **accessible PDF reports** from XML data. These reports are intended for publication on the outward-facing website. The app uses **Apache FOP** to transform XML + XSL into PDF, and is built with a **React frontend** and **Node.js backend**, both containerized with Docker.

---

## 🚀 Features

- Upload XML files and generate accessible PDFs.
- Select report type (currently the only active input).
- Download the generated PDF with a custom filename and location.
- Fully containerized with Docker and Docker Compose.
- Future-ready for database integration and dynamic dropdowns.

---

## 🛠️ Tech Stack

| Layer       | Technology                     |
|------------|---------------------------------|
| Frontend   | React, Material UI (MUI)        |
| Backend    | Node.js, Apache FOP (Java)      |
| Container  | Docker, Docker Compose          |
| PDF Engine | Apache FOP 2.10                 |

---

## 🧱 Architecture

```
[React Frontend] --> [Node.js Backend] --> [Apache FOP] --> [PDF Output]
       ↑                                                      ↓
   User selects options, uploads XML                    PDF returned to UI
```

---

## 🧪 Current Functionality

### Frontend
- Inputs:
  - `reportType` (used)
  - `effectiveDate`, `program`, `crosswalkDescription` (not yet functional)
- Upload XML file (future state Query database for XML)
- Sends XML + reportType to backend
- Displays and downloads the generated PDF

### Backend
- Receives XML and reportType
- Uses Apache FOP with a corresponding XSL stylesheet
  - XSL stylesheet generates list tags as needed
- Generates accessible PDF and returns it to the frontend


## 📁 Project Structure

```
/frontend
  ├── React app with MUI components
  └── Dockerfile 
  
/backend
  ├── Node.js server
  ├── fop-2.10/ (Apache FOP)
  ├── stylesheets (xsl)
  └── Dockerfile (installs Java + FOP)
/sql-scripts
  └── SQL script to generate XML from database
/docker-compose.yml
```

---

## 🔮 Future Enhancements

- Connect backend to SQL database to auto-generate XML
- Populate dropdowns dynamically from database
- Add validation and error handling for XML structure
- Support additional report types and stylesheets (Prepublication, Field Review, Clean Report)

---

## 👥 Intended Audience
This app is designed for **internal use by the GACPD Data Team** to streamline the creation of accessible reports for public distribution.
