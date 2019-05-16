# 学习示例

[github url](https://github.com/cxfwolfkings/sfdx-demo)

快速检索`Schema Builder`，查看组织中的所有自定义和标准对象。

快速检索`Process Builder`，进入流程生成器。

作为Salesforce开发人员，有三种核心编程技术可供学习。

1. Lightning组件框架：类似于AngularJS或React的UI开发框架。
2. Apex：Salesforce的专有编程语言，具有类似Java的语法。
3. Visualforce：一种标记语言，允许您创建自定义Salesforce页面，其代码看起来很像HTML，并且可以选择使用Apex和JavaScript的强大组合。

讨论Lightning组件和Visualforce页面之间的区别非常重要。主要区别正是在于名称：

- 使用Lightning组件，您可以开发可拼凑在一起以创建页面的组件。
- 使用Visualforce，您可以立即开发整个页面。

虽然Lightning组件对于移动开发等内容来说更新，更好，但在某些情况下，使用Visualforce更有意义。

**DreamHouse**是一个示例应用程序，演示了Salesforce App Cloud在构建员工生产力和客户参与应用程序方面的独特价值主张。

安装：在网站根Url后面添加 `/packagingSetupUI/ipLanding.app?apvId=04tB00000009UeX`

在您的组织中启用Dev Hub：

1. 以系统管理员身份登录Developer Edition，试用版或生产组织（如果您是客户）或您的企业组织（如果您是ISV）。
2. 从“设置”，“快速查找”框输入Dev Hub并选择。

   如果在“设置”菜单中未看到Dev Hub，请确保您的组织是受支持的版本之一。

3. 要启用Dev Hub，请单击“启用”。
   启用Dev Hub后，您无法**禁用**它。

Dev Hub组织允许您创建，删除和管理Salesforce scratch组织。在本地计算机上设置项目后，可以使用Dev Hub org进行授权，然后才能创建临时组织。

Dev Hub适用于：Developer，Enterprise，Performance和Unlimited版

可在以下位置使用的临时组织：Developer，Enterprise，Group和Professional版

您还可以授权其他现有组织（例如sandbox 或packaging orgs），以便在使用CLI命令时提供更大的灵活性。例如，在使用临时组织开发和测试应用程序之后，您可以将更改部署到集中式沙箱。或者，您可以从现有生产组织中导出数据子集，并将其导入临时组织以进行测试。

您只授权一次组织。要在开发期间切换orgs，请指定组织的用户名。使用--targetusername（或--targetdevhubusername）CLI命令参数，设置默认用户名或使用别名。

[命令行文档](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_apex.htm#cli_reference_force_apex)

[代码库](https://github.com/developerforce)

[代码库](https://github.com/forcedotcom)

[文档格式](https://github.com/DavidAnson/markdownlint/blob/HEAD/doc/Rules.md)

命令帮助参数：-h

示例：`sfdx -h`

需要区分临时组织(Scratch org)和非临时组织(NonScratch org)。

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

结果：

Successfully created scratch org: 00DN0000000EzfkMAC, username: test-atf5midccct6@example.com

查看别名列表：

`sfdx force:alias:list`

查看已分配的临时组织数量以及剩余的数量：

`sfdx force:limits:api:display -u <Dev Hub username or alias>`

示例：

`sfdx force:limits:api:display -u Dev-Hub`

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

创建事件：

`sfdx force:lightning:event:create -n myEvent -d force-app/main/default/aura`

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

### 创建Lighting Web组件

命令：

`sfdx force:lightning:component:create --type lwc -n myComponent -d force-app/main/default/lwc`

关于组件命名空间，参考[这里](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.create_components_namespace)。

关于从Aura组件继承样式，参考[这里](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.create_components_css_aura)。

#### 使用css设置样式

要将样式与组件捆绑在一起，请在组件的文件夹中创建样式表。样式表必须与组件具有相同的名称。样式表自动应用于组件。

每个组件只能有一个样式表。组件无法共享样式表。样式表使用标准CSS语法，您可以使用大多数选择器。

组件样式表中定义的样式的范围限定为组件。此规则允许组件在不同的上下文中重用，而不会丢失其样式。它还可以防止组件的样式覆盖页面其他部分的样式。

父组件可以设置子组件样式，但是子组件是作为一个单独的元素（子组件内部元素的样式在父组件中是不能设置的）。

组件样式表中可以设置自身的样式，使用选择器`c-<componentName>` 或 `:host`

child.html

```html
<template>
   <h1>To Do Item</h1>
   <slot></slot>
</template>
```

child.css

```css
h1 {
    font-size: large;
}
:host {
    display: block;
    background: lightgray;
}
:host(.active) {
    background-color: lightgreen;
}
```

parent.html

```html
<template>
    <h1>To Do List</h1>
    <c-child>Buy potatoes</c-child>
    <c-child>Donate to a good cause</c-child>
    <c-child class="active">Plan a party</c-child>
</template>
```

parent.css

```css
h1 {
    font-size: xx-large;
}
```

**注意**：不支持ID选择器

#### 使用js

Property和attribute几乎是可互换的术语，可能会令人困惑。一般来说，在HTML中我们谈论attribute，在JavaScript中我们谈论Property。

JavaScript中的属性名使用camel case，而HTML属性名称使用kebab case（以破折号分隔）以匹配HTML标准。例如，名为itemName的JavaScript属性映射到名为item-name的HTML属性。

查看[rules](https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.js_props_names)

要从JavaScript 访问HTML属性`for`，请使用`htmlFor`。

`ARIA`属性是支持残疾人阅读的技术，获取这些属性也使用camel case。例如：获取aria-checked，使用ariaChecked。

如果Reactive Property的值改变，组件会重新渲染！Reactive Property可以是public或private。

使用`@api`修饰public property。

使用`@track`修饰private property。

属性值从html到js的传递是没有顺序的，所以处理起来要留意！

Lightning Web Components可以监测到reactive properties的以下类型的值：

- 原始值
- 对象 {…}
- 数组 []

将js作为控件共享，请看[示例1](./force-app/main/default/lwc/lwcDemo01/lwcDemo01.html)。

使用第三方js控件，请看[示例2](./force-app/main/default/lwc/lwcDemo02/lwcDemo02.html)。

### 部署lwc

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

可以使用`ALL ROWS`关键字查询回收站中的记录和已归档活动，但不能用于更新

`System.assertEquals(2, [SELECT COUNT() FROM Contact WHERE AccountId = a.Id ALL ROWS]);`

可以通过[示例代码](./force-app/main/default/classes/ApexDemo01.cls)查看更多用法。

#### 在Apex中使用数据

## Visualforce

**命令**
创建页面：`sfdx force:visualforce:page:create -n pageDemo -l pageDemo -d force-app/main/default/pages`

**用法示例**
详情组件，请看[示例1](./force-app/main/default/pages/pageDemo01.page)。

页签组件，请看[示例2](./force-app/main/default/pages/pageDemo02.page)。

重定向到标准列表页面，请看[示例3](./force-app/main/default/pages/pageDemo03.page)。

输入组件，包含依赖字段，请看[示例4](./force-app/main/default/pages/pageDemo04.page)。

自定义输入字段标签，请看[示例5](./force-app/main/default/pages/pageDemo05.page)。

设置表单中字段的Tab顺序，请参考[这里](https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_input_field_tabindex.htm)。

## API

### Tool API

## Resources

## Description of Files and Directories

## Issues

## other command

查看端口号被哪个程序占用：`netstat -ano`
