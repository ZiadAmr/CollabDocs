# CollabDocs

## Backend

### How to run
```
    .\venv\Scripts\activate
    make dev-backend
```

## Frontend

### How to run
```
    cd frontend
    npm run dev
```
Untested, but on Linux you might be able to use `make dev-frontend` without `cd`

# Testing
## Backend

```
    fastapi dev
```

## Requirements

To update requirements after installing new dependencies `pip freeze > requirements.txt`

## ToDo:

- Define Database
- Test `make migrate-create MSG="message"`
- Test subsequent make commands
- Security (Authentication)