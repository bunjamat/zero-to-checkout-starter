import { describe, expect, test } from "bun:test";

import { formatBaht } from "./money";

describe("formatBaht", () => {
  test("แปลงสตางค์เป็นบาท", () => {
    expect(formatBaht(12900)).toBe("฿129.00");
  });

  test("ใส่จุลภาคคั่นหลักพัน", () => {
    expect(formatBaht(150000)).toBe("฿1,500.00");
  });

  test("ศูนย์บาท", () => {
    expect(formatBaht(0)).toBe("฿0.00");
  });
});
