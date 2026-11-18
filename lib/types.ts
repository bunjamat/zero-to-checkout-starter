// รูปร่างของสินค้าที่หน้าร้านใช้ — API ในครั้งที่ 2 ต้องคืน JSON หน้าตาเดียวกันนี้
// หน้าร้านจะได้สลับจากข้อมูลจำลองไปเรียก API จริงโดยไม่ต้องแก้ component
export type Product = {
  id: number;
  name: string;
  description: string | null;
  priceSatang: number;
  imageUrl: string | null;
  stock: number;
};
