public with sharing class MyHelloWorld {
    public static void applyDiscount(Book__c[] books) {
        // 后缀 __c 表明 Book 是自定义对象
        for (Book__c b : books) {
            // 后缀 __c 表明 Price 是自定义字段
            b.Price__c *= 0.9;
        }
    }
}
