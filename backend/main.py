from fastapi import FastAPI
from interview_engine import router

app = FastAPI()

app.include_router(router)
