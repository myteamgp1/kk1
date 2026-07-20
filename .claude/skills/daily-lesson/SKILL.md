---
name: daily-lesson
description: ผลิตบทเรียนภาษาไทยประจำวันแบบครบชุด — เลือกหัวข้อ รีเสิร์ช เขียนบทเรียน 4 ภาษา คู่มือครู และรูป SVG แล้ว commit + push ใช้เมื่อถูกสั่งให้ผลิตบทเรียนประจำวัน รัน daily pipeline หรือ Routine เช้ายิงเข้ามา
---

# /daily-lesson — Pipeline ผลิตบทเรียนภาษาไทยประจำวัน

คุณคือ orchestrator ของ pipeline ทำตามลำดับเคร่งครัด อ่าน `CLAUDE.md` ก่อนเริ่มถ้ายังไม่ได้อ่าน

## ขั้นที่ 0 — เตรียมและตรวจ idempotency
1. ตรวจ branch: ต้องอยู่บน branch ระบบ (ดู CLAUDE.md § Git Conventions) และ `git pull` ล่าสุดแล้ว
2. หา `TODAY` (วันที่วันนี้ YYYY-MM-DD ตามเวลาไทย UTC+7)
3. ถ้ามีโฟลเดอร์ `lessons/<TODAY>-*` อยู่แล้วและมีไฟล์ครบ (research + lesson 4 ภาษา + teacher-guide + images ≥ 3) → **รายงานว่าวันนี้เสร็จแล้วและจบเลย ห้ามผลิตซ้ำ** ถ้ามีโฟลเดอร์แต่ไฟล์ไม่ครบ → ทำต่อเฉพาะขั้นที่ขาด

## ขั้นที่ 1 — เลือกหัวข้อ
Spawn subagent **topic-scout** (จาก `.claude/agents/topic-scout.md`) ด้วย prompt: "เลือกหัวข้อบทเรียนของวันที่ <TODAY>" — รับผลลัพธ์ TOPIC / SLUG / LEVEL / FOLDER / SCOPE / PREVIOUS_LESSONS

## ขั้นที่ 2 — รีเสิร์ช
สร้างโฟลเดอร์ `<FOLDER>/images` และ `<FOLDER>/emails` แล้ว spawn **thai-researcher** ส่งต่อผลจากขั้นที่ 1 ทั้งก้อน → ได้ `<FOLDER>/research.md`
ตรวจ: ไฟล์มีจริง, มี §8 Sources ที่มี URL อย่างน้อย 5 แหล่ง — ถ้าไม่ผ่าน สั่งแก้ก่อนไปต่อ

## ขั้นที่ 3 — เขียนบทเรียน 4 ภาษา (ขนานกัน)
Spawn **lesson-writer** 4 ตัวพร้อมกันในข้อความเดียว (EDITION = en, zh-CN, zh-HK, zh-TW) แต่ละตัวส่ง FOLDER + PREVIOUS_LESSONS
ตรวจ: ได้ไฟล์ครบ 4, แต่ละไฟล์มี 13 section

## ขั้นที่ 4 — คู่มือครู + รูป + QA
Spawn **curriculum-producer** ส่ง FOLDER → ต้องได้ `QA: PASS`
ถ้า `QA: FAIL` ให้สั่งแก้ตามรายการจนผ่าน (วนได้สูงสุด 2 รอบ แล้วรายงานสิ่งที่ยังไม่ผ่านตามจริง)

## ขั้นที่ 5 — บันทึกถาวร
1. ตรวจว่า `data/topics.md` ถูก topic-scout อัปเดตเป็น done แล้ว
2. `git add` เฉพาะไฟล์ที่เกี่ยวข้อง → commit message: `lesson: <TODAY> <TOPIC>` → `git push -u origin <branch>` (retry 2s/4s/8s/16s ถ้า network error)
3. ห้ามสร้าง PR ใหม่ถ้ามี PR เปิดอยู่แล้วสำหรับ branch นี้

## ขั้นที่ 6 — รายงานผล
สรุปสั้น: หัวข้อวันนี้, รายการไฟล์ที่ผลิต, จำนวนหัวข้อคงเหลือในคลัง, ปัญหาที่เจอ (ถ้ามี)

## หมายเหตุ
- ถ้า spawn subagent ตามชื่อ (subagent_type) ไม่ได้ในสภาพแวดล้อมนั้น ให้เปิดไฟล์นิยามใน `.claude/agents/<ชื่อ>.md` แล้ว spawn general-purpose agent โดยแนบเนื้อหาไฟล์นั้นเป็นคำสั่งแทน — ผลลัพธ์ต้องเหมือนกัน
- ห้ามข้ามขั้นตอน QA และห้าม commit งานที่ไฟล์ไม่ครบโดยไม่รายงาน
