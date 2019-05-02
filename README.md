# 学习示例

https://github.com/developerforce
https://github.com/forcedotcom

## lightning Compnent

需要区分Scratch org 和 NonScratch org

### 创建项目 - 通用

sfdx force:project:create --projectname lwc-demo1

### 授权 - 开发组织

sfdx force:auth:web:login -d -r <Login Url> -a <Dev Hub username or alias>

示例：
sfdx force:auth:web:login -d -a Dev-Hub
"Dev-Hub"是开发组织的别名，你可以在其它Salesforce CLI命令中使用
授权成功，输出：
Successfully authorized chenxiao8516@gmail.com with org ID 00D0o000001SZu5EAG

### 创建临时组织 - Scratch org 

在VS Code中，按Command+Shift+P，输入sfdx，然后选择 SFDX: Create a Default Scratch Org。接受默认值。
或者命令行输入：
sfdx force:org:create -s -f config/project-scratch-def.json -a "Akatsuki"
"Akatsuki"是临时组织的别名。可以使用一个定义文件来创建临时组织
这个项目使用了默认定义文件：project-scratch-def.json

查看已分配的临时组织数量以及剩余的数量：
sfdx force:limits:api:display -u <Dev Hub username or alias>
示例：
sfdx force:limits:api:display -u Dev-Hub
结果：
Successfully created scratch org: 00DN0000000EzfkMAC, username: test-atf5midccct6@example.com

### 创建Lighting Web组件 - 通用

sfdx force:lightning:component:create --type lwc -n myComponent -d force-app/main/default/lwc

### 推送 - Scratch Org

sfdx force:source:push

### 拉取 - Scratch Org

sfdx force:source:pull

### 打开组织页面 - Scratch Org

In VS Code, press Command + Shift + P, enter sfdx, and select SFDX: Open Default Scratch Org.
也可以命令行：sfdx force:org:open

### 部署 - Non-Scratch Orgs

sfdx force:source:deploy -p <pathToDeploy> -u <orgUserName>
示例：
-- 将Salesforce DX项目的根目录部署到用户名为example@force.com的组织
sfdx force:source:deploy -p force-app -u example@force.com

### 检索来源 - Non-Scratch Orgs

sfdx force:source:retrieve -p <pathToRetrieve> -u <orgUserName>
示例：
sfdx force:source:retrieve -p force-app -u chenxiao8516-fnub@force.com

### 将组件加到一个Lightning页面中

1. In the scratch org, in Setup, enter bui and click Lightning App Builder.
2. To create a Lightning page, click New.
3. Select App Page and click Next.
4. Enter the label Hello World.
5. Select Three Regions and click Finish.
6. Drag the Hello World component from the Custom list of components to a region on the page.
7. Select the component and enter a Name.
8. Drag more Hello World components to the page, and set a different name for each component.
9. When your page is complete, click Save and Activate.
10. On the Activation page, select an icon, then click Lightning Experience, and add the page to the Lightning Bolt app. Click Save.
11. To exit Lightning App Builder, click Back.
12. From the App Picker, click Bolt Solutions.
13. Click the Hello World tab to see your page and all its greetings.
14. To return to Lightning App Builder to edit the page, click the gear and select Edit Page.
15. When you edit code, push it to the scratch org and hard refresh the browser.

## Apex

### 新建Apex类

sfdx force:apex:class:create -n MyHelloWorld -d force-app/main/default/apex

### 新建Apex触发器

sfdx force:apex:trigger:create -n HelloWorldTrigger -d force-app/main/default/apex

### 新建Apex测试类
sfdx force:apex:class:create -n HelloWorldTestClass -d force-app/main/default/apex
通过@isTest注释类或者方法，关键字testMethod也可以用来修饰方法，现已过时

### 运行Apex测试类
sfdx force:apex:test:run -n HelloWorldTestClass

## Resources

## Description of Files and Directories

## Issues

## other command

查看端口号被哪个程序占用：netstat -ano