# Sistema de Anúncios de Imóveis

Projeto desenvolvido como parte do processo seletivo na etapa de teste técnico.<br/>
Prazo de 2 dias para o desenvolvimento e entrega.

## Stack

| Camada         | Tecnologia                         |
|----------------|------------------------------------|
| Backend (main) | Go                                 | 
| Backend (auth) | Java (Spring Boot)                 |
| Frontend       | Dart (Flutter)                     | 
| Banco de Dados | PostgreSQL                         | 
| DevOps         | Docker, Docker Compose, Dockerfile |   
| Testes         | Go Test, Flutter Test, BLoC test   |

## Execução

### 1. Clone

```bash
git clone https://github.com/WillianSalceda/teste_tecnico_vr_software.git
cd teste_tecnico_vr_software
```

### 2. Configuração (.env)

Já configurado por padrão para testes, altere conforme julgar necessário.

#### Raiz do projeto (`.env`)

Usado pelo `docker-compose` para os serviços backend e auth:

```env
# Backend
PORT=8080
BASE_URL=http://localhost:8080
DATABASE_URL=postgres://postgres:postgres@postgres:5432/realestate?sslmode=disable
JWT_SECRET=<string-secreta-para-jwt>

# Auth Service
AUTH_PORT=9090
JWT_EXPIRATION_MS=86400000
```

#### Frontend (`frontend/.env`)

Usado pela aplicação Flutter para as URLs das APIs:

```env
API_BASE_URL=http://localhost:8080
AUTH_API_BASE_URL=http://localhost:9090
```

### 3. Subir o ambiente (Docker Compose)

Da raiz do projeto:

```bash
docker-compose up -d
```

**Importante:** O build inclui a execução dos testes do backend. Se algum teste falhar, o build será interrompido.

| Serviço     | URL                                                             |
|-------------|-----------------------------------------------------------------|
| API Go      | http://localhost:8080                                           |
| Swagger     | http://localhost:8080/swagger/index.html                        |
| Auth (Java) | http://localhost:9090                                           |
| PostgreSQL  | localhost:5432 (user: postgres, pass: postgres, db: realestate) |

### 4. Rodar o frontend

```bash
cd frontend
flutter pub get
flutter run -d windows
```

#### Internacionalização (i18n)

O idioma é definido através do `--dart-define` no run:

```bash
# Português
flutter run -d windows --dart-define=FLUTTER_LOCALE=pt

# Inglês (padrão)
flutter run -d windows --dart-define=FLUTTER_LOCALE=en
```

### Desenvolvimento local (opcional)

#### Backend (Go)

```bash
cd backend
go mod tidy
go run .
```

#### Auth (Java)

```bash
cd auth-service
mvn spring-boot:run
```

Credenciais de demonstração: `admin` / `admin123`

### Testes

#### Backend

```bash
cd backend
go test ./...
```

#### Frontend

```bash
cd frontend
flutter test
```

## Decisões técnicas

- **Clean Architecture**: domínio isolado, use cases testáveis, infra plugável.
- **TDD**: testes unitários antes/paralelo na implementação de casos críticos.
- **PLoC**: gerenciamento de estado e orquestrador de UI.
- **Segurança**: Auth + JWT em APIs, deslogar ao receber 401 (token expirado), CORS configurado, validações de inputs,
  senhas em memória apenas para demo (auth).

### Como assim PLoC?

BLoC não é só um package, mas também um padrão. Ele é utilizado para tratar de lógica de negócio (daí o termo BLoC,
Business Logic Component). Na prática, estamos utilizando ele mais como um "PLoC" (Presentation Logic Component). Ele
coordena o fluxo de dados entre UI e casos de usos, e esses sim que lidam com regras de negócio (ao nível do frontend,
claro).

### Por que uma arquitetura robusta para um teste?

Duas motivações: demonstração da minha capacidade de atuar com arquiteturas mais complexas **e**, no mundo real, em
teoria um projeto desse teria um grande escopo, necessitando de escalabilidade e um código de fácil manutenção e "
incrementação".

No geral, utilizaria uma arquitetura menos robusta para projetos médios, e algo ainda mais simples e direto para MVPs ou
projetos que não possuam quaisquer perspectivas de crescimento.

### O backend poderia seguir uma estrutura melhor, pensando em escalabilidade no futuro?

Sim. Os padrões adotados para o backend foram com a intenção de mantê-lo robusto mas, ao mesmo tempo, simples.
Poderíamos por exemplo pensar em uma separação modular (assim como foi feito no frontend), DDD, design patterns, etc.

### Isso significa que a adoção desses padrões arquiteturais é o ideal?

**De forma alguma!**
O padrão arquitetural ideal é aquele que a empresa já segue, que o time está confortável em atuar e/ou aquele que
é moldado especificamente para cada projeto, que melhor se adapta para a solução a ser criada.
