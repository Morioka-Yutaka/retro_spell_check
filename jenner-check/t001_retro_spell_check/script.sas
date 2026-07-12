/* jenner-check bundle: t001_retro_spell_check
   Source: retro_spell_check/06_macro/retro_spell_check.sas (Morioka-Yutaka/retro_spell_check)

   This bundle exercises the aggregation/reporting half of %retro_spell_check
   verbatim: the log-parsing DATA step and the SORT/TRANSPOSE word-by-file
   pivot (lines 91-138 of the original macro, unchanged apart from swapping
   the source fileref). The final filter+print block (the macro's lines
   140-152) is not included in this bundle -- see notes below.

   PROC SPELL itself -- the macro's step that scans each target file and
   writes one .txt log of candidate misspelled words per file -- is an
   undocumented, unsupported SAS procedure. The macro's own README already
   flags it: "may not be available or functional in modern environments such
   as SAS Viya." It is not yet implemented in this Jenner build either. So
   this bundle mocks PROC SPELL's own output instead of the input files it
   would normally scan: two small per-file candidate-word logs, written
   inline below to temp filerefs (self-contained, so a single script=@file
   POST reproduces it -- no input/ directory required), shaped exactly like
   what PROC SPELL VERIFY writes (banner/date noise, "File:", "Unrecognized
   Words" header, one candidate word per line). That is the same shape the
   macro's own log-parsing step below is written to filter. Every line of
   SAS from "data log;" through "proc transpose" is the author's, copied
   unchanged. */

filename doc1 temp;
data _null_;
  file doc1;
  put "SAS System   Friday, July 10, 2026";
  put " ";
  put "The SPELL Procedure";
  put "File: doc1.txt";
  put " ";
  put "Unrecognized Words";
  put " ";
  put "acheive";
  put "recieve";
  put "seperate";
  put "definately";
  put "occured";
run;

filename doc2 temp;
data _null_;
  file doc2;
  put "SAS System   Friday, July 10, 2026";
  put " ";
  put "The SPELL Procedure";
  put "File: doc2.txt";
  put " ";
  put "Unrecognized Words";
  put " ";
  put "acheive";
  put "occured";
  put "teh";
  put "wich";
  put "enviroment";
run;

data _raw1;
length fname $200. record $256.;
  infile doc1 truncover;
  input record 1-256;
  fname="doc1";
run;

data _raw2;
length fname $200. record $256.;
  infile doc2 truncover;
  input record 1-256;
  fname="doc2";
run;

data _raw;
  set _raw1 _raw2;
run;

data log;
set _raw;
length fname $200. record $256.;
  _record =kscan(record,1," ");
  if missing(_record) then delete;
  if kindex(_record,"SAS") then delete;
  if kindex(_record,"Monday,") then delete;
  if kindex(_record,"Tuesday,") then delete;
  if kindex(_record,"Wednesday,") then delete;
  if kindex(_record,"Thursday,") then delete;
  if kindex(_record,"Friday,") then delete;
  if kindex(_record,"Saturday,") then delete;
  if kindex(_record,"Sunday,") then delete;
  if kindex(_record,"File:") then delete;
  if kindex(_record,"The") then delete;
  if kindex(_record,"Unrecognized") then delete;
  if kindex(_record,"837483408343838B"x) then delete;
  if kindex(_record,"534153"x) then delete;
  if kindex(_record,"1") then delete;
  if kindex(_record,"2") then delete;
  if kindex(_record,"3") then delete;
  if kindex(_record,"4") then delete;
  if kindex(_record,"5") then delete;
  if kindex(_record,"6") then delete;
  if kindex(_record,"7") then delete;
  if kindex(_record,"8") then delete;
  if kindex(_record,"9") then delete;
  if kindex(_record,"0") then delete;
  drop record;
run;

proc sort data=log ;
 by _record;
run;

proc transpose data=log out=log2 prefix=PG_;
 var fname;
 by _record;
run;

proc print data=log2 noobs;
run;

/* The macro's final block filters/prints via a variable literally named
   LENGTH (length=klength(_record); ... if 4<=length; drop length _name_;) --
   valid SAS (LENGTH is a context-sensitive statement keyword, not a globally
   reserved word, so it is legal as an ordinary assigned variable name here)
   but not yet handled by this Jenner build in that position, so it is left
   out of this bundle rather than shipped in a failing state. */
