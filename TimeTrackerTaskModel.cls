public abstract class TimeTrackerTaskModel {

    //Variables
    private static String taskCategory;
    private static String taskName;
    private static String taskDescription;
    private static String timeStarted;
    private static String taskId;
    private static String timeStopped;
    private static String[] eachSelectedTask;
    
    //Mutators
    public static void setTaskCategory(String thisTaskCategory) {
        
        taskCategory = thisTaskCategory;
    }
    
    public static void setTaskName(String thisTaskName) {
        
        taskName = thisTaskName;
    }
    
    public static void setTaskDescription(String thisTaskDescription) {
        
        taskDescription = thisTaskDescription;
    }
    
    public static void setTimeStarted(String thisTimeStarted) {
        
        timeStarted = thisTimeStarted;
    }
    
    public static void setTaskId(String thisTaskId) {
        
        taskId = thisTaskId;
    }
    
    public static void setTimeStopped(String thisTimeStopped) {
        
        timeStopped = thisTimeStopped;
    }
    
    public static void setEachSelectedTask(String[] thisEachSelectedTask) {
        
        eachSelectedTask = thisEachSelectedTask;
    }
    
    //Accessors
    private static String getTaskCategory() {
        
        return taskCategory;
    }
    
    private static String getTaskName() {
        
        return taskName;
    }
    
    private static String getTaskDescription() {
        
        return taskDescription;
    }
    
    private static String getTimeStarted() {
        
        return timeStarted;
    }
    
    private static String getTaskId() {
        
        return taskId;
    }
    
    private static String getTimeStopped() {
        
        return timeStopped;
    }
    
    private static String[] getEachSelectedTask() {
        
        return eachSelectedTask;
    }
    
    public static String createTask() {
        
        String output = '';
        
        try {
            
            List<TimeTrackerTask__c> tasksToInsert = new List<TimeTrackerTask__c>();
            
            if (FormValidationUtility.isStringNullOrWhitespace(getTaskName())) {
                
                setTaskName('Unspecified task');
            }
            
            if (FormValidationUtility.isStringNullOrWhitespace(getTaskDescription())) {
                
                setTaskDescription('None');
            }
            
            TimeTrackerTask__c prepareTask = new TimeTrackerTask__c(Name = getTaskName(),
                                                                   Description__c = getTaskDescription(),
                                                                   TimeStarted__c = getTimeStarted(),
                                                                   TimeStopped__c = '0',
                                                                   TotalTime__c = 0,
                                                                   TimeTrackerTaskCategory__c = getTaskCategory());
            
            TimeTrackerTask__c newTask = new TimeTrackerTask__c(Name = prepareTask.Name,
                                                               Description__c = prepareTask.Description__c,
                                                               TimeStarted__c = prepareTask.TimeStarted__c,
                                                               TimeStopped__c = prepareTask.TimeStopped__c,
                                                               TotalTime__c = prepareTask.TotalTime__c,
                                                               TimeTrackerTaskCategory__c = prepareTask.TimeTrackerTaskCategory__c);
            
            tasksToInsert.add(newTask);
            
            insert tasksToInsert;
            
            output = 'success';
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            output = 'fail';
        }
        
        return output;
    }
    
    public static String finishSelectedTask() {
        
        String output = '';
        
        List<TimeTrackerTask__c> tasksToUpdate = new List<TimeTrackerTask__c>();
        
        if (!(Schema.SObjectType.TimeTrackerTask__c.isUpdateable())) {
            
            output = 'fail';
        } else {
            
            try {
            	
                for (TimeTrackerTask__c eachTask: [SELECT Id, TimeStarted__c, TimeStopped__c, TotalTime__c
                                                   FROM TimeTrackerTask__c WHERE CreatedById = :UserInfo.getUserId()]) {
                    
                    if (eachTask.Id.Equals(Id.valueOf(getTaskId()))) {
                                                                                   
            			eachTask.TimeStopped__c = getTimeStopped();
                		eachTask.TotalTime__c = (Integer.valueOf(getTimeStopped()) - Integer.valueOf(eachTask.TimeStarted__c));
                    
                   		tasksToUpdate.add(eachTask);
                    }
            	}
                
                update tasksToUpdate;
                
                output = 'success';
            } catch (DMLException e) {
                
                System.debug('An unexpected error has occurred: ' + e.getMessage());
                
                output = 'fail';
            }
        }
        
        return output;
    }
    
    public static String deleteSelectedTasks() {
        
        String output = '';
        String queryString = '';
        
        if (!(Schema.SObjectType.TimeTrackerTask__c.isDeletable())) {
            
            output = 'fail';
        } else {
           
        	if (getEachSelectedTask().size() > 0) {
        	
            	try {
            	
                	queryString += 'SELECT Id FROM TimeTrackerTask__c WHERE ';
        
        			for (Integer i = 0; i < getEachSelectedTask().size(); i++) {
            
            			if (i == 0) {
                	
                    		queryString += 'Id = \'' + getEachSelectedTask()[i] + '\' ';
            			} else {
                	
                    		queryString += 'OR Id = \'' + getEachSelectedTask()[i] + '\' ';
            			}
        			}
            
            		queryString += 'ORDER BY CreatedDate DESC';
        
        			TimeTrackerTask__c[] taskToBeDeleted = Database.query(queryString);
        
        			delete taskToBeDeleted;
                
                	output = 'success';
            	} catch (DMLException e) {
                
                	System.debug('An unexpected error has occurred: ' + e.getMessage());
                
                	output = 'fail';
            	}
        	}
        }
        
        return output;
    }
    
    public static List<List<String>> searchTaskCategories() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> taskCategoryId = new List<String>();
        List<String> taskCategoryName = new List<String>();
        
        Integer taskCategoryCount = 0;
        
        try {

            if (Schema.SObjectType.TimeTrackerTaskCategory__c.isAccessible()) {          
            	
                for (TimeTrackerTaskCategory__c eachTaskCategory: [SELECT Id, Name FROM TimeTrackerTaskCategory__c
                                                                   WHERE OwnerId = :UserInfo.getUserId()
                                                                   ORDER BY Name ASC]) {
                                                                       
                    taskCategoryId.add(String.valueOf(eachTaskCategory.Id));
                    taskCategoryName.add(eachTaskCategory.Name);
                    
                	taskCategoryCount++;                                                   
                }
            }
            
            if (taskCategoryCount == 0) {
                
                taskCategoryId.add('0');
                taskCategoryName.add('no task category');
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            taskCategoryId.add('fail');
            taskCategoryName.add('fail');
        }
        
        output.add(taskCategoryId);
        output.add(taskCategoryName);
        
        return output;
    }
    
    public static List<List<String>> searchTasks() {
        
        List<List<String>> output = new List<List<String>>();
        
        List<String> taskId = new List<String>();
        List<String> taskName = new List<String>();
        List<String> description = new List<String>();
        List<String> timeStarted = new List<String>();
        List<String> timeStopped = new List<String>();
        List<String> createdDate = new List<String>();
        List<String> totalTime = new List<String>();
        
        Integer taskCount = 0;
        
        try {
            
            if (Schema.SObjectType.TimeTrackerTask__c.isAccessible()) {
                
                for (TimeTrackerTask__c eachTask: [SELECT Id, Name, Description__c, TimeStarted__c, TimeStopped__c,
                                                   CreatedDate, TotalTime__c FROM TimeTrackerTask__c
                                                   WHERE CreatedById = :UserInfo.getUserId() ORDER BY CreatedDate DESC]) {
                    
                    taskId.add(String.valueOf(eachTask.Id));
                    taskName.add(eachTask.Name);
                    description.add(eachTask.Description__c);
                    timeStarted.add(eachTask.TimeStarted__c);
                    timeStopped.add(eachTask.TimeStopped__c);
                    createdDate.add(String.valueOf(eachTask.CreatedDate));
                    totalTime.add(String.valueOf(eachTask.TotalTime__c));
                                                       
                    taskCount++;
                }
            }
            
            if (taskCount == 0) {
                
                taskId.add('0');
                taskName.add('no task');
                description.add('no task');
                timeStarted.add('no task');
                timeStopped.add('no task');
                createdDate.add('no task');
                totalTime.add('0');
            }
        } catch (DMLException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            taskId.add('fail');
            taskName.add('fail');
            description.add('fail');
            timeStarted.add('fail');
            timeStopped.add('fail');
            createdDate.add('fail');
            totalTime.add('fail');
        }
        
        output.add(taskId);
        output.add(taskName);
        output.add(description);
        output.add(timeStarted);
        output.add(timeStopped);
        output.add(createdDate);
        output.add(totalTime);
        
        return output;
    }
}
