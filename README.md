# Support Ticketing System Backend

**Ruby on Rails** backend API for managing customer support tickets, agent workflows, and communication between customers and support agents.

---

## Features

- Customer ticket creation
- Agent management of tickets and comments
- Customer follow-up comments (only after an agent reply)
- Daily email reminders for agents with open tickets
- GraphQL API

---

## Prerequisites

- **Ruby** >= 3.2
- **Rails** >= 7.1 or 8
- **PostgreSQL** or **SQLite**
- **Node.js** (for any frontend assets)
- SMTP credentials for sending emails

---

## Installation & Setup

### Clone the Repository

```bash
git clone git@github.com:OjerIsaac/support_ticketing_system_backend.git
cd support_ticketing_system_backend
````

---

### Install Dependencies

```bash
bundle install
```

---

### Set Up Environment Variables

Create `.env`:

```dotenv
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_DOMAIN=yourdomain.com
```

---

### Database Setup

Create and migrate:

```bash
rails db:create
rails db:migrate
```

---

### Seed the Database

```bash
rails db:seed
```

---

### Start the Server

```bash
rails server
```

Visit [http://localhost:3000](http://localhost:3000).

---

## Sending Daily Email Reminders

Manually trigger daily reminders for all agents:

```bash
rails tickets:send_daily_reminders
```

---

## GraphQL

GraphQL endpoint:

```
POST /graphql
```

Use GraphiQL in development:

```
http://localhost:3000/graphiql
```

---
