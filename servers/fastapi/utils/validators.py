from typing import List
from fastapi import HTTPException

from fastapi import UploadFile


def validate_files(
    field,
    nullable: bool,
    multiple: bool,
    max_size: int,
    accepted_types: List[str],
):

    if field:
        files: List[UploadFile] = field if multiple else [field]
        for each_file in files:
            # Safely get file size
            file_size = 0
            if hasattr(each_file, "size") and each_file.size is not None:
                file_size = each_file.size
            else:
                each_file.file.seek(0, 2)
                file_size = each_file.file.tell()
                each_file.file.seek(0)

            if (max_size * 1024 * 1024) < file_size:
                raise HTTPException(
                    400,
                    detail=f"File '{each_file.filename}' exceeded max upload size of {max_size} MB",
                )
            elif each_file.content_type not in accepted_types:
                raise HTTPException(
                    400,
                    detail=f"File '{each_file.filename}' not accepted. Accepted types: {accepted_types}",
                )

    elif not (field or nullable):
        raise HTTPException(400, detail="File must be provided.")
