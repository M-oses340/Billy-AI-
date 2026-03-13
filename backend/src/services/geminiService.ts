import { GoogleGenerativeAI } from '@google/generative-ai';

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');

export interface ParsedBill {
  biller: string;
  amount: number;
  currency: string;
  dueDate: string;
  reference: string;
  billType: string;
  confidence: number;
}

export async function parseBillSMSGemini(
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
    const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();
    
    const jsonMatch = text.match(/\{[\s\S]*\}/);
    
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }

    throw new Error('Failed to parse JSON from Gemini response');
  } catch (error) {
    console.error('Gemini API error:', error);
    throw new Error('Failed to parse bill from SMS');
  }
}
