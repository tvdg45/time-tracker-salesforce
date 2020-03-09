public class TimeTrackerTaskView {

    //Variables
    public static List<List<String>> taskCategories;
    public static List<List<String>> tasks;
    
    public static String refreshPage() {
        
        String output = '';
        
        output += '<script type=\"text/javascript\">\n';
        output += 'window.location = document.location.href.replace(\"#\", \"\");\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String createTaskErrorMessage() {
        
        String output = '';
        
        output += '<script>\n';
        output += 'document.getElementById("create_task").innerHTML = "<br /><label><span style=\\"color: red; font-size: 12pt\\">You must select a task category.</span></label>";\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String deleteTasksErrorMessage() {
        
        String output = '';
        
        output += '<script>\n';
        output += 'document.getElementById("delete_tasks").innerHTML = "<br /><label><span style=\\"color: red; font-size: 12pt\\">You must select a task before deleting any.</span></label>";\n';
        output += '</script>\n';
        
        return output;
    }
    
    public static String showTaskCategories() {
        
        String output = '';
        
        List<String> find = new List<String>();
        List<String> replace = new List<String>();
        
        find.add('<script');
        find.add('<style');
        find.add('"');
        find.add('\'');
        find.add('<br />');
        find.add('<br>');
        find.add('<div>');
        find.add('</div>');
        
        replace.add('&lt;script');
        replace.add('&lt;style');
        replace.add('&quot;');
        replace.add('&apos;');
        replace.add(' ');
        replace.add('');
        replace.add('');
        replace.add('');
        
        output += '[';
        
        for (Integer i = 0; i < taskCategories.get(0).size(); i++) {
            
            output += '{"row_id": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(taskCategories.get(0).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"task_category_name": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(taskCategories.get(1).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '"}, ';
        }
        
        output += '{}]';
        
        output = output.replace(', {}', '');
        
        return output;
    }
    
    public static String showTasks() {
        
        String output = '';
        
        List<String> find = new List<String>();
        List<String> replace = new List<String>();
        
        find.add('<script');
        find.add('<style');
        find.add('"');
        find.add('\'');
        find.add('<br />');
        find.add('<br>');
        find.add('<div>');
        find.add('</div>');
        
        replace.add('&lt;script');
        replace.add('&lt;style');
        replace.add('&quot;');
        replace.add('&apos;');
        replace.add(' ');
        replace.add('');
        replace.add('');
        replace.add('');
        
        output += '[';
        
        for (Integer i = 0; i < tasks.get(0).size(); i++) {
            
            output += '{"row_id": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(tasks.get(0).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"task_name": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(tasks.get(1).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"description": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(tasks.get(2).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"time_started": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(tasks.get(3).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"time_stopped": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(tasks.get(4).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"date_received": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(tasks.get(5).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '", ';
            output += '"total_time": "' +
                FindAndReplaceUtility.findAndReplace(
                    find, replace, String.valueOf(tasks.get(6).get(i)).replace('<', '&lt;').replace('>', '&gt;')) +
                '"}, ';
        }
        
        output += '{}]';
        
        output = output.replace(', {}', '');
        
        return output;
    }
}
