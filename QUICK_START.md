# 🚀 QUICK START - Presenton Python Project

## ⚡ Start the Server (3 Steps)

```powershell
# 1. Navigate to the directory
cd d:\react-js\ppt\servers\fastapi

# 2. Run the startup script
.\start_server.ps1

# 3. Wait for startup (5-15 min first time, then 5-10 sec)
```

## 🌐 Access Points

- **API Docs:** http://127.0.0.1:8000/docs
- **ReDoc:** http://127.0.0.1:8000/redoc
- **Base API:** http://127.0.0.1:8000

## 📝 Generate a Presentation

```powershell
curl -X POST http://127.0.0.1:8000/api/v1/ppt/presentation/generate `
  -H "Content-Type: application/json" `
  -d '{
    "content": "Your topic here",
    "n_slides": 5,
    "language": "English",
    "template": "general",
    "export_as": "pptx"
  }'
```

## ⚙️ Configuration (Optional)

Create `.env` file in `d:\react-js\ppt\servers\fastapi\`:

```env
OPENAI_API_KEY=your-key-here
GOOGLE_API_KEY=your-key-here
ANTHROPIC_API_KEY=your-key-here
```

## 🛑 Stop the Server

Press `CTRL+C` in the terminal

## 📚 Documentation

- `FINAL_SETUP_SUMMARY.md` - Complete setup summary
- `SETUP_GUIDE.md` - Detailed setup guide
- `TROUBLESHOOTING.md` - Common issues & solutions
- `INSTALLATION_COMPLETE.md` - Installation details

## 🆘 Having Issues?

Read `TROUBLESHOOTING.md` for solutions to common problems.

## ✅ Setup Status

- [x] Python 3.11.8 installed
- [x] Virtual environment created
- [x] 167 packages installed
- [x] Ready to run!

---

**Quick Tip:** First startup downloads models (~79 MB) and takes 5-15 minutes. Subsequent startups take only 5-10 seconds!
