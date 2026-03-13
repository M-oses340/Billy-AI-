import { Bill } from '../models/Bill';

export async function processRecurringBills() {
  try {
    const now = new Date();
    
    // Find all recurring bills that need to generate new instances
    const recurringBills = await Bill.find({
      isRecurring: true,
      $or: [
        { nextDueDate: { $lte: now } },
        { nextDueDate: null }
      ]
    });

    console.log(`📅 Processing ${recurringBills.length} recurring bills...`);

    for (const template of recurringBills) {
      try {
        // Calculate next due date
        const nextDue = calculateNextDueDate(template);
        
        // Create new bill instance
        const newBill = new Bill({
          userId: template.userId,
          userAddress: template.userAddress,
          biller: template.biller,
          amount: template.amount,
          currency: template.currency,
          dueDate: nextDue,
          reference: template.reference,
          billType: template.billType,
          status: 'pending',
          autoPayEnabled: template.autoPayEnabled,
          parentRecurringBillId: template._id,
          isRecurring: false, // The instance is not recurring, only the template is
        });

        await newBill.save();
        
        // Update template's next due date
        template.nextDueDate = calculateNextDueDate(template, nextDue);
        await template.save();
        
        console.log(`✅ Created recurring bill: ${template.biller} - ${template.amount} ${template.currency}`);
      } catch (error: any) {
        console.error(`❌ Error processing recurring bill ${template._id}:`, error.message);
      }
    }
  } catch (error: any) {
    console.error('❌ Error in processRecurringBills:', error.message);
  }
}

function calculateNextDueDate(bill: any, fromDate?: Date): Date {
  const baseDate = fromDate || new Date();
  const nextDate = new Date(baseDate);

  switch (bill.recurringFrequency) {
    case 'weekly':
      nextDate.setDate(nextDate.getDate() + 7);
      break;
      
    case 'monthly':
      nextDate.setMonth(nextDate.getMonth() + 1);
      // If recurringDayOfMonth is set, use it
      if (bill.recurringDayOfMonth) {
        nextDate.setDate(Math.min(bill.recurringDayOfMonth, getLastDayOfMonth(nextDate)));
      }
      break;
      
    case 'quarterly':
      nextDate.setMonth(nextDate.getMonth() + 3);
      if (bill.recurringDayOfMonth) {
        nextDate.setDate(Math.min(bill.recurringDayOfMonth, getLastDayOfMonth(nextDate)));
      }
      break;
      
    case 'yearly':
      nextDate.setFullYear(nextDate.getFullYear() + 1);
      if (bill.recurringDayOfMonth) {
        nextDate.setDate(Math.min(bill.recurringDayOfMonth, getLastDayOfMonth(nextDate)));
      }
      break;
      
    default:
      // Default to monthly
      nextDate.setMonth(nextDate.getMonth() + 1);
  }

  return nextDate;
}

function getLastDayOfMonth(date: Date): number {
  return new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
}

// Run every hour
export function startRecurringBillScheduler() {
  // Run immediately on startup
  processRecurringBills();
  
  // Then run every hour
  setInterval(processRecurringBills, 60 * 60 * 1000);
  
  console.log('🔄 Recurring bill scheduler started (runs every hour)');
}
