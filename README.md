# corporate

หน้า landing หน้าเดียวของ **คริสตจักรความหวังกรุงเทพฯ** ในธีมครบรอบ 45 ปี
พร้อมปุ่มไปยังฟอร์มส่งคำอวยพรของงาน

- **เป้าหมาย:** ให้คนที่เจอเราในงานครบรอบ ค้นแล้วเจอว่าคริสตจักรมีตัวตนจริง
- **ปุ่มหลัก:** → https://hope-anniversary.pages.dev/ (repo `hope-anniversary`)
- **Stack:** Astro 7 + Tailwind 4 · static · deploy บน Vercel

## ทำไมถึงเป็น repo แยก ไม่ใช่หน้าใน `hopeofbangkok`

repo `hopeofbangkok` เป็นเว็บเต็มของคริสตจักร และเนื้อหาส่วนใหญ่ยัง **รอคริสตจักรอนุมัติ**
(`coreValuesApproved` / `historyApproved` / `ministriesApproved` / `scheduleVerified` = `false`,
`bibleVersion` = `null`, `hbi.feesVerified` = `false`) การรออนุมัติทั้งหมดไม่ทันงานครบรอบ

repo นี้จึงหยิบมาเฉพาะข้อมูลที่ **ยืนยันแล้ว** ใส่ในหน้าเดียว ให้ทันงาน

`src/data/site.ts` เป็น **สำเนาที่คัดมาด้วยมือ ไม่ใช่ import** — ตั้งใจให้เป็นแบบนั้น
เพราะทำให้เนื้อหาที่ยังไม่อนุมัติหลุดขึ้นหน้าเว็บโดยไม่ตั้งใจไม่ได้เลย

### กฎเนื้อหา

- ❌ **ห้ามใส่ที่อยู่ถาวรหรือแผนที่ปักหมุด** — คริสตจักรนมัสการแบบสัญจร ทุกจุดให้ชี้ไปที่การโทรถาม
- ❌ ห้ามใส่ฟิลด์ที่ยังไม่ยืนยัน: อีเมล, LINE official, เลขทะเบียนมูลนิธิ, เลขผู้เสียภาษี, เวลาทำการ, ตารางนมัสการ
- ⏳ ชื่อคริสตจักรที่ใช้บนเว็บยังเป็น Blocker #7 ใน repo `hopeofbangkok` — หน้านี้เลือกใช้ "คริสตจักรความหวังกรุงเทพฯ"

## ภาพทั้งหมดมาจากไฟล์ backdrop จริง

ไฟล์ต้นฉบับ `Photo Backdrop 45th Final (Logo).ai` ถูก flatten เป็น raster ชิ้นเดียว
(21261×16241 CMYK) ไม่มีเลเยอร์ ไม่มี vector — แยกโลโก้แบบพื้นโปร่งใสออกมาไม่ได้

จึง crop ตามพิกัดที่วัดจากพิกเซลจริง แล้วให้ CSS ไล่ขอบจาง (`.anniv-mark`) กลืนกับพื้นฟ้า

```bash
./scripts/extract-mark.sh "/path/to/Photo Backdrop 45th Final (Logo).ai"
```

สร้าง `src/assets/anniversary-45-mark.png`, `public/og-default.jpg`, `public/favicon.png`

**สีทุกค่าใน `global.css` ดูดมาจากไฟล์นั้นด้วยการสุ่มพิกเซล ไม่ได้กะจากสายตา**
⚠️ ต้นฉบับเป็น CMYK และ render โดยไม่มี color profile — สีเขียวอาจเพี้ยนจากงานพิมพ์เล็กน้อย

## Contrast

`--color-anniv-green` (#7A9B3D) บนพื้นฟ้าอ่อน = **2.64** ตกทุกเกณฑ์
→ ใช้กับ **รูปทรงเท่านั้น** ตัวอักษรสีเขียวให้ใช้ `--color-anniv-green-700` (#4A6325) = 5.60 ✅ AA

## Dev

```bash
bun install
bun run dev        # http://localhost:4321
bun run build
bun run preview
```

## Deploy

```bash
bun run deploy          # production
bun run deploy:preview  # preview
```

`vercel` อยู่ใน `devDependencies` **ไม่ใช่ global** ตั้งใจให้เป็นแบบนั้น —
CLI ที่ลง global ไว้จะหายเมื่อ mise bump เวอร์ชัน node (เคยเจอกับ wrangler มาแล้ว)

> ⚠️ **`site` ใน `astro.config.mjs` ยังเป็น placeholder**
> ค่านี้สร้าง canonical URL และ OG image URL หลัง deploy รอบแรกให้ตั้ง `SITE_URL`
> ใน Vercel project env ให้ตรงกับโดเมนจริง แล้ว redeploy
> **ห้ามพิมพ์ QR code ก่อนค่านี้ตรงกับโดเมนที่ใช้จริง**
