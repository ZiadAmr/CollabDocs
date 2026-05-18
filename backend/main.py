from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from dotenv import load_dotenv
import os

load_dotenv()
db_url = os.getenv("DATABASE_URL")

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

@app.get("/health")
def health():
    return {"status": "ok"}
