# Johor HR Knowledge Hub

Johor HR Knowledge Hub is a high-fidelity interactive frontend prototype for a centralized HR policy and document management platform. The system allows users to search public HR documents, register and log in, manage profiles, upload and classify documents, use smart search, ask the HR chatbot, receive notifications, and manage saved documents.

This prototype is developed using **Vue.js with JavaScript** and **Vite** for the frontend, **Node.js / Express.js** for the backend, and **MySQL** for database storage.

---

## 1. Project Features

The prototype includes the following main functions:

### Public Portal

* Search HR documents by keyword
* Filter documents by category
* View public document details
* Redirect restricted documents to login/register

### Login and Registration

* User login form
* User registration form
* Password reset form
* Administrator login form
* MFA display and interaction

### Profile and Security

* View user profile
* Edit profile information
* Change notification preference
* Enable or disable MFA
* Request account deactivation

### Document Management

* Upload HR document details
* Save document as draft
* Add uploaded documents to repository
* Review AI classification suggestions
* Approve classification
* Search document repository
* Preview documents
* Archive documents
* Upload new document version

### Smart Support

* Smart document search
* HR chatbot with typed questions
* Suggested chatbot questions
* FAQ section
* Recommended documents
* Save documents into personal collection

### Notifications and Saved Documents

* View notifications
* Mark notifications as read
* Enable or disable notification settings
* Change notification frequency
* View saved documents
* Add personal notes
* Remove saved documents

### Admin Workspace

* View users
* Suspend or reactivate user accounts
* View roles and permissions
* Create new role
* View system activity logs
* Filter logs


---
## 2. GitHub Index Table: Module to Frontend Script Mapping

This index table provides a quick reference for locating the frontend implementation of each functional module in the repository. Since most frontend interfaces are implemented in one main Vue file, the main module links point to `src/App.vue`, while reusable UI components are stored in `src/components/`.

## 2. GitHub Index Table: Module to Frontend Script Mapping

This index table provides a quick reference for locating the frontend implementation of each functional module in the repository. Since most frontend interfaces are implemented in one main Vue file, the main module links point to `src/App.vue`, while reusable UI components are stored in `src/components/`.

## Subsystem 1: User and Access Management
**Developer:** Lee May Yan

