# My Personal Library — JSP Edition

A personal reading tracker built with **JavaServer Pages (JSP)**, **Servlets**, **JDBC**, and **MySQL**.
Developed for **EF234301 Web Programming — Quiz 2**. Based on an earlier Laravel/PHP Midterm project, rebuilt in JSP.

**Live demo:** https://mercvex.alwaysdata.net/

---

## Features

| # | Feature | CRUD |
|---|---|---|
| 1 | User Accounts | Register, View Profile, Edit Name/Email, Change Password, Delete Account |
| 2 | Authors | Add, List, View, Edit, Delete |
| 3 | Categories | Add, List, View, Edit, Delete |
| 4 | Books | Add (with cover image + PDF/TXT upload), List, Search, Filter, View, Edit, Delete |
| 5 | Book Notes | Write, View, Edit, Delete private notes per book |
| 6 | Reading Logs | Log sessions (date + pages), View, Edit, Delete |
| 7 | Reading Goals | Create goals (count or finish-book type), View, Edit, Toggle Complete, Delete |
| 8 | Favorites | Add, View, Remove |
| + | Dashboard | Aggregated stats, recent books, recent logs, favorites, progress |
| + | In-Browser Reader | Stream PDF/TXT book files through an authenticated protected route |

---

## Technology Stack

| Layer | Technology |
|---|---|
| Backend | Java 17, Servlet 4.0 (`javax.servlet`), JSP 2.3 (JSTL 1.2) |
| Database | MySQL 8.0.16+ |
| DB Connectivity | JDBC (`mysql-connector-j`) |
| Password Hashing | jBCrypt |
| File Uploads | Servlet multipart (`Part` API) |
| Frontend | HTML5, CSS3 (custom), vanilla JS |
| Build | Maven, WAR packaging |
| Server | Apache Tomcat 9.0 (Servlet 4.0 / JSP 2.3) |

---

## Project Structure

```
quiz-2-webpro/
├── pom.xml
├── sql/
│   └── my_personal_library.sql      ← Full DB schema
└── src/main/
    ├── resources/
    │   ├── db.properties.example    ← Template (copy to db.properties)
    │   └── db.properties            ← Your real credentials (git-ignored)
    ├── java/com/mylibrary/
    │   ├── dao/                     ← JDBC Data Access Objects
    │   ├── filter/                  ← AuthFilter
    │   ├── listener/                ← AppStartupListener (creates upload dirs)
    │   ├── model/                   ← Plain Java model classes
    │   ├── servlet/                 ← Servlet controllers
    │   └── util/                    ← DBConnection, PasswordUtil, FileUploadUtil, UploadConfig
    └── webapp/
        ├── css/app.css
        ├── js/app.js
        ├── images/
        └── WEB-INF/
            ├── web.xml
            └── jsp/                 ← All JSP views
```

Uploaded files (covers and book files) are stored **outside** the web root, in a directory configured at runtime (see step 4).

---

## Local Setup

### Prerequisites
- Java 17+
- Maven 3.8+
- Apache Tomcat 9.0.x
- MySQL 8.0.16+

### 1. Clone the repository

```bash
git clone https://github.com/Mercvex/quiz-2-webpro.git
cd quiz-2-webpro
```

### 2. Create the database

```bash
mysql -u root -p < sql/my_personal_library.sql
```

This creates the database `my_personal_library_jsp` and all tables.

### 3. Configure database credentials

Copy the template and fill in your own values:

```bash
# Linux / macOS / Git Bash
cp src/main/resources/db.properties.example src/main/resources/db.properties

# Windows PowerShell
Copy-Item src\main\resources\db.properties.example src\main\resources\db.properties
```

Then edit `src/main/resources/db.properties`:

```properties
db.url=jdbc:mysql://localhost:3306/my_personal_library_jsp?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
db.username=YOUR_DATABASE_USERNAME
db.password=YOUR_DATABASE_PASSWORD
db.driver=com.mysql.cj.jdbc.Driver
```

`db.properties` is listed in `.gitignore` and must never be committed.

### 4. Configure the upload directory

The app needs a writable directory outside the webapp root. The subfolders `covers/` and `books/` are created automatically on first startup.

The upload directory is resolved in this order:

| Priority | Source | Example |
|---|---|---|
| 1 | Environment variable `UPLOAD_DIR` | `export UPLOAD_DIR=/var/mylibrary/uploads` |
| 2 | JVM system property `-DuploadDir` | `JAVA_OPTS="-DuploadDir=/var/mylibrary/uploads"` |
| 3 | `web.xml` context-param `uploadDir` | absolute path in `<param-value>` |
| 4 | Default (no config needed) | `<user.home>/mylibrary/uploads` |

On Windows the default is typically `C:\Users\<YourName>\mylibrary\uploads`.

> The Tomcat process user must have read/write permission on the upload directory.

### 5. Build and deploy

```bash
mvn clean package
```

The build produces `target/ROOT.war` (the artifact name is set to `ROOT` in `pom.xml`, so the app is served at the root path).

Copy it to Tomcat (remove the default `webapps/ROOT` folder first), then start Tomcat:

```bash
rm -rf /path/to/tomcat/webapps/ROOT
cp target/ROOT.war /path/to/tomcat/webapps/
/path/to/tomcat/bin/startup.sh
```

Open: **http://localhost:8080/**

### 6. Register the first account

Go to `/register` and create an account. Optional sample data is available as commented `INSERT` statements at the bottom of `sql/my_personal_library.sql`.

---

## Serving cover images

Cover images are served by `CoverServlet`, mapped to `/covers/*`. It reads files from `<uploadDir>/covers/`, rejects path traversal, and only serves jpg, jpeg, png, and webp. No Tomcat alias configuration is needed.

`/covers/*` is protected by `AuthFilter`: unauthenticated users are redirected to `/login`.

---

## Security notes

- All database queries use `PreparedStatement` (protects against SQL injection).
- Passwords are hashed with BCrypt (work factor 12).
- Book files are streamed through an authenticated servlet route; the file path is never exposed.
- Book, note, log, goal, and favorite operations are scoped by `user_id`.
- `AuthFilter` redirects unauthenticated requests to `/login`.
- Database credentials live in `db.properties`, which is git-ignored.

---

## Deployment

Hosted on alwaysdata (free plan): Tomcat 9 + MariaDB. The project uses the `javax.*` namespace because Tomcat 9 implements Servlet 4.0. Free plan limits (256 MB RAM) are handled by capping the JVM heap via `CATALINA_OPTS`.

---

## Team

| Name | Student ID | Contribution |
|---|---|---|
| _(fill in)_ | _(fill in)_ | _(fill in)_ |

---

## License

University project — for educational use.
