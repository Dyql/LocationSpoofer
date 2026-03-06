#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>
#import <stdint.h>

// تعريف نوع الإرجاع للعمليات النواتية
typedef int kern_return_t;
#define KERN_SUCCESS 0

// دالة كتابة الذاكرة المباشرة (Memory Patching)
void patch_memory(uint64_t offset, uint32_t data) {
    uint64_t address = _dyld_get_image_vmaddr_slide(0) + offset;
    mach_port_t task = mach_task_self();
    
    // تغيير صلاحيات الصفحة لتصبح قابلة للكتابة
    vm_protect(task, (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    
    // كتابة الـ Hex الجديد
    vm_write(task, (vm_address_t)address, (vm_offset_t)&data, sizeof(data));
    
    // إعادة الصلاحيات للأصل (قراءة وتنفيذ)
    vm_protect(task, (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
}

%ctor {
    // تمويه: الانتظار 5 ثوانٍ بعد تشغيل اللعبة قبل حقن التعديل
    // هذا يهرب من "الفحص السريع" الذي تقوم به اللعبة عند اللحظة 0
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // استبدل 0x100abc بالـ Offset الذي وجدته في Ghidra
        // استبدل 0x0B010000 بالـ Hex الخاص بعملية الجمع (ADD)
        patch_memory(0x100abc, 0x0B010000);
        
    });
}