| Module | Frontend Script |
|---|---|
| Guest Access Module | • [Public Portal Search Interface](src/App.vue#L62-L135)<br>• [Search Results Interface](src/App.vue#L137-L173)<br>• [Public Document Details Modal](src/App.vue#L174-L244) |
| User Registration and Login Module | • [Authentication Overview Panel](src/App.vue#L247-L269)<br>• [Login/Register/Admin Tab Navigation](src/App.vue#L270-L280)<br>• [User Login Form](src/App.vue#L282-L336)<br>• [Failed Login Protection UI](src/App.vue#L305-L324)<br>• [Failed Login Protection Logic](src/App.vue#L4106-L4212)<br>• [User Registration Form](src/App.vue#L338-L376)<br>• [Administrator Login Form](src/App.vue#L378-L411)<br>• [Password Reset Modal](src/App.vue#L413-L463)<br>• [Reset Password Logic](src/App.vue#L4272-L4296) |
| Profile Management Module | • [User Profile Display Card](src/App.vue#L466-L488)<br>• [Edit Profile Form](src/App.vue#L490-L530)<br>• [Notification Preference Dropdown](src/App.vue#L519-L526)<br>• [Account Security Settings Cards](src/App.vue#L533-L564)<br>• [Account Deactivation Request Modal](src/App.vue#L567-L607)<br>• [Change Password Modal](src/App.vue#L609-L651)<br>• [Change Password Logic](src/App.vue#L3788-L3827)<br>• [MFA Toggle Logic](src/App.vue#L4328-L4332) |
| Administrator Authentication Module | • [Administrator Login Form](src/App.vue#L378-L411)<br>• [Administrator Login Logic](src/App.vue#L4214-L4237)<br>• [Administrator Workspace Overview](src/App.vue#L2063-L2073) |
| Role and Permission Control Module | • [Role and Permission Control Interface](src/App.vue#L2140-L2170)<br>• [Create/Edit Role Modal](src/App.vue#L2172-L2213)<br>• [User Account Management Table](src/App.vue#L2216-L2268)<br>• [System Activity Logs Interface](src/App.vue#L2270-L2297)<br>• [Role Management Logic](src/App.vue#L5609-L5676)<br>• [User Status Control Logic](src/App.vue#L5596-L5607)<br>• [Activity Log Helper](src/App.vue#L4025-L4035)<br>• [Filter Logs Logic](src/App.vue#L5686-L5690) |

---

## Subsystem 2: Knowledge and Document Management
**Developer:** Lee Tung Ern

| Module | Frontend Script |
|---|---|
| Document Upload Module | • [Document Upload Interface](src/App.vue#L688-L831) |
| Document Classification and Categorization Module | • [AI Classification Review Interface](src/App.vue#L833-L947)<br>• [Classification Approval Interface](src/App.vue#L910-L945) |
| Document Storage Repository Module | • [Document Repository Table](src/App.vue#L948-L1103)<br>• [Document Preview Interface](src/App.vue#L1243-L1316)<br>• [Document Audit Trail](src/App.vue#L1323-L1358) |
| Document Search and Filter Module | • [Repository Search Interface](src/App.vue#L948-L1103)<br>• [Repository Filter Controls](src/App.vue#L962-L1003)<br>• [Repository Result Table](src/App.vue#L1007-L1103) |
| Document Update and Archive Module | • [Archive Document Modal](src/App.vue#L1106-L1154)<br>• [Upload New Version Modal](src/App.vue#L1156-L1239)<br>• [Version Management Interface](src/App.vue#L1156-L1239) |

---

## Subsystem 3: Intelligent Recommendation and Support
**Developer:** Khoo Yuan Man

| Module | Frontend Script |
|---|---|
| Smart Search Module | • [Smart Search Interface](src/App.vue#L1362-L1424)<br>• [Smart Search Results Interface](src/App.vue#L1563-L1610)<br>• [Trending Documents Interface](src/App.vue#L1754-L1781)<br>• [Frequently Used Policies Interface](src/App.vue#L1783-L1807) |
| FAQ and Knowledge Assistance Module | • [HR Chatbot Interface](src/App.vue#L1427-L1493)<br>• [Escalation Request Interface](src/App.vue#L1495-L1528)<br>• [Chatbot Conversation History Interface](src/App.vue#L1530-L1561)<br>• [FAQ Section Interface](src/App.vue#L1741-L1752)<br>• [Document Summary Generation Interface](src/App.vue#L1612-L1625) |
| Personalized Recommendation Module | • [Recommended Documents Interface](src/App.vue#L1627-L1696)<br>• [AI Document Summary Panel](src/App.vue#L1683-L1696)<br>• [Recommendation Report Interface](src/App.vue#L1698-L1738) |
| Notification and Update Alert Module | • [Notification Preferences Interface](src/App.vue#L1810-L1859)<br>• [Smart Alerts Interface](src/App.vue#L1864-L1907)<br>• [Recent Notifications Panel](src/App.vue#L1909-L1949)<br>• [User Feedback Interface](src/App.vue#L1951-L1980) |
| Saved Documents and Personal Storage Module | • [Save Favourite Documents from Search Results](src/App.vue#L1595-L1603)<br>• [Save Favourite Documents from Recommendations](src/App.vue#L1663-L1667)<br>• [Personal Storage Interface](src/App.vue#L1982-L2060)<br>• [Personal Notes Interface](src/App.vue#L1990-L2029)<br>• [Remove Favourite Document Interface](src/App.vue#L2050-L2052) |

---

## Shared Components

| Component | Frontend Script |
|---|---|
| Reusable Input Field | • [InputField Component](src/components/InputField.vue) |
| Reusable Statistic Card | • [StatCard Component](src/components/StatCard.vue) |
| Reusable Setting Card | • [SettingCard Component](src/components/SettingCard.vue) |

## 3. Technology Used

| Component               | Technology                                       |
| ----------------------- | ------------------------------------------------ |
| Frontend Framework      | Vue.js                                           |
| Programming Language    | JavaScript                                       |
| Build Tool              | Vite                                             |
| Styling                 | CSS                                              |
| Backend                 | Node.js / Express.js                             |
| Database                | MySQL                                            |
| Local Storage           | Browser localStorage for selected prototype data |
| Development Environment | Laragon, VS Code, GitHub                         |
---
Laragon is required only for local development. For the deployed version, the system uses an online backend and cloud MySQL database, so users do not need to install Laragon.

## 4. Project Structure

```text
johor-hr-hub/
├── backend/
│   ├── db.js
│   ├── server.js
│   ├── package.json
│   └── package-lock.json
├── database/
│   └── johor_hr_knowledge_hub.sql
├── index.html
├── package.json
├── package-lock.json
├── README.md
├── vite.config.js
├── public/
│   ├── favicon.svg
│   └── icons.svg
└── src/
    ├── main.js
    ├── App.vue
    ├── style.css
    └── components/
        ├── InputField.vue
        ├── StatCard.vue
        └── SettingCard.vue
```

---

## 5. Setup Instructions

### Step 1: Install Required Software

Make sure the following software is installed:

```text
Node.js
npm
Git
Laragon
MySQL
VS Code
```

Check Node.js and npm using:

```bash
node -v
npm -v
```

---

### Step 2: Clone the Repository

Open Laragon Terminal or Command Prompt and go to the Laragon `www` folder:

```bash
cd C:\laragon\www
```

Clone the repository:

```bash
git clone https://github.com/yuanman1021/AD15_Aespa.git
```

Open the project folder:

```bash
cd AD15_Aespa
```

---

### Step 3: Start Laragon and MySQL

Open Laragon and click:

```text
Start All
```

Make sure MySQL is running.

---

### Step 4: Import the Database

In the project folder, open terminal and enter MySQL:

```bash
mysql -u root
```

Create the database:

```sql
CREATE DATABASE johor_hr_knowledge_hub;
EXIT;
```

Import the SQL file:

```bash
mysql -u root johor_hr_knowledge_hub < database\johor_hr_knowledge_hub.sql
```

To check whether the database was imported successfully:

```bash
mysql -u root
```

Then run:

```sql
USE johor_hr_knowledge_hub;
SHOW TABLES;
EXIT;
```

---

### Step 5: Install and Run Backend

Open a terminal for the backend:

```bash
cd C:\laragon\www\AD15_Aespa\backend
npm install
npm run dev
```

The backend should run at:

```text
http://localhost:3000
```

Keep this terminal open.

---

### Step 6: Install and Run Frontend

Open another terminal for the frontend:

```bash
cd C:\laragon\www\AD15_Aespa
npm install
npm run dev
```

The frontend should run at:

```text
http://localhost:5173
```

Open the link in a browser.

---

---

## 6. Login Data / Test Accounts

Only the predefined prototype accounts listed below can log in to the system.

For demonstration purposes, the password validation is simplified. Users may enter any password as long as it contains at least 8 characters. For MFA verification, users may enter any 6-digit code.

Example login input:

```text
Password: 12345678
MFA Code: 123456
```

| Name | Email | Role | Account Status | Login Access |
|---|---|---|---|---|
| Nur Aina Rahman | aina@johor.gov.my | Registered User | Active | User Login |
| Daniel Tan | daniel@johor.gov.my | Registered User | Suspended | Cannot log in unless reactivated |
| Tung Ern | tungern@johor.gov.my | Registered User | Active | User Login |
| May Yan | mayyan@johor.gov.my | Administrator | Active | Administrator Login |
| Yuan Man | yuanman@johor.gov.my | Administrator | Active | Administrator Login |

Notes:

```text
1. Registered User accounts can access the normal user workspace.
2. Administrator accounts can access the administrator workspace.
3. Suspended accounts are blocked from logging in until reactivated by an administrator.
4. Any 8-character password is accepted for prototype demonstration.
5. Any 6-digit MFA code is accepted for prototype demonstration.
```

## 7. Important Note About Laragon

Laragon is required for this prototype because the backend connects to a MySQL database.

The database connection is configured in:

```text
backend/db.js
```

Default database settings:

```text
Host: localhost
User: root
Password: empty
Database: johor_hr_knowledge_hub
```

Make sure Laragon MySQL is running before starting the backend server.

---

## 8. Data Storage

This prototype uses both MySQL and browser localStorage.

MySQL is used for backend-connected data such as:

```text
Documents
Recommendations
FAQs
Notifications
Chatbot conversations
Escalation requests
```

Browser localStorage is used for selected prototype interactions such as:

```text
Temporary UI data
Prototype logs
Saved browser state
Some user interface changes
```

To reset browser prototype data:

1. Open the system in the browser.
2. Press `F12`.
3. Go to the **Application** tab.
4. Open **Local Storage**.
5. Delete the related `jhr_` data items.
6. Refresh the page.

To reset database data, re-import:

```bash
mysql -u root johor_hr_knowledge_hub < database\johor_hr_knowledge_hub.sql
```


## 9. Developer

```text
Project: Johor HR Knowledge Hub
Group: Aespa

Subsystem 1: User and Access Management
Developer: Lee May Yan

Subsystem 2: Knowledge and Document Management
Developer: Lee Tung Ern

Subsystem 3: Intelligent Recommendation and Support
Developer: Khoo Yuan Man
```
## Deployment / Future Development Notes

This project includes a Vue frontend, Node.js/Express backend and MySQL database. 
For local development, create environment files based on .env.example and backend/.env.example.

The AI-related features in this prototype, such as HR chatbot, smart search and document recommendation, are prototype interface features only. The actual AI model integration has not been fully developed.