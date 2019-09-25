#!/bin/bash

myEditor="texmaker"
myViewer="evince"
tYYYY=$(date +%G)
tMon=$(date +%b)
tMM=$(date +%m)
tDD=$(date +%d)
tDay=$(date +%A)
tWW=$(date +%W)
notesDir="notes"
pdfDir="pdfs"
figureDir="figures"
filesDir="files"
todaysFileName="$tYYYY-$tMM-$tDD.tex"
author="Swapnil Bhure"
notebookStyle="notebook.sty"
Date="meh"
monthToCompile="meh"
yearToCompile="meh"
range="meh"

addTodaysEntry ()
{
    echo "Today is $tDD/$tMon/$tYYYY."
    echo "Your Notes are located in: $notesDir/."

    if [ ! -d "$notesDir" ]; then
        mkdir "$notesDir"
    fi
    if [ ! -d "$notesDir/$tYYYY" ]; then
        mkdir "$notesDir/$tYYYY"
        mkdir "$notesDir/$tYYYY/$pdfDir"
        mkdir "$notesDir/$tYYYY/$figureDir"
        mkdir "$notesDir/$tYYYY/$filesDir"
    fi
    echo "Adding new entry to directory $notesDir/$tYYYY/."

    cd "$notesDir/$tYYYY" || exit -1
    filename="$todaysFileName"

    if [ ! -f "$notebookStyle" ]; then
        ln -s ../../classes/$notebookStyle .
    fi

    if [ -f "$filename" ]; then
        echo "File for today already exists: $notesDir/$tYYYY/$filename."
        echo "Opening file... Happy writing!"
	$myEditor "$filename"&
    else
	cp ../../templates/todaysEntry.tex "$filename"

	sed -i "s/@tYYYY/$tYYYY/g" "$filename"
	sed -i "s/@tMon/$tMon/g" "$filename"
	sed -i "s/@tDD/$tDD/g" "$filename"
  sed -i "s/@tWW/$tWW/g" "$filename"
  sed -i "s/@tDay/$tDay/g" "$filename"

	echo "Finished adding $filename to $notesDir/$tYYYY/."
	echo "Opening file... Happy writing!"
      	$myEditor "$filename"&
	cd ../../ || exit -1
    fi

}

addOtherEntry ()
{
    DD=`echo $Date | cut -d - -f 1`
    MM=`echo $Date | cut -d - -f 2`
    YYYY=`echo $Date | cut -d - -f 3`
    echo "Adding Entry for the date: $YYYY-$MM-$DD to the directory: $notesDir/$YYYY"
    if [ ! -d "$notesDir" ]; then
        mkdir "$notesDir"
    fi
    if [ ! -d "$notesDir/$YYYY" ]; then
        mkdir "$notesDir/$YYYY"
        mkdir "$notesDir/$YYYY/$pdfDir"
        mkdir "$notesDir/$YYYY/$figureDir"
        mkdir "$notesDir/$YYYY/$filesDir"
    fi
    cd "$notesDir/$YYYY" || exit -1
    filename="$YYYY-$MM-$DD.tex"

    if [ -f "$filename" ]; then
        echo "File already exists: $notesDir/$YYYY/$filename."
        echo "Opening file... Happy writing!"
	$myEditor "$filename"&
    else
	cp ../../templates/otherEntry.tex "$filename"

	sed -i "s/@YYYY/$YYYY/g" "$filename"
  sed -i "s/@Mon/$(date --date=$MM/$DD/$YYYY +%b)/g" "$filename"
	sed -i "s/@DD/$DD/g" "$filename"
  sed -i "s/@WW/$(date --date=$MM/$DD/$YYYY +%W)/g" "$filename"
  sed -i "s/@Day/$(date --date=$MM/$DD/$YYYY +%A)/g" "$filename"

	echo "Finished adding $filename to $notesDir/$YYYY/."
	echo "Opening file... Happy writing!"
	$myEditor "$filename" &
	cd ../../ || exit -1
    fi

}

openTexTodaysEntry()
{
    cd "$notesDir/$tYYYY" || exit -1
    filename="$todaysFileName"
    if [ -f "$filename" ] ; then
	     $myEditor "$filename" &
    else
	     echo "File does not exist."
    fi
}

