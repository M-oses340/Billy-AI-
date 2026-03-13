# Setup Free AI for Billy

## Quick Start with Groq (Recommended - FREE & FAST)

### 1. Get Free API Key
Visit: https://console.groq.com/
- Sign up (no credit card required)
- Go to API Keys
- Create new key
- Copy the key (starts with `gsk_`)

### 2. Add to .env
```bash
GROQ_API_KEY=gsk_your_key_here
```

### 3. Done!
You get 14,400 free requests per day - more than enough for bill parsing.

---

## Alternative: Ollama (100% Free, Self-Hosted)

### 1. Install Ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### 2. Download Model
```bash
ollama pull llama3.2
```

### 3. Start Server
```bash
ollama serve
```

### 4. Update Code
In `backend/src/routes/smsRoutes.ts`, change:
```typescript
import { parseBillSMSOllama as parseBillSMS } from '../services/aiService';
```

### 5. Done!
Completely free, runs locally, no API keys needed.

---

## Cost Comparison (100 bills/month)

| Service | Cost | Speed | Setup |
|---------|------|-------|-------|
| Groq | $0 | ⚡⚡⚡ | 2 min |
| Ollama | $0 | ⚡⚡ | 5 min |
| Gemini | $0 | ⚡⚡⚡ | 2 min |
| Claude | $0.25 | ⚡⚡⚡ | 2 min |

**Recommendation: Use Groq for production (free + fast)**
