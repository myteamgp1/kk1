# 🇹🇭 Thai Teaching Workspace — ระบบผู้ช่วยสอนภาษาไทยด้วย AI

ระบบช่วยเตรียมการสอนสำหรับ **ครูมอส** — ครูสอนภาษาไทยให้ชาวต่างชาติ (สอนเป็นภาษาอังกฤษ
นักเรียนส่วนใหญ่เป็นคนไต้หวัน จีนแผ่นดินใหญ่ และฮ่องกง) ที่ได้รับหัวข้อสอนใหม่ทุกวัน

**สิ่งที่ระบบนี้ทำให้:** ได้หัวข้อมาตอนเช้า → พิมพ์คำสั่งเดียว → ได้ครบทั้ง
แผนการสอน 60 นาที + สคริปต์การสอน + ใบงานนักเรียนเป็น PDF → สอนเสร็จ →
พิมพ์อีกคำสั่งเดียว → ได้บันทึกหลังสอน + ข้อความสรุปส่งนักเรียนทาง LINE/WeChat
พร้อมอัปเดตประวัตินักเรียนอัตโนมัติ

---

## ใช้ยังไง (3 คำสั่งต่อวัน)

เปิด repo นี้ใน [claude.ai/code](https://claude.ai/code) หรือ Claude Code แล้วใช้:

| เมื่อไหร่ | พิมพ์ | ได้อะไร |
|---|---|---|
| ได้หัวข้อมาใหม่ | `/new-lesson สั่งกาแฟ` | โฟลเดอร์บทเรียนครบชุด: lesson plan + teacher script + handout.pdf (ผ่าน QA ภาษาและ QA การพิมพ์แล้ว) |
| แก้ใบงานแล้วอยากได้ PDF ใหม่ | `/make-pdf` | PDF ล่าสุด render + ตรวจสายตาให้ |
| สอนเสร็จ | `/takeaway วันนี้สอนครบ Wei-Ting ยังพลาดเสียงวรรณยุกต์...` | Key takeaway (บันทึกครู + ข้อความสรุปพร้อม copy ส่งนักเรียน) + อัปเดตโปรไฟล์นักเรียน + สมุดบันทึกบทเรียน |

จะพิมพ์ไทยหรืออังกฤษก็ได้ AI อ่านทั้งคู่ — ขอแค่บอกหัวข้อ

## มีอะไรอยู่ในนี้

```
lessons/INDEX.md            สมุดบันทึกกลาง: สอนอะไรไปแล้ว สถานะอะไร
lessons/<วันที่-หัวข้อ>/     บทเรียนละโฟลเดอร์ (plan / script / handout / takeaway)
students/                   โปรไฟล์นักเรียนรายคน + บันทึกจุดผิด + การบ้าน
templates/                  แม่แบบทั้ง 4 (อย่าแก้ตรงนี้ ให้ copy ไปใช้)
curriculum/topic-library.md คลังหัวข้อ ~35 หัวข้อ พร้อมลิงก์ว่าต่อยอดจากบทไหนได้
reference/                  มาตรฐาน Paiboon + สูตรผันวรรณยุกต์ + คู่มือสอนคนจีน
assets/ + tools/            ฟอนต์ + สคริปต์แปลง PDF (ทำงานได้เองครบ ไม่ต้องติดตั้งอะไร)
.claude/skills/             ตัวคำสั่ง /new-lesson /make-pdf /takeaway
CLAUDE.md                   กติกาที่ AI ทุก session ต้องทำตาม (QA บังคับ ฯลฯ)
```

## ตัวอย่างของจริงในนี้ (เปิดดูได้เลย)

- **บทเรียนเด่น:** [`lessons/2026-07-20-ordering-street-food/`](lessons/2026-07-20-ordering-street-food/) —
  เปิด `handout.pdf` ดูใบงานนักเรียน 3 หน้า (ไทย + Paiboon + อังกฤษ + 中文),
  `teacher-script.md` ดูสคริปต์สอนแบบ word-for-word, `lesson-plan.md` ดูแผน 60 นาที
- **วงจรหลังสอน:** [`lessons/2026-07-19-greetings-introductions/takeaway.md`](lessons/2026-07-19-greetings-introductions/takeaway.md) —
  บันทึกหลังสอน + ข้อความสรุปที่ copy ส่งนักเรียนได้ทันที และดูว่า warm-up
  ของบทถัดไปดึงมาจากคิวทบทวนของบทนี้ยังไง
- **การติดตามนักเรียน:** [`students/wei-ting.md`](students/wei-ting.md) —
  จุดผิดสะสมรายคน ระบบจะเอาไปวางแผน drill ให้เอง

> หมายเหตุ: บทเรียนวันที่ 2026-07-19/20 และนักเรียน Wei-Ting/Anna
> เป็น**ข้อมูลตัวอย่าง**เพื่อสาธิตระบบ

## จุดที่ออกแบบมาเฉพาะนักเรียนจีน

- ตารางคำศัพท์มีคอลัมน์ **中文** (ตัวเต็ม) — ไม่ต้องแปลผ่านอังกฤษสองต่อ
- Romanization แบบ **Paiboon มีวรรณยุกต์** + ตารางเตือน "กับดัก pinyin"
  (á ใน pinyin = เสียงขึ้น แต่ในระบบนี้ = เสียงตรี) พิมพ์ท้ายใบงานทุกแผ่น
- คู่มือ [`reference/pedagogy-chinese-l1.md`](reference/pedagogy-chinese-l1.md):
  เทียบวรรณยุกต์ไทย↔จีนกลาง/กวางตุ้ง จุดที่คนจีนพลาดประจำ และจุดได้เปรียบที่ควรใช้

## คำถามที่น่าจะถาม

**นักเรียนไม่ใช่คนจีนล่ะ?** — บอกใน `/new-lesson` ได้เลย เช่น
`/new-lesson ต่อราคา สำหรับนักเรียนเยอรมัน` ระบบจะตัดคอลัมน์ 中文 ออก

**อยากใช้ตัวย่อ (简体)?** — แก้ในโปรไฟล์นักเรียน (`students/<ชื่อ>.md`
ช่อง Chinese gloss script) ฟอนต์รองรับอยู่แล้ว

**PDF พังทำไงดี?** — สั่ง `/make-pdf` ระบบวินิจฉัยเองตามขั้นตอนใน skill

**ภาพประกอบล่ะ?** — ระบบวาด **doodle ลายเส้นแบบ SVG** ลงใบงานให้เองในเครื่อง
ฟรี 100% ไม่ต้องใช้บริการสร้างภาพภายนอก (ดูตัวอย่างรถเข็น/พริก/ไข่ดาว
ในใบงานบทสั่งอาหาร) อยากแก้รูปก็พิมพ์บอกได้เลย เช่น "เปลี่ยนจานเป็นชามก๋วยเตี๋ยว"

**เชื่อเสียงวรรณยุกต์ที่ AI เขียนได้แค่ไหน?** — ทุกคำถูกบังคับให้ผันทวนจากตัวสะกดไทย
ด้วยสูตรใน [`reference/romanization.md`](reference/romanization.md) และแปะผลการผันไว้ใน
lesson plan (หัวข้อ QA appendix) ให้ครูตรวจย้อนได้ทุกคำ — ครูยังคงเป็นผู้ตรวจคนสุดท้าย

---

## English summary

AI-assisted lesson-prep workspace for a Thai teacher whose students are mainly
Chinese speakers. Open this repo in Claude Code and use three commands:
`/new-lesson <topic>` (full 1-hour kit: plan, teacher script, student handout
PDF with Thai/Paiboon/English/中文), `/make-pdf` (re-render + visual QA), and
`/takeaway <notes>` (teacher log + paste-ready student recap, auto-updating
student profiles and the lesson index). Conventions live in `CLAUDE.md`;
linguistic ground truth in `reference/`. Fonts and the Chromium PDF pipeline
are bundled — no setup required.

*หมายเหตุ: `index.thml.rtf` เป็นไฟล์เก่าก่อนมี workspace นี้ ไม่เกี่ยวกับระบบ*
