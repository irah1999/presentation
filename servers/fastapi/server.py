import uvicorn
import argparse
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from pathlib import Path

# Initialize the FastAPI app
app = FastAPI()

# --- DEFENSIVE PATH SETUP ---
# 1. Get the directory where THIS Python file (main.py) is located
BASE_DIR = Path(__file__).resolve().parent

# 2. Construct the absolute path to your 'static' folder
# This will be: /home/harikrishnan.y/Desktop/reactJs/ppt/servers/fastapi/static
STATIC_DIR = BASE_DIR / "static"

# 3. Verify the static directory exists (optional, but great for debugging)
if not STATIC_DIR.is_dir():
    print(f"Error: Static directory not found at {STATIC_DIR}")
    # You might want to raise an exception or exit if the path is critical

# 4. Mount the StaticFiles using the ABSOLUTE PATH
app.mount(
    # The URL prefix for access (must be exactly /static to match your request)
    "/static", 
    
    # Use the absolute path calculated above
    StaticFiles(directory=STATIC_DIR), 
    
    name="static_files"
)

# Optional: A simple root route to verify the server is running
@app.get("/")
def read_root():
    return {"message": "FastAPI Server is running and static files are mounted."}

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run the FastAPI server")
    parser.add_argument(
        "--port", type=int, required=True, help="Port number to run the server on"
    )
    parser.add_argument(
        "--reload", type=str, default="false", help="Reload the server on code changes"
    )
    args = parser.parse_args()
    reload = args.reload == "true"
    
    uvicorn.run(
        "api.main:app",
        host="127.0.0.1",
        port=args.port,
        log_level="info",
        reload=reload,
    )
