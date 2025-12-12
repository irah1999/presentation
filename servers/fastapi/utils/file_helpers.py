# utils/file_helpers.py

import os
import re
import posixpath
from typing import Optional # FIX: Added missing import

# --- Helper Functions (from others.ts) ---

def get_icon_from_file(file: str) -> str:
    """Gets the icon path based on the file extension."""
    file_ext = file.split(".")[-1].lower() if "." in file else ""
    if file_ext == "pdf":
        return "/pdf.svg"
    elif file_ext == "docx":
        return "/report.png"
    elif file_ext == "pptx":
        return "/ppt.svg"
    return "/report.png"

def is_dark_color(hex_color: str) -> bool:
    """Checks if a hex color is dark based on luminance (WCAG)."""
    hex_color = hex_color.lstrip('#')
    if len(hex_color) == 3:
        hex_color = "".join([c * 2 for c in hex_color])

    try:
        r = int(hex_color[0:2], 16)
        g = int(hex_color[2:4], 16)
        b = int(hex_color[4:6], 16)
    except ValueError:
        return False

    # Calculate relative luminance (per WCAG)
    luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return luminance < 128

def remove_uuid(file_name: str) -> str:
    """Removes a standard 36-char UUID (plus separator) from the filename before the extension."""
    uuid_pattern = r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
    base, ext = os.path.splitext(file_name)
    
    # Removes the UUID and the character immediately preceding it (e.g., '-', '_')
    new_base = re.sub(r'[-_]'+uuid_pattern+r'$', '', base, flags=re.IGNORECASE)
    
    return new_base + ext

# --- Main Sanitization Function ---

def sanitize_filename(input_str: Optional[str], replacement: str = '') -> str:
    """
    Sanitizes a filename or path string for security and cross-OS compatibility.
    Equivalent to the Next.js `sanitizeFilename` function.
    """
    if input_str is None:
        sanitized = ''
    else:
        sanitized = str(input_str)

    # 1. Remove null bytes
    sanitized = sanitized.replace('\0', '')
    
    # 2. Remove or replace path traversal sequences
    sanitized = sanitized.replace('..', replacement)
    
    # 3. Define and apply regexes for illegal characters and control characters
    illegal_re = re.compile(r'[\?<>\\:\*\"|]', re.UNICODE) 
    control_re = re.compile(r'[\x00-\x1f\x80-\x9f]', re.UNICODE)
    reserved_re = re.compile(r'^\.+$', re.UNICODE)
    windows_reserved_re = re.compile(r'^(con|prn|aux|nul|com\d|lpt\d)$', re.IGNORECASE | re.UNICODE)
    windows_trailing_re = re.compile(r'[\. ]+$', re.UNICODE)

    sanitized = illegal_re.sub(replacement, sanitized)
    sanitized = control_re.sub(replacement, sanitized)

    # 4. Handle reserved names and trailing characters per segment
    path_segments = sanitized.split('/')
    cleaned_segments = []
    for segment in path_segments:
        clean_segment = segment
        clean_segment = reserved_re.sub(replacement, clean_segment)
        clean_segment = windows_reserved_re.sub(replacement, clean_segment)
        clean_segment = windows_trailing_re.sub(replacement, clean_segment)
        clean_segment = clean_segment.replace('..', replacement)
        cleaned_segments.append(clean_segment)

    sanitized = '/'.join(cleaned_segments)

    # 5. Final clean up
    sanitized = sanitized.replace('..', replacement)
    sanitized = re.sub(r'/+', '/', sanitized)

    if not sanitized:
        sanitized = 'file'

    return sanitized


def get_static_file_url(filepath: str) -> str:
    """Converts a full filepath to a static URL path."""
    path_parts = filepath.split('/')
    # Skip the first two path segments after the root.
    relevant_path = '/'.join(path_parts[3:]) if len(path_parts) > 2 and path_parts[0] == '' else '/'.join(path_parts[2:])

    return posixpath.join("/static", relevant_path)