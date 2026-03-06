#import <UIKit/UIKit.h>

// ملاحظة: استبدل 'GameManager' و 'spendGold' بالأسماء الحقيقية التي استخرجتها من التحليل
%hook GameManager

- (void)spendGold:(int)amount {
    // إذا كانت اللعبة ترسل القيمة كـ (موجب) ليتم طرحها داخلياً
    // سنقوم بتمريرها كـ (سالب) لعلّ وعسى أن يؤدي ذلك لعملية جمع (رياضيات: - - = +)
    if (amount > 0) {
        int reversedAmount = -amount;
        %orig(reversedAmount);
    } else {
        %orig(amount);
    }
}

// أو إذا كانت هناك دالة تحديث عامة:
- (void)updateBalance:(int)newAmount {
    // نضاعف أي زيادة تطرأ على الرصيد
    %orig(newAmount * 2);
}

%end
