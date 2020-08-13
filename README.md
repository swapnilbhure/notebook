# notebook

A latex project that can be used as a notebook for a course or a research diary or a logbook. It is a great way to keep a track of all your daily research work or study diary. This is especially useful for anyone using linux as their primary operating system.

Notes written on each day are stored as a seperate file. Even though a new file is created for each day, we can easily compile them files of each day or week or month or even a year with the help of simple single line command. Creating a new file and compilation is done through single line commands from terminal. All you need to be familiar with is using Latex.

**The use of this project does not require any shell scripting or latex style editing or on your part.**

Dependencies:
1. Latex editor. eg. I have used [Texmaker](https://www.xm1math.net/texmaker/download.html)

  You may choose to install just the latex compiler and not a GUI based editor (Texmaker) and use text editor like *gedit* for editing files.
  But using *Texmaker* has its obvious advantages in help with formatting and commands.
  If you are using a different editor, change the editor at line 3 in *run.sh* file.
  
2. Pdf viewer. eg. I have used *evince*

  If using a different pdf viewer,make appropriate changes at line 4 in *run.sh* file.
  
Note: Also, edit the author name in *run.sh* file on line 5, unless you want me to be the author of your notebook ;)

That it, You are good to go and use the *notebook*.

Note: Before using *run.sh* for the first time: Remember to make it execuatable. (To make it execuatable go to the folder location where *run.sh* is, through terminal and execute: *chmod +x run.sh* 

To add a note for today:
```
./run -a
```
To compile a pdf of all notes written over a month of the current year:
```
./run -m <MM>

eg. ./run -m 08
```
For more commands:
```
./run -h
```

The notebook takes advantage of the fact that latex can be used for the creation of documents running over hundreds or even thousands of pages containingpictures, margins, notes, different fonts, typography, tables, complex mathematical equations, etc.