openTexOtherEntry()
{
    DD=`echo $Date | cut -d - -f 1`
    MM=`echo $Date | cut -d - -f 2`
    YYYY=`echo $Date | cut -d - -f 3`
    cd "$notesDir/$YYYY" || exit -1
    filename="$YYYY-$MM-$DD.tex"
    if [ -f "$filename" ] ; then
	     $myEditor "$filename" &
    else
	     echo "File does not exist."
    fi
}
openPdfTodaysEntry()
{
    cd "$notesDir/$tYYYY/$pdfDir" || exit -1
    filename="$tYYYY-$tMM-$tDD.pdf"
    if [ -f "$filename" ] ; then
	     $myViewer "$filename" &
    else
	echo "File does not exist."
    fi
}

openPdfOtherEntry()
{
    DD=`echo $Date | cut -d - -f 3`
    MM=`echo $Date | cut -d - -f 2`
    YYYY=`echo $Date | cut -d - -f 1`
    cd "$notesDir/$YYYY/$pdfDir" || exit -1
    filename="$Date.pdf"
    if [ -f "$filename" ] ; then
	     $myViewer "$filename" &
    else
	     echo "File does not exist."
    fi
}

clean ()
{
    echo "Cleaning up.."
    rm -fv -- *.aux *.bbl *.blg *.log *.nav *.out *.snm *.toc *.dvi *.vrb *.bcf *.run.xml *.cut *.lo* *.brf* *synctex.gz *.fls *.fdb*
    latexmk -c
}


compileToday ()
{
    cd "$notesDir/$tYYYY/" || exit -1
    echo "Compiling Today's Entry: $todaysFileName."
    fname="compileToday"
    filename="$fname.tex"
    pdfname="$fname.pdf"
    dname="$tYYYY-$tMM-$tDD"
    if [ -f "$filename" ]; then
	     rm $filename
    fi
    if [ ! -f "$notebookStyle" ]; then
        ln -s ../../classes/$notebookStyle .
    fi
    cp ../../templates/$filename .

    sed -i "s/@tYYYY/$tYYYY/g" "$filename"
    sed -i "s/@tMM/$tMM/g" "$filename"
    sed -i "s/@tMon/$tMon/g" "$filename"
    sed -i "s/@tDD/$tDD/g" "$filename"
    sed -i "s/@author/$author/g" "$filename"

    if ! latexmk -f -pdf -quiet -recorder -pdflatex="pdflatex -interaction=nonstopmode --shell-escape -synctex=1" "$filename" ; then
        echo "Compilation failed. Exiting."
    fi
    if [ ! -d "$pdfDir" ]; then
	     mkdir "pdfs"
    fi
    rm "$filename"
    clean
    mv "$pdfname" "pdfs/$dname.pdf"
    $myViewer "pdfs/$dname.pdf" &
}
compileOtherDay ()
{
    DD=`echo $Date | cut -d - -f 1`
    MM=`echo $Date | cut -d - -f 2`
    YYYY=`echo $Date | cut -d - -f 3`
    cd "$notesDir/$YYYY/" || exit -1
    echo "Compiling Entry for the date: $YYYY-$MM-$DD"
    fname="compileOtherDay"
    filename="$fname.tex"
    pdfname="$fname.pdf"
    dname="$YYYY-$MM-$DD"
    if [ -f "$filename" ]; then
	     rm $filename
    fi
    if [ ! -f "$notebookStyle" ]; then
        ln -s ../../classes/$notebookStyle .
    fi
    cp ../../templates/$filename .

    sed -i "s/@YYYY/$YYYY/g" "$filename"
    sed -i "s/@MM/$MM/g" "$filename"
    sed -i "s/@DD/$DD/g" "$filename"
    sed -i "s/@tdate/$date/g" "$filename"
    sed -i "s/@author/$author/g" "$filename"
    sed -i "s/@Mon/$(date --date=$MM/$DD/$YYYY +%b)/g" "$filename"

    if ! latexmk -f -pdf -quiet -recorder -pdflatex="pdflatex -interaction=nonstopmode --shell-escape -synctex=1" "$filename" ; then
        echo "Compilation failed. Exiting."
    fi
    if [ ! -d "$pdfDir" ]; then
	     mkdir "pdfs"
    fi
    rm $filename
    clean
    mv "$pdfname" "pdfs/$dname.pdf"
    $myViewer "pdfs/$dname.pdf" &
}
compileMonth ()
{
    MM=$monthToCompile
    cd "$notesDir/$tYYYY/" || exit -1
    echo "Compiling Entry for the month: $MM/$tYYYY."
    fname="compileMonth"
    filename="$fname.tex"
    pdfname="$fname.pdf"
    dname="$tYYYY-$MM"
    if [ -f "$filename" ]; then
	     rm $filename
    fi
    cp ../../templates/$filename .

    sed -i "s/@tdate/$(date)/g" "$filename"
    sed -i "s/@tYYYY/$tYYYY/g" "$filename"
    sed -i "s/@MM/$MM/g" "$filename"
    sed -i "s/@author/$author/g" "$filename"

    if ! latexmk -f -pdf -quiet -recorder -pdflatex="pdflatex -interaction=nonstopmode --shell-escape -synctex=1" "$filename" ; then
        echo "Compilation failed. Exiting."
        clean
    fi
    if [ ! -d "$pdfDir" ]; then
	     mkdir "pdfs"
    fi
    rm $filename
    clean
    mv "$pdfname" "pdfs/$dname.pdf"
    $myViewer "pdfs/$dname.pdf" &

}

