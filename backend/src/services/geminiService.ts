import { GoogleGenerativeAI } from '@google/generative-ai';

export interface ParsedBill {
  biller: string;
  amount: number;
  currency: string;
  dueDate: string;
  reference: string;
  billType: string;
  confidence: number;
}

function getGeminiClient() {
  const apiKey = process.env.GEMINI_API_KEY?.trim();
  if (!apiKey) {
    throw new Error('GEMINI_API_KEY not found in environment variables');
  }
  return new GoogleGenerativeAI(apiKey);
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
    const genAI = getGeminiClient();
    const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();
    
    console.log('✅ Gemini response received');
    
    const jsonMatch = text.match(/\{[\s\S]*\}/);
    
    if (jsonMatch) {
      const parsed = JSON.parse(jsonMatch[0]);
      console.log('📋 Parsed bill:', parsed);
      return parsed;
    }

    throw new Error('Failed to parse JSON from Gemini response');
  } catch (error: any) {
    console.error('❌ Gemini API error:', error.message);
    throw new Error(`Failed to parse bill from SMS: ${error.message}`);
  }
}
