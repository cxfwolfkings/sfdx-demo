```
@isTest static void testName() {
    // code_block
}
// 使用 isTest 注释而不是 testMethod 关键字更灵活，因为您可以在注释中指定参数。
static testMethod void testName() {
    // code_block
}

/**
 * 以下简单示例是具有三种测试方法的测试类。
 * 正在测试的类方法将华氏温度作为输入。它将此温度转换为摄氏温度并返回转换结果。
 */
public class TemperatureConverter {
    // Takes a Fahrenheit temperature and returns the Celsius equivalent.
    public static Decimal FahrenheitToCelsius(Decimal fh) {
        Decimal cs = (fh - 32) * 5/9;
        return cs.setScale(2);
    }
}
/**
 * 该 TemperatureConverterTest 测试类通过使用华氏温度的不同输入调用方法来验证方法是否按预期工作。
 * 每种测试方法都验证一种输入类型：温暖的温度，冰点温度，沸点温度和负温度。
 */
@isTest
private class TemperatureConverterTest {
    @isTest static void testWarmTemp() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(70);
        System.assertEquals(21.11,celsius);
    }
    
    @isTest static void testFreezingPoint() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(32);
        System.assertEquals(0,celsius);
    }
    @isTest static void testBoilingPoint() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(212);        
        System.assertEquals(100,celsius,'Boiling point temperature is not expected.');
    } 
    
    @isTest static void testNegativeTemp() {
        Decimal celsius = TemperatureConverter.FahrenheitToCelsius(-10);
        System.assertEquals(-23.33,celsius);
    }
      
}


/**
 * 编写测试时，尽量实现最高的代码覆盖率。不要只针对75％的覆盖率，这是Lightning平台部署和打包所需的最低覆盖率。
 * 测试覆盖的测试用例越多，代码强大的可能性就越高。有时，即使在为所有类方法编写测试方法之后，代码覆盖率也不是100％。
 * 一个常见原因是没有覆盖条件代码执行的所有数据值。
 */
public class TaskUtil {
    public static String getTaskPriority(String leadState) {
        // Validate input
        if (String.isBlank(leadState) || leadState.length() > 2) {
            return null; // 第一条线路
        }
            
        String taskPriority;
        
        if (leadState == 'CA') {
             taskPriority = 'High'; // 第二条线路
        } else {
             taskPriority = 'Normal'; // 第三条线路
        }
        
        return taskPriority;
    }
}
/**
 * 测试用例
 */
@isTest
private class TaskUtilTest {
    @isTest static void testTaskPriority() {
        String pri = TaskUtil.getTaskPriority('NY');
        System.assertEquals('Normal', pri);
    }
    
    @isTest static void testTaskHighPriority() {
        String pri = TaskUtil.getTaskPriority('CA');
        System.assertEquals('High', pri);
    }
    
    @isTest static void testTaskPriorityInvalid() {
        String pri = TaskUtil.getTaskPriority('Montana');
        System.assertEquals(null, pri);
    }
}

/*
 * 触发器测试类
 * 触发器的作用是：如果即将删除的Account有关联的Opportunity，则取消删除 
 */
@isTest
private class TestAccountDeletion {
    @isTest static void TestDeleteAccountWithOneOpportunity() {
        // Test data setup
        // Create an account with an opportunity, and then try to delete it
        Account acct = new Account(Name='Test Account');
        insert acct;
        Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                       StageName='Prospecting',
                                       CloseDate=System.today().addMonths(1),
                                       AccountId=acct.Id);
        insert opp;
        
        // Perform test
        Test.startTest();
        Database.DeleteResult result = Database.delete(acct, false);
        Test.stopTest();
        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Cannot delete account with related opportunities.',
                             result.getErrors()[0].getMessage());
    }
    
}
```