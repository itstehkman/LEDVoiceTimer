#require "WS2812.class.nut:2.0.1"

const NUMPIXELS = 5;
spi <- hardware.spi257;
spi.configure(MSB_FIRST, 7500);
pixels <- WS2812(spi, NUMPIXELS);

const MAX_TASKS = 5;
local timer = null;

//our most important variables
//tasks is the table of tasks that are shown on the LEDs
local tasks = {};
local blinkNum = 0;
local blinkOn = false;

//which range in 'tasks' to show
local startRange = 0;
local endRange = 4;


/*-----------------------------TASK CLASS-------------------*/
//This class represents a single Task on the timer.
class Task{
    
    taskName = null;
    timeFull = null;
    timeLeft = null;
    //this is the timestamp to finish the timer from
    //hardware.millis()
    hardwareTimeToFinish = null;
    hardwareTimeStart = null;
    
    //used to determine when to blink
    done = false;
    
    constructor(task, time){
        taskName = task;
        hardwareTimeStart = hardware.millis();
        hardwareTimeToFinish = hardwareTimeStart + time;
        updateTime();
    }
    
    function getColor(){
        updateTime();
        local r = 255 * (timeFull - timeLeft)/timeFull;
        local g = 255 * timeLeft/timeFull;
        local b = 0;
        
        return !done ? [r,g,b] : blinkColor();
        
    }
    
    function updateTime(){
        if(timeLeft != null && timeLeft <= 0)
            return;
            
        timeFull = hardwareTimeToFinish - hardwareTimeStart;
        timeLeft = hardwareTimeToFinish - hardware.millis();
        
        timeFull = timeFull.tofloat();
        timeLeft = timeLeft.tofloat();
        
        if(timeLeft <= 0)
            done = true;
    }
    
    //red blinking to indicate the task is done
    //this is used by the getColor task, and is sensitive
    // to time. it returns no color or a red blink,
    // depending on the time.
    function blinkColor(){
        return blinkOn ? [255,0,0] : [0,0,0];
    }
    
}

/*-----------HELPER FUNCTIONS---------------------------*/

//must be called to start update
//because the imp timer almost always has to be reset
function updateInit(){
    if(timer != null)
       imp.cancelwakeup(timer);
       
    update();
}

function update(){
    local end = endRange < tasks.len() ? endRange : tasks.len() - 1;
    
    for(local i = startRange; i <= endRange; i++){
        if(i in tasks)
            pixels.set(i-startRange, tasks[i].getColor());
        else
            pixels.set(i-startRange, [0,0,0]);
        
    }
    
    if(blinkNum++ % 239 == 0)
        blinkOn = !blinkOn;
        
    pixels.draw();
    timer = imp.wakeup(0, update);
}

function addTask(params){
    local taskName = params.task;
    local time = params.time.tointeger()*60*1000;

    //find first empty spot
    for(local i = 0; i < MAX_TASKS; i++){
        if(!(i in tasks)){
            tasks[i] <- Task(taskName, time);
            break;
        }
    }

    updateInit();
}

//bug 1: if we populate our table with 5 of the same task
//and call deleteTask(params.task="someTask"), the 5th
//task will not be deleted
function deleteTask(params){
    local taskName = params.task;
    
    foreach(k,v in tasks){
        server.log(k + " " + v.taskName);
        if(v.taskName == taskName){
            delete tasks[k];
        }
    }
    
    updateInit();
}

function clearTasks(params){
    tasks.clear();
    updateInit();
}

//set callback functions
agent.on("set", addTask);
agent.on("delete", deleteTask);
agent.on("clear", clearTasks);