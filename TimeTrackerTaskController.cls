public with sharing class TimeTrackerTaskController extends TimeTrackerTaskModel {
    
    //Variables
    public static List<List<String>> searchTaskCategories;
    public static List<List<String>> searchTasks;
    public static String taskCategory;
    public static String taskName;
    public static String taskDescription;
    public static String timeStarted;
    public static String taskId;
    public static String timeStopped;
    public static String[] eachSelectedTask;
    public static String formFeedback;
    
    public static void controlCreateTask() {
        
        taskCategory = Apexpages.currentPage().getParameters().get('taskCategory');
        taskName = Apexpages.currentPage().getParameters().get('taskName');
        taskDescription = Apexpages.currentPage().getParameters().get('taskDescription');
        timeStarted = Apexpages.currentPage().getParameters().get('timeStarted');
        
        if (taskCategory.Equals('Select category')) {
            
            formFeedback = TimeTrackerTaskView.createTaskErrorMessage();
        } else {
            
        	setTaskCategory(taskCategory);
        	setTaskName(taskName);
        	setTaskDescription(taskDescription);
        	setTimeStarted(timeStarted);
            
        	if (createTask().Equals('success')) {
            
            	formFeedback = TimeTrackerTaskView.refreshPage();
        	} else {
            
            	formFeedback = '';
        	}
        }
    }
    
    public static void controlFinishSelectedTask() {
        
        taskId = Apexpages.currentPage().getParameters().get('taskId');
        timeStopped = Apexpages.currentPage().getParameters().get('timeStopped');
        
        setTaskId(taskId);
        setTimeStopped(timeStopped);
        
        if (finishSelectedTask().Equals('success')) {
            
            formFeedback = TimeTrackerTaskView.refreshPage();
        } else {
            
            formFeedback = '';
        }
    }
    
    public static void controlDeleteSelectedTasks() {
        
        eachSelectedTask = Apexpages.currentPage().getParameters().get('selectedTasks').split(',');
        
        if (eachSelectedTask.size() > 0 && !(eachSelectedTask.get(0).Equals(''))) {
            
            setEachSelectedTask(eachSelectedTask);
            
            if (deleteSelectedTasks().Equals('success')) {
                
                formFeedback = TimeTrackerTaskView.refreshPage();
            } else {
                
                formFeedback = '';
            }
        } else {
            
            formFeedback = TimeTrackerTaskView.deleteTasksErrorMessage();
        }
    }
    
    public static String getFormFeedback() {
        
        return formFeedback;
    }
    
    public static String getRequestTaskCategories() {
        
        String output = '';
        
        try {
            
            searchTaskCategories = searchTaskCategories();
            
            if (String.valueOf(searchTaskCategories.get(1).get(0)).equals('no task category')
               || String.valueOf(searchTaskCategories.get(1).get(0)).equals('fail')) {
                
               output = 'no task categories';
            } else {
                
                TimeTrackerTaskView.taskCategories = searchTaskCategories;
                
                output = TimeTrackerTaskView.showTaskCategories();
            }
        } catch (Exception e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            output = '[{"row_id": "", "task_category_name": ""}]';
        }
        
        return output;
    }
    
    public static String getRequestTasks() {
        
        String output = '';
        
        try {
            
            searchTasks = searchTasks();
            
            if (String.valueOf(searchTasks.get(1).get(0)).equals('no task')
               || String.valueOf(searchTasks.get(1).get(0)).equals('fail')) {
                
               output = 'no tasks';
            } else {
                
                TimeTrackerTaskView.tasks = searchTasks;
                
                output = TimeTrackerTaskView.showTasks();
            }
        } catch (Exception e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
            output = '[{"row_id": "", "task_name": "", "description": "", "time_started": "", "time_stopped": "", "date_received": "", "total_time": ""}]';
        }
        
        return output;
    }
}
