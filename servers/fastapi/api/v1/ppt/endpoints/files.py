from http.client import HTTPException
import os
from typing import Annotated, List, Optional
from fastapi import APIRouter, Body, File, UploadFile
from pydantic import BaseModel

from constants.documents import UPLOAD_ACCEPTED_FILE_TYPES
from models.decomposed_file_info import DecomposedFileInfo
from services.temp_file_service import TEMP_FILE_SERVICE
from services.documents_loader import DocumentsLoader
import uuid
from utils.validators import validate_files

class FilePathPayload(BaseModel):
    filePath: str

# 3. Define the Response Structure (Optional but good practice)
class FileContentResponse(BaseModel):
    content: str

FILES_ROUTER = APIRouter(prefix="/files", tags=["Files"])

@FILES_ROUTER.post("/read-file", response_model=FileContentResponse)
def read_file_content(payload: FilePathPayload):
    file_path = payload.filePath
    print(f"Reading file at path: {file_path}")
    
    # Optional: Basic security and validation check
    # Check if the file exists and is actually a file (not a directory)
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail=f"File not found at path: {file_path}")
        
    if not os.path.isfile(file_path):
        raise HTTPException(status_code=400, detail=f"Path is not a valid file: {file_path}")

    # Check if the extension is .txt
    if not file_path.lower().endswith(".txt"):
        # You might want to allow it and just log a warning, 
        # or enforce strictly and raise an exception as shown below.
        raise HTTPException(status_code=400, detail="Only .txt extension files are supported.")

    try:
        # 'r' mode for reading, default encoding is usually fine for text files
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # 5. Return the file content wrapped in the defined response model
        return FileContentResponse(content=content)

    except IOError as e:
        # Handle exceptions related to reading the file (e.g., permission denied)
        raise HTTPException(status_code=500, detail=f"Error reading file: {e}")
    except Exception as e:
        # Handle any other unexpected errors
        raise HTTPException(status_code=500, detail=f"An unexpected error occurred: {e}")


@FILES_ROUTER.post("/upload", response_model=List[str])
async def upload_files(files: Optional[List[UploadFile]]):
    if not files:
        raise HTTPException(400, "Documents are required")

    temp_dir = TEMP_FILE_SERVICE.create_temp_dir(str(uuid.uuid4()))

    validate_files(files, True, True, 100, UPLOAD_ACCEPTED_FILE_TYPES)

    temp_files: List[str] = []
    if files:
        for each_file in files:
            temp_path = TEMP_FILE_SERVICE.create_temp_file_path(
                each_file.filename, temp_dir
            )
            with open(temp_path, "wb") as f:
                content = await each_file.read()
                f.write(content)

            temp_files.append(temp_path)

    return temp_files


@FILES_ROUTER.post("/decompose", response_model=List[DecomposedFileInfo])
async def decompose_files(file_paths: Annotated[List[str], Body(embed=True)]):
    temp_dir = TEMP_FILE_SERVICE.create_temp_dir(str(uuid.uuid4()))

    txt_files = []
    other_files = []
    for file_path in file_paths:
        if file_path.endswith(".txt"):
            txt_files.append(file_path)
        else:
            other_files.append(file_path)

    documents_loader = DocumentsLoader(file_paths=other_files)
    await documents_loader.load_documents(temp_dir)
    parsed_documents = documents_loader.documents

    response = []
    for index, parsed_doc in enumerate(parsed_documents):
        file_path = TEMP_FILE_SERVICE.create_temp_file_path(
            f"{uuid.uuid4()}.txt", temp_dir
        )
        parsed_doc = parsed_doc.replace("<br>", "\n")
        with open(file_path, "w") as text_file:
            text_file.write(parsed_doc)
        response.append(
            DecomposedFileInfo(
                name=os.path.basename(other_files[index]), file_path=file_path
            )
        )

    # Return the txt documents as it is
    for each_file in txt_files:
        response.append(
            DecomposedFileInfo(name=os.path.basename(each_file), file_path=each_file)
        )

    return response


@FILES_ROUTER.post("/update")
async def update_files(
    file_path: Annotated[str, Body()],
    file: Annotated[UploadFile, File()],
):
    with open(file_path, "wb") as f:
        f.write(await file.read())

    return {"message": "File updated successfully"}
