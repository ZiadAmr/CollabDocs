from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.middleware.cors import CORSMiddleware
from typing import Annotated
from datetime import timedelta

import security
import database
import config
app = FastAPI()

origins = [
    "http://localhost:5173"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins, # a list of origins that should be premitted to make cross-origins request 
    allow_credentials=True, #  Indicate that cookies should be supported for cross-origin requests
    allow_methods=["*"], #  A list of HTTP methods that should be allowed for cross-origin requests
    allow_headers=["*"] # A list of HTTP request headers that should be supported for cross-origin requests
)

@app.post("/token")
async def login_for_access_token(form_data: Annotated[OAuth2PasswordRequestForm, Depends()]) -> database.Token:
    user = security.authenticate_user(database.fake_users_db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"}
        )
    access_token_expires = timedelta(minutes=config.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = security.create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires # The JWT specification says that there's a key sub, with the subject of the token. We use it to store users identification
    )
    return database.Token(access_token=access_token, token_type="bearer")

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.get('/documents')
async def documents(current_user: Annotated[database.User, Depends(database.get_current_active_user)]):
    return {"username": current_user.username}
