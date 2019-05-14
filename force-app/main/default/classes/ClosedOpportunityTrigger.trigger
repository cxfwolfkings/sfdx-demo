trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    List<Task> taskList = new List<Task>();
    for (Opportunity op : [SELECT Id FROM Opportunity
                     WHERE Id IN :Trigger.New AND
                     StageName='Closed Won']) {
        // Add a default opportunity for this account
        taskList.add(new Task(Subject='Follow Up Test Task',
                                   WhatId=op.Id)); 
    }
    
    if (taskList.size() > 0) {
        insert taskList;
    }
}