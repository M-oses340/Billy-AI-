import Groq from 'groq-sdk';

const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY || '',
});

export interface ParsedBill {
  biller: string;
  amount: number;
  currency: string;
  dueDate: string;
  reference: string;
  billType: string;
  confidence: number;
}

export async function parseBillSMS(
  smsContent: string,
  fromNumber: string
): Promise<ParsedBill> {
  const prompt = `Parse this bill SMS and extract structured data:

SMS: "${smsContent}"
From: ${fromNumber}

Extract:
1. Biller name
2. Amount (numeric value only)
3. Currency (USD, KES, etc.)
4. Due date (YYYY-MM-DD format)
5. Reference number
6. Bill type (electricity, water, internet, phone, gas, rent, other)

Return ONLY valid JSON in this exact format:
{
  "biller": "string",
  "amount": number,
  "currency": "string",
  "dueDate": "YYYY-MM-DD",
  "reference": "string",
  "billType": "string",
  "confidence": number (0-1)
}`;

  try {
    const completion = await groq.chat.completions.create({
      messages: [{ role: 'user', content: prompt }],
      model: 'llama-3.1-70b-versatile',
      temperature: 0.1,
      max_tokens: 500,
    });

    const content = completion.choices[0]?.message?.content || '';
    const jsonMatch = content.match(/\{[\s\S]*\}/);
    
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }

    throw new Error('Failed to parse JSON from AI response');
  } catch (error) {
    console.error('Groq API error:', error);
    throw new Error('Failed to parse bill from SMS');
  }
}

// Fallback to Ollama (local) if Groq fails
export async function parseBillSMSOllama(
  smsContent: string,
  fromNumber: string
): Promise<ParsedBill> {
  const prompt = `Parse this bill SMS and extract structured data:

SMS: "${smsContent}"
From: ${fromNumber}

Return ONLY valid JSON with: biller, amount, currency, dueDate, reference, billType, confidence`;

  try {
    const response = await fetch('http://localhost:11434/api/generate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'llama3.2',
        prompt,
        stream: false,
      }),
    });

    const data = await response.json();
    const jsonMatch = data.response.match(/\{[\s\S]*\}/);
    
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }

    throw new Error('Failed to parse JSON from Ollama');
  } catch (error) {
    console.error('Ollama error:', error);
    throw new Error('Failed to parse bill with Ollama');
  }
}
