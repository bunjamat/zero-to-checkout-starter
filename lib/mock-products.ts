import type { Product } from "./types";

// ข้อมูลจำลองไว้ให้หน้าร้านมีอะไรแสดงก่อนที่เราจะมี database
// ครั้งที่ 3 เราจะลบไฟล์นี้ทิ้งแล้วไปดึงจาก /api/products แทน
export const mockProducts: Product[] = [
  { id: 1, name: "แก้วเซรามิก", description: "แก้วกาแฟขนาด 350 ml", priceSatang: 19000, imageUrl: null, stock: 24 },
  { id: 2, name: "เสื้อยืด Hello World", description: "ผ้าคอตตอน 100%", priceSatang: 35000, imageUrl: null, stock: 10 },
  { id: 3, name: "สติกเกอร์ชุด Dev", description: "สติกเกอร์ 12 ลาย", priceSatang: 9900, imageUrl: null, stock: 100 },
  { id: 4, name: "สมุดโน้ตจุด", description: "กระดาษ 120 แกรม 96 แผ่น", priceSatang: 15900, imageUrl: null, stock: 0 },
  { id: 5, name: "ถุงผ้า MY STORE", description: "ถุงผ้าแคนวาส", priceSatang: 22000, imageUrl: null, stock: 15 },
  { id: 6, name: "แผ่นรองเมาส์", description: "ขนาด 30 × 25 cm", priceSatang: 25900, imageUrl: null, stock: 8 },
];
