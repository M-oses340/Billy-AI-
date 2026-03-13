# Free AI Options Comparison for Billy

## Quick Comparison

| AI Service | Free Tier | Speed | Accuracy | Setup Time |
|------------|-----------|-------|----------|------------|
| **Groq** ⭐ | 14,400/day | ⚡⚡⚡ | ⭐⭐⭐⭐ | 2 min |
| **Gemini** | 1,500/day | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ | 2 min |
| **Ollama** | Unlimited | ⚡⚡ | ⭐⭐⭐⭐ | 5 min |

---

## Option 1: Groq (Recommended) ⭐

**Best for: Production use with high volume**

### Pros:
- Fastest inference (< 1 second)
- Very generous free tier (14,400 requests/day)
- No credit card required
- Llama 3.1 70B model
- Great accuracy

### Cons:
- Rate limits on free tier
- Requires internet connection

### Setup:
```bash
# 1. Get free API key
Visit: https://console.groq.com/
Sign up → API Keys → Create Key

# 2. Add to .env
GROQ_API_KEY=gsk_your_key_here

# 3. Use default import in smsRoutes.ts
import { parseBillSMS } from '../services/aiService';
```

### Free Tier:
- 14,400 requests/day
- ~480 bills/day
- $0/month

---

## Option 2: Google Gemini

**Best for: Highest accuracy**

### Pros:
- Excellent accuracy (best for complex bills)
- Free tier: 1,500 requests/day
- Fast inference
- Multimodal (can handle images too)
- No credit card required

### Cons:
- Lower daily limit than Groq
- Requires Google account

### Setup:
```bash
# 1. Get free API key
Visit: https://aistudio.google.com/
Create project → Get API Key

# 2. Add to .env
GEMINI_API_KEY=your_gemini_key_here

# 3. Change import in smsRoutes.ts
import { parseBillSMSGemini as parseBillSMS } from '../services/geminiService';
```

### Free Tier:
- 1,500 requests/day
- ~50 bills/day
- $0/month

---

## Option 3: Ollama (Self-Hosted)

**Best for: Privacy & unlimited usage**

### Pros:
- 100% free, unlimited
- Runs locally (no internet needed)
- Complete privacy (data never leaves server)
- No API keys
- No rate limits

### Cons:
- Requires 8GB+ RAM
- Slower than cloud APIs
- Need to manage server

### Setup:
```bash
# 1. Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# 2. Download model (one-time, ~4GB)
ollama pull llama3.2

# 3. Start server
ollama serve

# 4. Change import in smsRoutes.ts
import { parseBillSMSOllama as parseBillSMS } from '../services/aiService';
```

### Cost:
- $0/month (just server costs)
- Unlimited requests

---

## Switching Between Options

Just change the import in `backend/src/routes/smsRoutes.ts`:

```typescript
// Option 1: Groq (default)
import { parseBillSMS } from '../services/aiService';

// Option 2: Gemini
import { parseBillSMSGemini as parseBillSMS } from '../services/geminiService';

// Option 3: Ollama
import { parseBillSMSOllama as parseBillSMS } from '../services/aiService';
```

---

## Recommendations by Use Case

### For Most Users:
**Groq** - Best balance of speed, accuracy, and free tier

### For High Accuracy Needs:
**Gemini** - Best accuracy, especially for complex bills

### For Privacy-Conscious:
**Ollama** - Self-hosted, data never leaves your server

### For High Volume (>1500 bills/day):
**Groq** (14,400/day) or **Ollama** (unlimited)

---

## Cost Estimates (100 bills/month)

| Service | Cost |
|---------|------|
| Groq | $0 |
| Gemini | $0 |
| Ollama | $0 |
| Claude | $0.25 |
| GPT-4 | $3.00 |

**All free options are within their free tiers for typical usage!**
