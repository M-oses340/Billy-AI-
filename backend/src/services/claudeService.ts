import Anthropic from '@anthropic-ai/sdk';

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
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

  const message = await anthropic.messages.create({
    model: 'claude-3-haiku-20240307',
    max_tokens: 1024,
    messages: [{ role: 'user', content: prompt }],
  });

  const content = message.content[0];
  if (content.type === 'text') {
    const jsonMatch = content.text.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }
  }

  throw new Error('Failed to parse bill from SMS');
}
