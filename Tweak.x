#import <substrate.h>
#import <mach-o/dyld.h>

// تعريف الدالة القديمة لكي نتمكن من استدعائها لاحقاً
static void (*old_updateCurrency)(void *instance, int amount);

// الدالة الجديدة التي ستحل محل الأصلية
void new_updateCurrency(void *instance, int amount) {
    if (amount < 0) {
        amount *= -1; // تحويل الخصم إلى إضافة
    }
    // تنفيذ الدالة الأصلية لكن بالقيمة المعدلة
    old_updateCurrency(instance, amount);
}

%ctor {
    // 0x123456 يجب أن يستبدل بـ Offset الدالة من Ghidra
    unsigned long targetAddress = _dyld_get_image_vmaddr_slide(0) + 0x123456;
    
    // عملية الـ Hooking المباشرة في الذاكرة
    MSHookFunction((void *)targetAddress, (void *)new_updateCurrency, (void **)&old_updateCurrency);
}