compileOtherMonth ()
{
    MM=`echo $monthToCompile | cut -d - -f 1`
    YYYY=`echo $monthToCompile | cut -d - -f 2`

#    if [ -z "$YYYY" ]; then
#      YYYY=$tYYYY
#    fi

    cd "$notesDir/$YYYY/" || exit -1
    echo "Compiling Entry for the month: $MM/$YYYY."
    fname="compileOtherMonth"
    filename="$fname.tex"
    pdfname="$fname.pdf"
    dname="$YYYY-$MM"
    if [ -f "$filename" ]; then
	     rm $filename
    fi
    cp ../../templates/$filename .

    sed -i "s/@tdate/$(date)/g" "$filename"
    sed -i "s/@YYYY/$YYYY/g" "$filename"
    sed -i "s/@MM/$MM/g" "$filename"
    sed -i "s/@author/$author/g" "$filename"

    if ! latexmk -f -pdf -quiet -recorder -pdflatex="pdflatex -interaction=nonstopmode --shell-escape -synctex=1" "$filename" ; then
        echo "Compilation failed. Exiting."
    fi
    if [ ! -d "$pdfDir" ]; then
	     mkdir "pdfs"
    fi
    rm $filename
    clean
    mv "$pdfname" "pdfs/$dname.pdf"
    $myViewer "pdfs/$dname.pdf" &

}

compileYear ()
{
    YYYY=$yearToCompile
    if [ ! -d "$notesDir/$YYYY/" ]; then
      echo "$notesDir/$YYYY/ does not exist. Exiting."
      exit -1
    fi
    cd "$notesDir/$YYYY/" || exit -1
    echo "Compiling Entry for the year: $YYYY."
    fname="compileYear"
    filename="$fname.tex"
    pdfname="$fname.pdf"
    dname="$YYYY"
    if [ -f "$filename" ]; then
	rm $filename
    fi
    cp ../../templates/$filename .

    sed -i "s/@tdate/$(date)/g" "$filename"
    sed -i "s/@YYYY/$YYYY/g" "$filename"
    sed -i "s/@author/$author/g" "$filename"

    if ! latexmk -f -pdf -quiet -recorder -pdflatex="pdflatex -interaction=nonstopmode --shell-escape -synctex=1" "$filename" ; then
        echo "Compilation failed. Exiting."
        clean
    fi
    if [ ! -d "$pdfDir" ]; then
	mkdir "pdfs"
    fi
    rm $filename
    clean
    mv "$pdfname" "pdfs/$dname.pdf"
    $myViewer "pdfs/$dname.pdf" &

}


compileRange ()
{
    sD=`echo $range | cut -d - -f 1`
    sM=`echo $range | cut -d - -f 2`
    sY=`echo $range | cut -d - -f 3`
    eD=`echo $range | cut -d - -f 4`
    eM=`echo $range | cut -d - -f 5`
    eY=`echo $range | cut -d - -f 6`

    cd "$notesDir" || exit -1
    echo "Research Diary"
    echo "Author: $author"
    echo "Compiling Date Ranges: $sY-$sM-$sD to $eY-$eM-$eD"
    fname="compileRange"
    filename="$fname.tex"
    pdfname="$fname.pdf"
    dname="range-$sY-$sM-$sD-to-$eY-$eM-$eD"
    if [ -f "$filename" ]; then
	rm $filename
    fi
    if [ -e "$filename" ]; then
	echo "File $filename already exits. Erasing and re-writing a new file"
	rm $filename
    fi
    cp ../templates/$filename .

    if [ ! -e "$notebookStyle" ]; then
        ln -sf ../classes/$notebookStyle .
    fi

    sed -i "s/@author/$author/g" "$filename"
    sed -i "s/@tYYYY/$(date +%G)/g" "$filename"
    sed -i "s/@tMM/$(date +%b)/g" "$filename"
    sed -i "s/@tDD/$(date +%e)/g" "$filename"
    sed -i "s/@tdate/$(date)/g" "$filename"
    sed -i "s/@sY/$sY/g" "$filename"
    sed -i "s/@sM/$sM/g" "$filename"
    sed -i "s/@sD/$sD/g" "$filename"
    sed -i "s/@eY/$eY/g" "$filename"
    sed -i "s/@eM/$eM/g" "$filename"
    sed -i "s/@eD/$eD/g" "$filename"


    if ! latexmk -f -pdf -recorder -pdflatex="pdflatex -interaction=nonstopmode --shell-escape -synctex=1" $filename; then
        echo "Compilation failed. Exiting."
        clean
    fi

    if [ ! -d "$pdf_dir/" ]; then
        mkdir -p $pdf_dir
    fi
    if [ ! -d "$pdfDir" ]; then
	mkdir "pdfs"
    fi
    rm $filename
    clean
    mv "$pdfname" "pdfs/$dname.pdf"
    $myViewer "pdfs/$dname.pdf" &

}

