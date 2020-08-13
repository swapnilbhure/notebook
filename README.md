# notebook

A latex project that can be used as a notebook for a course or a research diary or a logbook. It is a great way to keep a track of all your daily research work or study diary. This is especially useful for anyone using linux as their primary operating system.

Notes written on each day are stored as a seperate file. Even though a new file is created for each day, we can easily compile them files of each day or week or month or even a year with the help of simple single line command. Creating a new file and compilation is done through single line commands from terminal.

Requirements:
1. Latex editor. eg. [Texmaker](https://www.xm1math.net/texmaker/download.html)
2. Pdf viewer. eg. evince

Make these changes at line 3 and 4 in *run.sh* file.

Note: Also, edit the author name in *run.sh* file on line 5, unless you want me to be the author of your notebook ;)

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
