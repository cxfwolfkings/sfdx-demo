# 学习示例

[命令行文档](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_apex.htm#cli_reference_force_apex)
[代码库](https://github.com/developerforce)
[代码库](https://github.com/forcedotcom)
[文档格式](https://github.com/DavidAnson/markdownlint/blob/HEAD/doc/Rules.md)

命令帮助参数：-h

需要区分Scratch org 和 NonScratch org

创建项目 - 通用
`sfdx force:project:create --projectname lwc-demo1`

授权 - 开发组织
`sfdx force:auth:web:login -d -r <Login Url> -a <Dev Hub username or alias>`

示例：
`sfdx force:auth:web:login -d -a Dev-Hub`
"Dev-Hub"是开发组织的别名，你可以在其它Salesforce CLI命令中使用
授权成功，输出：
Successfully authorized chenxiao8516@gmail.com with org ID 00D0o000001SZu5EAG

创建临时组织 - Scratch org
在VS Code中，按Command+Shift+P，输入sfdx，然后选择 SFDX: Create a Default Scratch Org。接受默认值。
或者命令行输入：
`sfdx force:org:create -s -f config/project-scratch-def.json -a "Akatsuki"`
"Akatsuki"是临时组织的别名。可以使用一个定义文件来创建临时组织
这个项目使用了默认定义文件：project-scratch-def.json

查看已分配的临时组织数量以及剩余的数量：
`sfdx force:limits:api:display -u <Dev Hub username or alias>`
示例：
`sfdx force:limits:api:display -u Dev-Hub`
结果：
Successfully created scratch org: 00DN0000000EzfkMAC, username: test-atf5midccct6@example.com

推送 - Scratch Org
`sfdx force:source:push`

拉取 - Scratch Org
`sfdx force:source:pull`

打开组织页面 - Scratch Org
In VS Code, press Command + Shift + P, enter sfdx, and select SFDX: Open Default Scratch Org.
也可以命令行：
`sfdx force:org:open`

部署 - Non-Scratch Orgs
`sfdx force:source:deploy -p <pathToDeploy> -u <orgUserName>`
示例：
将Salesforce DX项目的根目录部署到用户名为example@force.com的组织
`sfdx force:source:deploy -p force-app -u example@force.com`

检索来源 - Non-Scratch Orgs
`sfdx force:source:retrieve -p <pathToRetrieve> -u <orgUserName>`
示例：
`sfdx force:source:retrieve -p force-app -u chenxiao8516-fnub@force.com`

## Aura Components

创建Lightning应用程序
`sfdx force:lightning:app:create -n myAuraApp`
创建Aura组件
`sfdx force:lightning:component:create --type aura -n myAuraComponent -d force-app/main/default/aura`

### 使用Aura组件

#### 在Lightning Experience和Salesforce Mobile App中使用Aura组件

##### 作为Lightning Experience App的自定义选项卡

示例代码：[demo01](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/demo01)

1. 创建自定义标签
a. 快速检索：Tabs
b. 新建New Lightning Component Tab
2. 将组件添加到App Launcher
a. 快速检索：，选择 App Manager | New Lightning App
b. 在Select Items界面选择自定义的标签
3. 导航到Lightning Experience中的App Launcher，查看自定义App

##### 作为Salesforce App的自定义选项卡

1. 第一步相同
2. 将lightning组件添加到Salesforce app navigation menu
a. 快速检索：Navigation，选择**Salesforce Navigation**
b. 加入自定义标签。（第1个item会作为引导页）
3. 进入Salesforce mobile web查看效果

##### Lightning组件操作

Lightning组件操作是调用Lightning组件的自定义操作。它们支持Apex和JavaScript，并提供了一种构建客户端自定义功能的安全方法。Lightforce组件操作仅在Salesforce移动应用程序和Lightning Experience中受支持。

配置自定义操作的组件，示例代码：[demo02](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/demo02)

为特定于记录的操作配置组件，示例代码：[demo03](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/demo03)

##### 使用Aura组件覆盖基本操作

示例代码：[demo04](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/demo04)

使用对象管理设置转到您计划覆盖操作的对象。

1. 选择**按钮，链接和操作**。
2. 为要覆盖的操作选择**编辑**。
3. 为要设置覆盖的区域选择Lightning组件。
4. 从下拉菜单中，选择要用作操作覆盖的Lightning组件的名称。
5. 保存。

#### 使用页面引用浏览您的应用程序

参考[这里](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/components_navigation.htm)

#### 在Lightning页面上使用Aura组件

流程：

1. 部署**我的域名**
2. 实现接口
   - flexipage:availableForAllPageTypes
   - flexipage:availableForRecordHome
   - clients:availableForMailAppAppPage
3. 将设计资源添加到组件包
4. 可选：将SVG资源添加到组件包

##### 为您的自定义组件创建动态选项列表

示例代码：[demo05](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/demo05)

##### 创建自定义Lightning Page模板组件

示例代码：[demo06](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/demo06)
自定义Lightning Page模板组件支持 record pages, app pages 和 Home pages，分别继承不同接口：

- lightning:appHomeTemplate
- lightning:homeTemplate
- lightning:recordHomeTemplate

同时必须声明**Aura.Component[]**类型的属性！
资源文件控制模板中可以使用什么类型的页面！参考[这里](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/components_config_for_app_builder_template_component.htm)。
[闪电页面模板组件最佳实践](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/components_config_for_app_builder_template_component_tips.htm)

#### 在Community Builder中使用Aura组件

### Communicating with Events

两种事件：

1. 组件事件
2. 应用事件

创建事件：`sfdx force:lightning:event:create -n myEvent -d force-app/main/default/aura`

#### 组件事件示例

1. 用户单击通知程序组件[ceNotifier.cmp](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/ceNotifier/ceNotifier.cmp)中的按钮。
2. ceNotifier.cmp的客户端控制器在组件事件中设置消息并触发事件。
3. 处理程序组件[ceHandler.cmp](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/ceHandler/ceHandler.cmp)包含通知程序组件，并处理已触发的事件。
4. 客户端控制器ceHandler.cmp基于事件发送的数据设置属性。

#### 应用事件示例

1. 用户单击通知程序组件[aeNotifier.cmp](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/aeNotifier/aeNotifier.cmp)中的按钮。
2. aeNotifier.cmp的客户端控制器在组件事件中设置消息并触发事件。
3. 处理程序组件[aeHandler.cmp](https://github.com/cxfwolfkings/sfdx-demo/tree/master/force-app/main/default/aura/aeHandler/aeHandler.cmp)处理已触发的事件。
4. 客户端控制器aeHandler.cmp基于事件发送的数据设置属性。

### 创建应用

`sfdx force:lightning:app:create -n myApp -d force-app/main/default/aura`

### Styling Apps

- 在App中使用Lightning Design System

```html
<aura:application extends="force:slds">
    <!-- customize your application here -->
</aura:application>
```

- 使用外部css

`<ltng:require styles="{!$Resource.resourceName}" />`

### 开发安全代码

Lightning Locker架构层通过在各自的容器中隔离各个Lightning命名空间并实施编码最佳实践来增强安全性。
该框架还使用JavaScript严格模式在浏览器中打开本机安全功能，并使用内容安全策略(CSP)规则来控制可以在页面上加载的内容源。

### 使用JavaScript

$A命名空间是js代码中使用框架的入口点，参考：`https://<myDomain>.lightning.force.com/auradocs/reference.app`

### 使用Salesforce数据

要从Aura组件创建，读取和更新Salesforce数据，请通过基于表单的组件或`force:recordData`使用Lightning Data Service。要删除Salesforce数据，请使用`force:recordData`。

### 使用Apex

使用Apex编写服务器端代码，例如控制器和测试类。
服务器端控制器处理来自客户端控制器的请求。例如，客户端控制器可能会处理事件并调用服务器端控制器操作来保留记录。服务器端控制器也可以加载记录数据。

### 使用Lightning Testing Service(LTS)测试组件

LTS支持使用标准JavaScript测试框架进行测试。它提供了易于使用的包装，可以使用Jasmine和Mocha。如果您更喜欢使用其它测试框架，可以自己包装。

### 调试

[查看](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/debug_intro.htm)

### 性能

[查看](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/perf_intro.htm)

### 参考

[查看](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/ref_intro.htm)

## lightning Web组件

创建Lighting Web组件
`sfdx force:lightning:component:create --type lwc -n myComponent -d force-app/main/default/lwc`

将组件加到一个Lightning页面中

1. 在scratch org中，快速检索bui进入Lightning App Builder
2. 创建Lightning page
3. 选择App Page
4. 在label中输入Hello World
5. 选择Three Regions
6. 将Hello World组件拖到页面上的占位区
7. 选中component输入 Name
8. 将更多Hello World组件拖到页面上，并输入Name
9. 完成页面后保存并激活
10. 在Activation页面，选择一个Icon，然后点击Lightning Experience，将页面添加到Lightning Bolt app，保存
11. 退出Lightning App Builder，点击返回
12. 从App Picker点击Bolt Solutions
13. 点击Hello World tab查看你的页面
返回Lightning App Builder编辑页面，点击gear然后选择Edit Page
当你改变代码后，推送到scratch org然后强制刷新浏览器

## Apex

新建Apex类
`sfdx force:apex:class:create -n MyHelloWorld -d force-app/main/default/classes`

新建Apex触发器
`sfdx force:apex:trigger:create -n HelloWorldTrigger -d force-app/main/default/classes`

新建Apex测试类
`sfdx force:apex:class:create -n HelloWorldTestClass -d force-app/main/default/classes`
通过@isTest注释类或者方法，关键字testMethod也可以用来修饰方法，现已过时

运行Apex测试类
`sfdx force:apex:test:run -n HelloWorldTestClass`

### 写Apex

| 操作 | 结果类 |
| --- | --- |
|insert|SaveResult|
|upsert|UpsertResult|
|merge|MergeResult|
|delete|DeleteResult|
|undelete|UndeleteResult|
|convertLead|LeadConvertResult|
|emptyRecycleBin|EmptyRecycleBinResult|

在Apex中，您可以使用**update**在更新sObject记录时锁定它们以防止竞争条件和其他线程安全问题。
`Account [] accts = [SELECT Id FROM Account LIMIT 2 FOR UPDATE];`

### SOQL 和 SOSL

SOQL语句返回sObjects列表，单个sObject或`count`方法查询得到的Integer

```java
List<Account> aa = [SELECT Id, Name FROM Account WHERE Name = 'Acme'];
// 如果可以确定只有单条返回记录，可以直接在SOQL语句后用"."获取字段！
// 但是如果没有记录或超过一条就报错！
Contact c = new Contact(Account = [SELECT Name FROM Account WHERE NumberOfEmployees > 10 LIMIT 1]);
Integer i = [SELECT COUNT() FROM Contact WHERE LastName = 'Weissman'];
```

SOSL语句返回sObject列表的列表，其中每个列表包含特定sObject类型的搜索结果。结果列表的返回顺序与SOSL查询中指定的顺序相同

```java
List<List<SObject>> searchList = [FIND 'map*' IN ALL FIELDS RETURNING Account (Id, Name), Contact, Opportunity, Lead];
// 等价于：FIND {map*} IN ALL FIELDS RETURNING Account (Id, Name), Contact, Opportunity, Lead
```

#### 在Apex中使用数据

## Resources

## Description of Files and Directories

## Issues

## other command

查看端口号被哪个程序占用：
`netstat -ano`
