// @ts-check
import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

/**
 * ⚠️ `site` สร้าง canonical URL + OG image URL — ถ้าผิด SEO และลิงก์พรีวิวพังทั้งหน้า
 *
 * ค่านี้ยังเป็น placeholder จนกว่าจะ deploy ครั้งแรกแล้วรู้โดเมนจริงของ Vercel
 * หลัง deploy รอบแรก: ตั้ง SITE_URL ใน Vercel project env แล้ว redeploy
 * ห้ามพิมพ์ QR ก่อนค่านี้ตรงกับโดเมนที่ใช้จริง
 */
export default defineConfig({
  site: process.env.SITE_URL ?? "https://hope-of-bangkok-corporate.vercel.app",
  trailingSlash: "always",
  vite: { plugins: [tailwindcss()] },
});
