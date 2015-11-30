# LEDVoiceTimer

**What is it?**

This project's purpose is to create a voice-activated LED timer specifically built for cooking tasks.
Basically, you have a 5 RGB LED device connected to the internet, in which each LED represents a timed task.
Once you set the task and give it a time, the LED will go from green (just started) to red(about to finish).
When a task is done, it will start blinking red to let you know the time is up, and you can clear that LED task
via voice commands shown below.

I am using the Electric Imp [standard dev kit](https://electricimp.com/docs/gettingstarted/devkits/) and the RGB LED Tail which connects to it.
This is the device that represents the timer and the LED board.

I am also using [Wit.ai](https://wit.ai/) in order to create voice tasks spefically created for cooking.

**How to install**

1. Clone the repo go into the iOS directory 
2. Run this in your terminal or bash
```bash
pod install
```
3. Create a new project in the [Electric Imp IDE](https://ide.electricimp.com)
4. Follow the instructions [here](https://electricimp.com/docs/gettingstarted/blinkup/) on how to connect your Electric Imp
4. Copy the .agent.nut file into the Agent section, and the .device.nut into the Device section

**How to use the voice commands**

After you have run the iPhone app, the voice commands are a little tricky and limited because of the new Wit.ai project.
To set a task:
Say "[verb] the [task_item], [duration in minutes]"
(Note: Wit.ai is still learning and I have trained it to respond to "Put the [task_item] in the [location], [duration in minutes]"
  
To delete a task:
Say "[task_item] is done"



Enjoy! An example video is soon to come.

