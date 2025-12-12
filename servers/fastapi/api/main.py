from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.lifespan import app_lifespan
from api.middlewares import UserConfigEnvUpdateMiddleware
from api.v1.ppt.router import API_V1_PPT_ROUTER
from api.v1.webhook.router import API_V1_WEBHOOK_ROUTER
from api.v1.mock.router import API_V1_MOCK_ROUTER
from fastapi.staticfiles import StaticFiles


app = FastAPI(lifespan=app_lifespan)

app.mount("/static", StaticFiles(directory="static"), name="static")
app.mount("/tmp", StaticFiles(directory="tmp"), name="tmp")
app.mount("/app_data", StaticFiles(directory="app_data"), name="app_data")

@app.get("/")
def read_root():
    return {"message": "FastAPI Server is running and static files are mounted."}

# Routers
app.include_router(API_V1_PPT_ROUTER)
app.include_router(API_V1_WEBHOOK_ROUTER)
app.include_router(API_V1_MOCK_ROUTER)

# Middlewares
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(UserConfigEnvUpdateMiddleware)
