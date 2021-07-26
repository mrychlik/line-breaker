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
The application functions either as an interactive, GUI-based application,
or in batch mode as a standalone, GUI-less executable.

## MATLAB 
The application is natively written in MATLAB and therefore it can be extended
by programming in MATLAB.

## Standalone executables for all major platforms
For those without a MATLAB license we have executables produced with MATLAB.
These executable utilize the full power of the MATLAB Runtime, which 
is distributed by MathWorks for all major platforms. The installers
are provided for 

  * Linux (binary created under Fedora 34)
  * Windows (binary created under Windows 10)

Note that the installers will automatically download the required
version of MATLAB Runtime as part of the installation process, which
is a 2.5GB download, and thus will take time.
  





