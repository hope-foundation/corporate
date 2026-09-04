#!/usr/bin/env bash
# สร้างไฟล์ภาพทั้งหมดจาก backdrop ต้นฉบับ — รันซ้ำได้ ผลลัพธ์เหมือนเดิมทุกครั้ง
#
#   ./scripts/extract-mark.sh "/path/to/Photo Backdrop 45th Final (Logo).ai"
#
# ทำไมต้องมีสคริปต์นี้:
#   ไฟล์ .ai ที่ได้รับมาถูก flatten เป็น raster ชิ้นเดียว (21261x16241 CMYK)
#   ไม่มีเลเยอร์ ไม่มี vector แยกโลโก้ออกมาแบบพื้นโปร่งใสไม่ได้
#   ทางเดียวคือ crop ตามพิกัด แล้วให้ CSS ไล่ขอบจางกลืนกับพื้นฟ้า (ดู .anniv-mark)
#   พิกัดด้านล่างวัดจากตำแหน่งพิกเซลจริง ไม่ได้กะจากสายตา
#
# ต้องมี: poppler (pdftoppm) — `brew install poppler` ; sips มากับ macOS
set -euo pipefail

SRC="${1:-}"
[ -n "$SRC" ] && [ -f "$SRC" ] || { echo "usage: $0 <Photo Backdrop 45th Final (Logo).ai>" >&2; exit 1; }
command -v pdftoppm >/dev/null || { echo "need poppler: brew install poppler" >&2; exit 1; }

HERE="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# ไฟล์ .ai ตัวนี้เป็น PDF 1.6 อยู่แล้ว — เปลี่ยนแค่นามสกุลให้ poppler อ่านออก
cp "$SRC" "$TMP/src.pdf"

# หน้า artboard ที่ 60dpi = 8505 x 5670 px — พิกัด crop ทั้งหมดอิงขนาดนี้
#   โลโก้ (บ้าน+เลข 45) อยู่ที่สัดส่วน x 0.349-0.651, y 0.150-0.527 ของหน้า
#   บรรทัด ANNIVERSARY OF HOPE เริ่มที่ y 0.584

# 1) ตราสัญลักษณ์เต็มชุด (บ้าน + เส้นโค้ง + ข้อความ 2 บรรทัด) เผื่อขอบไว้ให้ mask ไล่จาง
pdftoppm -png -r 60 -x 1701 -y 567 -W 5188 -H 3969 -singlefile "$TMP/src.pdf" "$TMP/mark"
sips -Z 1400 "$TMP/mark.png" --out "$HERE/src/assets/anniversary-45-mark.png" >/dev/null

# 2) OG card 1200x630 — crop ให้ได้อัตราส่วน 1.905:1 โดยให้โลโก้อยู่กลาง
pdftoppm -png -r 60 -x 0 -y 149 -W 8505 -H 4464 -singlefile "$TMP/src.pdf" "$TMP/og"
sips -z 630 1200 "$TMP/og.png" --out "$TMP/og-sized.png" >/dev/null
# PNG ของภาพไล่สีหนักเกินจำเป็น (704kB) → JPEG เหลือ ~112kB
sips -s format jpeg -s formatOptions 82 "$TMP/og-sized.png" --out "$HERE/public/og-default.jpg" >/dev/null

# หมายเหตุ: favicon ไม่ได้มาจากไฟล์นี้
#   public/favicon.svg เป็นตราสัญลักษณ์คริสตจักร (กางเขน–นกพิราบ–พระคัมภีร์)
#   คัดมาจาก repo hopeofbangkok: public/brand/emblem.svg แล้วขยาย viewBox
#   จาก 710x887 เป็นจัตุรัส 887x887 โดยเติมพื้นขาวซ้าย/ขวา ไม่ยืดภาพ
#   favicon.png / apple-touch-icon.png คือ SVG ตัวเดียวกัน render เป็น raster

echo "✅ src/assets/anniversary-45-mark.png  public/og-default.jpg"
