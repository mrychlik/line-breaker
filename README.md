# line-breaker
An application that breaks up pages of printed text into lines. Multi-lingual and multi-platform. 

## Purpose
This project creates an application geared towards OCR (Optical Character Recognition)
where a page of text (printed or handwritten) has to be divided into smaller
units for processing. Typically these units are lines or columns of text, 
words and ligatures, and characters. The target unit strongly depends
on the language of the source document and script used. The general
principle is that the unit chosen must be contiguous or nearly contiguous
area. For printed English and other Latin scripts the natural unit is a character.
However, for cursive scripts the unit must be larger as characters are connected
even in print. The suitable units are ligatures, or words. But even those
are not easy to robustly identify without analyzing the semantics.

The largest common denominator is a line of text. It is usually easy to identify
and reasonably self-contained from the point of view of semantics.

## Basic functionality
The application takes a scanned page of text as input and breaks in put into
smaller images isolating lines, words or characters, depending on the settings.
The application functions either as an interactive, GUI-based application.


## MATLAB 
The application is natively written in MATLAB and therefore it can be extended
by programming in MATLAB.

## Standalone executables for all major platforms
For those without a MATLAB license we have executables produced with MATLAB.
These executable utilize the full power of the MATLAB Runtime, which 
is distributed by MathWorks for all major platforms. The installers
are provided for 

  * [Linux](./src/LineBreakerApp/for_redistribution) (binary created under Fedora 34)
  * [Windows](./installers/Windows) (binary created under Windows 10)

Note that the installers will automatically download the required
version of MATLAB Runtime as part of the installation process, which
is a 2.5GB download, and thus will take time.
  
## Two variants of the software - GUI and command line

### The GUI variant
The GUI application called *LineBreakerApp* launches a GUI which will allow
breaking up scanned page interactively. In the process, the best parameters
for the particular content are discovered. 

![GUIScreenshot1](./screenshots/GUIScreenshot1.png "GUI screenshot 1")


### The command-line variant
The non-GUI application called simply *LineBreaker* runs from command line
and it will typically be used to process a large number of input files
in batch (non-interactive) mode. 

NOTE: The command-line variant is currently considered for phasing out,
as the batch functionality was added to the GUI. It may be completely
abandoned if the need for it does not exist. It is conceivable,
however, that some users may use remote servers without GUI access to
do batch processing, in which case the command-line variant of *LineBreaker*
would be useful.

*Example:* The command

	./LineBreaker '.../line-breaker/images/*.png' /tmp/Lines Force true
	
on out Linux machine will process all images with extension '.png'
included into this repository and will place the results in the folder
/tmp/Lines (deeply nested, to avoid name conflicts! see folder
[Bingo](.Bingo) for an example).  The option 'Force' is set to 'true'
to allow overwriting files that have already been created.  Furter
options may be supplied on command-line. The options correspond to the
options available in the GUI version.

[TODO: Describe all options that can be provided]

 
 








