# Thai Language Daily Lesson System (ระบบบทเรียนภาษาไทยรายวัน)

ระบบผลิตบทเรียนภาษาไทยสำหรับนักเรียนต่างชาติแบบอัตโนมัติรายวัน ด้วยทีม AI Agents

## ภาพรวมระบบ

ทุกวันระบบจะ: คิดหัวข้อใหม่ → รีเสิร์ชเว็บแบบละเอียด → เขียนบทเรียน 4 ภาษา → สร้างคู่มือครู + รูป SVG → เก็บทุกอย่างใน git → ตอนเย็นสร้างอีเมลติดตามผลรายนักเรียนเป็น Gmail draft

## โครงสร้างรีโป

- `data/topics.md` — คลังหัวข้อพร้อมสถานะ (planned/done + วันที่) **ห้ามทำหัวข้อซ้ำ**
- `data/students.csv` — รายชื่อนักเรียน: `name,email,language,status,start_date,notes`
  - `language` ∈ `en` | `zh-CN` | `zh-HK` | `zh-TW`
  - `status` ∈ `new` (นักเรียนใหม่) | `returning` (นักเรียนเก่า)
- `data/progress.csv` — บันทึกการสร้างอีเมลติดตามผล
- `templates/` — โครงบทเรียน, คู่มือครู, อีเมล (**ทุกชิ้นงานต้องตามโครงนี้**)
- `lessons/YYYY-MM-DD-<slug>/` — ผลงานรายวัน ต้องมีครบ:
  - `research.md`, `lesson.en.md`, `lesson.zh-CN.md`, `lesson.zh-HK.md`, `lesson.zh-TW.md`, `teacher-guide.md`, `images/*.svg` (อย่างน้อย 3 รูป), `emails/` (สร้างตอนเย็น)
- `.claude/agents/` — นิยาม subagents 4 ตัว: `topic-scout`, `thai-researcher`, `lesson-writer`, `curriculum-producer`
- `.claude/skills/` — `/daily-lesson` (pipeline เช้า), `/send-followup` (อีเมลเย็น)
- `index.thml.rtf` — ไฟล์เก่าที่ไม่เกี่ยวข้องกับระบบนี้ **ห้ามแตะ**

## กติกาสำคัญ (Quality Rules)

1. **ความถูกต้องของภาษาไทยมาก่อนเสมอ** — วรรณยุกต์ คำอ่าน และตัวสะกดต้องถูกต้อง อ้างอิงจาก research.md ที่มีแหล่งที่มา ถ้าไม่แน่ใจให้ระบุว่าไม่แน่ใจ อย่าเดา
2. **zh-HK และ zh-TW ไม่ใช่การแปลงตัวอักษรจาก zh-CN** — zh-HK ใช้ตัวเต็ม + สำนวนฮ่องกง + เทียบเสียงกับกวางตุ้ง (Jyutping), zh-TW ใช้ตัวเต็ม + สำนวนไต้หวัน + เทียบเสียงกับจีนกลาง (拼音/注音) แต่ละฉบับต้องเขียนเพื่อผู้อ่านกลุ่มนั้นจริงๆ
3. **คำอ่านภาษาไทยใช้ 2 ระบบคู่กัน** — RTGS + Paiboon-style พร้อมเครื่องหมายวรรณยุกต์ และระบุเสียงวรรณยุกต์ (สามัญ/เอก/โท/ตรี/จัตวา = mid/low/falling/high/rising) ของทุกคำศัพท์หลัก
4. **บทเรียนทุกฉบับต้องมีส่วนของนักเรียนใหม่และนักเรียนเก่า** ตาม template
5. **รูปภาพเป็น SVG เท่านั้น** สร้างในโค้ด ขนาด viewBox มาตรฐาน 800x600 ฟอนต์ระบุ `font-family="'Noto Sans Thai', 'Noto Sans', sans-serif"` ห้ามอ้างไฟล์/URL ภายนอก
6. **อีเมลนักเรียน: สร้างเป็น Gmail draft เท่านั้น ห้ามส่งเอง** ถ้า Gmail connector ใช้ไม่ได้ ให้บันทึกลง `lessons/<date>/emails/` แล้ว commit เป็น fallback
7. **Idempotency** — ก่อนผลิตบทเรียนตรวจว่าโฟลเดอร์วันนี้มีอยู่แล้วหรือไม่ ถ้ามีครบแล้วให้รายงานและจบ ไม่ผลิตซ้ำ

## Git Conventions

- Branch ปัจจุบันของระบบ: `claude/thai-language-agents-system-irzdle` (หลัง merge เข้า main แล้ว pipeline จะย้ายไปทำงานบน main)
- Commit message: `lesson: YYYY-MM-DD <topic>` สำหรับบทเรียน, `emails: YYYY-MM-DD <topic>` สำหรับอีเมล, `system: <อธิบาย>` สำหรับแก้ระบบ
- Push แล้วต้องตรวจว่าสำเร็จ ถ้า network error ให้ retry (2s, 4s, 8s, 16s)
