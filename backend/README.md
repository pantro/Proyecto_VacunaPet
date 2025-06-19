# 📍 Backend de Rastreo GPS

Este es el backend para una aplicación que rastrea en tiempo real la ubicación GPS de dispositivos móviles.  
Está construido con **NestJS**, **GraphQL**, **Prisma** y **PostgreSQL**.

---

## 🚀 Tecnologías utilizadas

- [NestJS](https://nestjs.com/) — Framework backend para Node.js
- [GraphQL](https://graphql.org/) — API flexible y eficiente
- [Prisma](https://www.prisma.io/) — ORM moderno para trabajar con PostgreSQL
- [PostgreSQL](https://www.postgresql.org/) — Base de datos relacional
- [Apollo Server](https://www.apollographql.com/docs/apollo-server/) — Motor GraphQL para NestJS

---

## Comando utilizados en todo el proyecto

### Crear la base de datos en posgresql
Para empezar primero verificamos que tengas el servicio y la base de datos
- $ sudo service postgresql start # levantar el servicio
- $ sudo -u postgres psql # Ingresamos posgresql

-- Dentro de psql:

CREATE USER admin_name WITH PASSWORD 'admin_pass';

-- 1. Crear una base de datos nueva donde el dueño es admin_name

DROP DATABASE IF EXISTS db_name;
CREATE DATABASE db_name OWNER admin_name;

-- 2. Conectarse a esa nueva base

\c db_name

-- 3. Dar permisos sobre el esquema public

ALTER SCHEMA public OWNER TO admin_name;

GRANT ALL ON SCHEMA public TO admin_name;

GRANT USAGE, CREATE ON SCHEMA public TO admin_name;

-- 4. Conceder privilegios por defecto a futuro

ALTER DEFAULT PRIVILEGES IN SCHEMA public

GRANT ALL ON TABLES TO admin_name;

ALTER DEFAULT PRIVILEGES IN SCHEMA public

GRANT ALL ON SEQUENCES TO admin_name;

ALTER USER admin_name CREATEDB;

\q

### Crear el proyecto con nestjs y Graphsql
- $ nest new b_vaccinepet --skip-git
- $ cd b_vaccinepet

### Instala GraphQL + Apollo + herramientas:
- $ npm install @nestjs/graphql @nestjs/apollo graphql @apollo/server
- $ npm install @prisma/client
- $ npm install @nestjs/config
- $ npm install graphql-tools
- $ npm install --save-dev prisma

### Configurar Prisma y PostgreSQL
- $ npx prisma init

* Edita el archivo .env:
    DATABASE_URL="postgresql://usuario:contraseña@localhost:5432/db_name"

- $ npx prisma migrate dev --name init
- $ npx prisma generate

### Conectar Prisma con NestJS
- $ nest g module prisma
- $ nest g service prisma

* configura(ingresa codigo) el servicio (prisma.service.ts)
* Configura(ingresa codigo) prisma.module.ts

### Configurar GraphQL
* Configurar(ingresa codigo) app.module.ts

### Subscriptions con GraphQL + WebSocket
- $ npm install graphql-subscriptions@2 @nestjs/graphql
- $ npm install @nestjs/websockets @nestjs/platform-socket.io

* Configurar pubsub.ts

---

## 📦 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/
cd backend

# Instalar dependencias
npm install
