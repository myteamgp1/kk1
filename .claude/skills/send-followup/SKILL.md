---
name: send-followup
description: สร้างอีเมลติดตามผลรายนักเรียนจากบทเรียนวันนี้ ในภาษาของนักเรียนแต่ละคน แล้วสร้างเป็น Gmail draft (มี fallback บันทึกลงไฟล์) ใช้เมื่อถูกสั่งให้เตรียมอีเมลนักเรียน หรือ Routine เย็นยิงเข้ามา
---

# /send-followup — อีเมลติดตามผลนักเรียนประจำวัน

คุณคือผู้ช่วยครูฝ่ายดูแลนักเรียน สร้างอีเมลติดตามผลแบบส่วนตัวรายคน **ห้ามส่งอีเมลเองเด็ดขาด — สร้างเป็น Gmail draft เท่านั้น** (ครูจะตรวจและกดส่งเอง)

## ขั้นตอน

### 1. เตรียมข้อมูล
1. ตรวจ branch ระบบ + `git pull` ล่าสุด
2. หาโฟลเดอร์บทเรียนของวันนี้ `lessons/<TODAY>-*` — ถ้าไม่มีบทเรียนวันนี้ ให้ใช้บทเรียนล่าสุดแทนและระบุในรายงาน
3. อ่าน `data/students.csv` — ข้ามแถวที่ notes มีคำว่า "ตัวอย่าง" **เว้นแต่** ถูกสั่งชัดเจนว่าให้ทำชุดตัวอย่าง/ทดสอบ
4. ตรวจ `data/progress.csv`: ถ้านักเรียนคนไหนมีแถวของ (วันนี้ + slug นี้) อยู่แล้ว ให้ข้าม — กันสร้าง draft ซ้ำ
5. อ่าน `templates/email-template.md` และบทเรียนภาษาที่เกี่ยวข้อง (§3 ศัพท์, §10/§11 track, §12 การบ้าน) + `teacher-guide.md` §8

### 2. เขียนอีเมลรายคน
ต่อนักเรียน 1 คน:
- ภาษา = คอลัมน์ `language` ของนักเรียน (en/zh-CN/zh-HK/zh-TW) — เนื้อหาอิงบทเรียนฉบับภาษานั้น
- ปรับตาม `status`: new → New Student Track, returning → Returning Student Track + เชื่อมโยงบทก่อน
- เรียกชื่อนักเรียน ทำตามโครง template ทุกข้อ ความยาว 150–300 คำ
- บันทึกสำเนาลง `lessons/<TODAY>-<slug>/emails/<language>-<local-part>.md` ตามรูปแบบ metadata ใน template

### 3. สร้าง Gmail drafts
1. โหลดเครื่องมือ Gmail: ใช้ ToolSearch query `select:mcp__Gmail__create_draft,mcp__Gmail__list_drafts`
2. ถ้าโหลดได้: สร้าง draft ต่อฉบับ (to = อีเมลนักเรียน, subject/body ตามที่เขียน) แล้วยืนยันด้วย `list_drafts` ว่าปรากฏจริง → mode = `draft`
3. **Fallback**: ถ้า Gmail connector ไม่มี/ใช้ไม่ได้ (เช่น headless run) → ไฟล์ใน `emails/` คือผลงานหลัก, mode = `file` และระบุในรายงานตอนจบให้ครูเปิด session แล้วสั่ง `/send-followup` เพื่อแปลงไฟล์เป็น draft (รอบถัดไปให้อ่านไฟล์ที่มี `Draft-created: no` มาสร้าง draft โดยไม่ต้องเขียนใหม่ แล้วแก้เป็น `yes`)

### 4. บันทึกถาวร
1. เพิ่มแถวใน `data/progress.csv` ต่อนักเรียน: `date,topic_slug,student_email,language,mode,notes`
2. commit: `emails: <TODAY> <slug>` → push (retry 2s/4s/8s/16s)

### 5. รายงานผล
สรุป: จำนวนอีเมลที่สร้าง แยก draft/file, รายชื่อนักเรียนที่ข้ามเพราะทำแล้ว, ขั้นต่อไปที่ครูต้องทำ (เปิด Gmail ตรวจ Drafts แล้วกดส่ง)
