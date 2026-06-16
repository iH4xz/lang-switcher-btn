# 🌐 مُبدِّل اللغة — دليل التثبيت (العربية)

**الإضافة:** مُبدِّل اللغة لـ Stream Deck  
**المطوّر:** iH4xz — [ih4xz.pro](https://ih4xz.pro)  
**صفحة المشروع:** [ih4xz.pro/projects/lang-switcher-btn](https://ih4xz.pro/projects/lang-switcher-btn/)  
**المصدر:** [github.com/iH4xz/lang-switcher-btn](https://github.com/iH4xz/lang-switcher-btn)  
**الرخصة:** GPL-3.0

---

## المتطلبات

| العنصر | الإصدار الأدنى |
|---|---|
| برنامج Stream Deck | 6.6 أو أحدث |
| ويندوز | 10 أو 11 |
| Node.js | 20 (مدمج مع Stream Deck) |
| جهاز Stream Deck | أي طراز يدعم الأزرار (Keypad) |

> **اختصار تبديل اللغة:** تستخدم هذه الإضافة **Alt + Shift** لتبديل اللغة — نفس الاختصار المُعيَّن في إعدادات ويندوز 11.

---

## الخيار أ — التثبيت من الإصدار الجاهز (الأسهل)

1. اذهب إلى [صفحة الإصدارات](https://github.com/iH4xz/lang-switcher-btn/releases)
2. حمّل أحدث ملف `com.ih4xz.langbutton.streamDeckPlugin`
3. **انقر نقراً مزدوجاً** على الملف المحمَّل
4. سيفتح برنامج Stream Deck ويطلب منك التأكيد — اضغط **Install**
5. ستظهر الإضافة في قائمة الإجراءات تحت اسم **"Language Switcher"**

---

## الخيار ب — التثبيت من المصدر (للمطوّرين)

### الخطوة 1 — استنساخ المستودع

```bash
git clone https://github.com/iH4xz/lang-switcher-btn.git
cd lang-switcher-btn
```

### الخطوة 2 — تثبيت التبعيات

```bash
npm install
```

### الخطوة 3 — بناء الإضافة

```bash
npm run build
```

سيقوم هذا الأمر بتحويل كود TypeScript إلى ملف `com.ih4xz.langbutton.sdPlugin/bin/plugin.js`.

### الخطوة 4 — نسخ مجلد الإضافة

انسخ المجلد الكامل `com.ih4xz.langbutton.sdPlugin` إلى مجلد إضافات Stream Deck:

```
%APPDATA%\Elgato\StreamDeck\Plugins\
```

**نصيحة:** يمكنك فتح هذا المجلد بسرعة بالضغط على `Win + R` وكتابة:
```
%APPDATA%\Elgato\StreamDeck\Plugins
```

### الخطوة 5 — إعادة تشغيل Stream Deck

أغلق برنامج Stream Deck وأعد فتحه. ستُحمَّل الإضافة تلقائياً.

---

## كيفية إضافة الزر

1. افتح تطبيق **Stream Deck**
2. في اللوحة اليمنى، ابحث عن **"Language Switcher"** ضمن تصنيف الإضافة
3. **اسحب** إجراء "Language Switch" إلى أي خانة زر
4. سيُظهر الزر فوراً لغة لوحة المفاتيح الحالية (**EN** أو **ع**)

---

## استخدام الزر

| الإجراء | النتيجة |
|---|---|
| **النظر إلى الزر** | يُظهر لغة لوحة المفاتيح الحالية (EN / ع) |
| **الضغط على الزر** | التبديل إلى اللغة الأخرى |
| **التبديل عبر شريط المهام** | يُحدَّث الزر تلقائياً خلال ثانيتين تقريباً |

---

## استكشاف الأخطاء وإصلاحها

### يُظهر الزر دائماً "??"
- تأكد من أن شريط لغات ويندوز يحتوي على اللغتين العربية والإنجليزية
- اذهب إلى: **الإعدادات ← الوقت واللغة ← اللغة والمنطقة**
- تأكد من إضافة اللغتين الإنجليزية والعربية كلغات إدخال

### لا تتغير اللغة عند الضغط على الزر
- تحقق من أن اختصار تبديل لغة ويندوز مُعيَّن على **Alt + Shift**
- اذهب إلى: **الإعدادات ← الوقت واللغة ← الكتابة ← إعدادات لوحة المفاتيح المتقدمة ← مفاتيح التشغيل السريع للغة الإدخال**
- تأكد من تكوين Alt+Shift هناك

### لا يظهر الزر في Stream Deck
- تأكد أن المجلد `com.ih4xz.langbutton.sdPlugin` موجود داخل `%APPDATA%\Elgato\StreamDeck\Plugins\`
- أعد تشغيل برنامج Stream Deck
- تحقق من إصدار برنامج Stream Deck (يحتاج 6.6+)

### خطأ في تشغيل PowerShell
- افتح PowerShell كمسؤول (Run as Administrator) ونفِّذ:
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```

---

## إلغاء التثبيت

1. افتح برنامج Stream Deck
2. اذهب إلى **Preferences ← Plugins**
3. ابحث عن **Language Switcher** واضغط زر **×** لإزالته

---

*صُنع بـ ❤️ بواسطة iH4xz — [ih4xz.pro](https://ih4xz.pro)*
