const baht = new Intl.NumberFormat("th-TH", { style: "currency", currency: "THB" });

// ราคาทั้งระบบเก็บเป็นสตางค์ (integer) เพราะทศนิยมของ JavaScript บวกเงินแล้วเพี้ยน
// (ลอง 0.1 + 0.2 ใน Console) จะหารเป็นบาทก็ตอนแสดงผลเท่านั้น
export function formatBaht(satang: number): string {
  return baht.format(satang / 100);
}