compileSection ()
{
    cd "$notesDir/$tYYYY/" || exit -1
    echo "Compiling Today's Entry: $todaysEntryDate."
    fname="lT"
    filename="$fname.tex"
    pdfname="$fname.pdf"
    dname="sec-$YYYY-$MM-$DD"
    if [ -f "$filename" ]; then
	rm $filename
    fi
    cp ../../templates/$filename .

    sed -i "s/@tYYYY/$tYYYY/g" "$filename"
    sed -i "s/@tMM/$tMM/g" "$filename"
    sed -i "s/@tMon/$tMon/g" "$filename"
    sed -i "s/@tDD/$tDD/g" "$filename"
    sed -i "s/@author/$author/g" "$filename"

    if ! latexmk -f -pdf -quiet -recorder -pdflatex="pdflatex -interaction=nonstopmode --shell-escape -synctex=1" "$filename" ; then
        echo "Compilation failed. Exiting."
        clean
        #exit -1
    fi
    if [ ! -d "$pdfDir" ]; then
	mkdir "pdfs"
    fi
    rm $filename
    clean
    mv "$pdfname" "pdfs/$dname.pdf"
    $myViewer "pdfs/$dname.pdf" &
}

usage ()
{
    cat << EOF
    usage: $0 options

    Master script file that provides functions to maintain a journal using LaTeX.

    OPTIONS:
    -h  Show this message and quit

    -a  Add new entry for today

    -A <DD-MM-YYYY>  Add new entry for other day

    -o  Open entry for today

    -O <DD-MM-YYYY>  Open entry for other day

    -p  Open pdf for today's entry

    -P <YYYY-MM-DD>	Open pdf of other day
       <YYYY-MM>	Open pdf of a month
       <YYYY>		Open pdf of an year

    -c  Compile today's entry

    -C <DD-MM-YYYY>  Compile other day's entry

    -m <MM>  Compile a month of the current year

    -m <MM-YYYY>  Compile a month of an year

    -y <YYYY>  Compile all entries of the year

    -r <DD-MM-YYYY-DD-MM-YYYY>  Compile entries in the range: from-to

    -z clean junk

EOF

}

if [ "$#" -eq 0 ]; then
    usage
    exit 0
fi

while getopts "aA:oO:pP:cC:m:M:y:hr:s" OPTION
do
    case $OPTION in
        a)
            addTodaysEntry
            exit 0
            ;;
	A)
	    Date=$OPTARG
            addOtherEntry
            exit 0
            ;;
	o)
	    openTexTodaysEntry
	    exit 0
	    ;;
      O)
          Date=$OPTARG
                openTexOtherEntry
                exit 0
                ;;
	p)
	    openPdfTodaysEntry
	    exit 0
	    ;;
	P)
	    Date=$OPTARG
            openPdfOtherEntry
            exit 0
            ;;

	c)
            compileToday
            exit 0
            ;;
	C)
	    Date=$OPTARG
            compileOtherDay
            exit 0
            ;;
	m)
	    monthToCompile=$OPTARG
            compileMonth
            exit 0
            ;;
	M)
	    monthToCompile=$OPTARG
            compileOtherMonth
            exit 0
            ;;
        y)
            yearToCompile=$OPTARG
            compileYear
            exit 0
            ;;
	s)
            compileSection
            exit 0
            ;;
        h)
            usage
            exit 0
            ;;
	r)
	    range=$OPTARG
	    compileRange
	    exit 0
	    ;;
        ?)
            usage
            exit 0
            ;;

    z)
      clean
      exit 0
      ;;
    esac
done
