http.onrequest(function(request, response){
    
    local path = request.path;
    local query = request.query;
    
    try {
        
        if (path == "/set") 
            setTask(request, response, query);
        else if (path == "/delete") 
            deleteTask(request, response, query);
        else if (path == "/clear")
            clearTasks(request, response, query);
        else
            response.send(200, "Waiting for a command");

  } catch (error) {
    server.log("Error: " + error);
  }
    
});

function setTask(request, response, query){
    if(!("task" in query) || !("time" in query))
        return;
            
    device.send("set", query);
    response.send(200, "Set Task: " + query.task);
    return;
}

function deleteTask(request, response, query){
    if(!("task" in query))
        return;
    
    device.send("delete", query);
    response.send(200, "Delete Task: " + query.task);
    return;
}

function clearTasks(request, response, query){
    device.send("clear", null);
    response.send(200, "Cleared all tasks");
}