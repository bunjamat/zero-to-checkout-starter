-- เฉลยแล็บครั้งที่ 1: ตารางของร้าน MY STORE
-- รันทั้งไฟล์ซ้ำกี่รอบก็ได้ เพราะบรรทัดแรกลบตารางเก่าทิ้งก่อน

DROP TABLE IF EXISTS order_items, orders, products;

-- ===== ส่วนที่ 1: สร้างตาราง =====

-- สินค้า 1 ชิ้น = 1 แถว
-- ราคาเก็บเป็น "สตางค์" (integer) ไม่ใช่บาทมีทศนิยม เพราะทศนิยมบวกเงินแล้วเพี้ยน
CREATE TABLE products (
  id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name         varchar(200) NOT NULL,
  description  text,
  price_satang integer      NOT NULL CHECK (price_satang > 0),
  image_url    varchar(500),
  stock        integer      NOT NULL DEFAULT 0,
  created_at   timestamptz  NOT NULL DEFAULT now()
);

-- ใบสั่งซื้อ 1 ใบ = 1 แถว (หัวใบเสร็จ)
CREATE TABLE orders (
  id            integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_name varchar(200) NOT NULL,
  status        varchar(20)  NOT NULL DEFAULT 'pending', -- pending = ยังไม่จ่าย, paid = จ่ายแล้ว
  total_satang  integer      NOT NULL,
  created_at    timestamptz  NOT NULL DEFAULT now(),
  paid_at       timestamptz
);

-- รายการในใบสั่งซื้อ (บรรทัดในใบเสร็จ) — ใบเดียวมีได้หลายบรรทัด
-- unit_price_satang คัดลอกราคา ณ ตอนสั่งไว้ เพราะราคาสินค้าเปลี่ยนได้ แต่ใบเสร็จเก่าต้องไม่เปลี่ยนตาม
CREATE TABLE order_items (
  id                integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id          integer NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id        integer NOT NULL REFERENCES products(id),
  quantity          integer NOT NULL CHECK (quantity > 0),
  unit_price_satang integer NOT NULL
);

-- ===== ส่วนที่ 2: ใส่สินค้า =====
-- ไม่ต้องใส่ id เอง database นับให้

INSERT INTO products (name, description, price_satang, stock) VALUES
  ('แก้วเซรามิก',         'แก้วกาแฟขนาด 350 ml',      19000, 24),
  ('เสื้อยืด Hello World', 'ผ้าคอตตอน 100%',           35000, 10),
  ('สติกเกอร์ชุด Dev',     'สติกเกอร์ 12 ลาย',          9900,  100),
  ('สมุดโน้ตจุด',          'กระดาษ 120 แกรม 96 แผ่น',  15900, 0),
  ('ถุงผ้า MY STORE',      'ถุงผ้าแคนวาส',             22000, 15),
  ('แผ่นรองเมาส์',         'ขนาด 30 × 25 cm',          25900, 8);

-- หารเป็นบาทเฉพาะตอนแสดงผล ข้อมูลจริงยังเป็นสตางค์
SELECT id, name, price_satang, (price_satang / 100.0)::numeric(10, 2) AS price_baht, stock FROM products ORDER BY id;

-- ===== ส่วนที่ 3: ลองสั่งซื้อ =====
-- สมชายซื้อแก้ว 2 ใบ (190 × 2 = 380) กับสติกเกอร์ 1 ชุด (99) รวม 479 บาท = 47900 สตางค์

INSERT INTO orders (customer_name, total_satang) VALUES ('สมชาย', 47900);

INSERT INTO order_items (order_id, product_id, quantity, unit_price_satang) VALUES
  (1, 1, 2, 19000),
  (1, 3, 1, 9900);

-- ===== ส่วนที่ 4: อ่านใบเสร็จด้วย JOIN =====
-- ต่อสามตารางเข้าด้วยกัน: ใบสั่งซื้อ → บรรทัดในใบ → ชื่อสินค้า

SELECT
  o.id                                AS order_id,
  o.customer_name,
  p.name                              AS product,
  oi.quantity,
  oi.unit_price_satang,
  oi.quantity * oi.unit_price_satang  AS line_total_satang
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
JOIN products p     ON p.id = oi.product_id
ORDER BY oi.id;

-- ยอดรวมทั้งใบ คำนวณจากบรรทัดจริง — ต้องได้ 47900 ตรงกับ orders.total_satang
SELECT
  o.id,
  o.total_satang,
  SUM(oi.quantity * oi.unit_price_satang) AS sum_of_lines
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id;

-- ===== ลองเอง: constraint ทำงานยังไง =====
-- เอาเครื่องหมาย -- หน้าบรรทัดล่างออกแล้วรัน จะเจอ error "violates check constraint"
-- INSERT INTO products (name, price_satang) VALUES ('ของแจกฟรี', 0);
