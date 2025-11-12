/*** HELP START ***//*

Macro name retro_spell_check  
Purpose       : Batch spell verification for all files in a target folder.
                  For each file, runs PROC SPELL with optional custom dictionary,
                  writes the spell output to a per-file .txt, aggregates results,
                  and exports a review-friendly Excel report.

Assumptions :
    - PROC SPELL is an *undocumented* and unsupported SAS procedure.
      It may not be available or functional in modern environments such as SAS Viya.

  Description   :
    1) (Optional) Builds a custom spell dictionary from a plain-text word list.
    2) Iterates over files in &target_folder.
    3) For each file:
         - Routes PROC SPELL output to "&output_folder\<filename>.txt".
         - Uses the custom dictionary if provided.
    4) Reads all generated .txt logs, extracts candidate words,
       pivots them to "word * files", and outputs to Excel.

  Parameters    :
    target_folder=
      Path to the input folder containing files to check.
      Example: D:\Projects\Docs\in

    output_folder=
      Path to the output folder for .txt logs and Excel summary.
      Example: D:\Projects\Docs\out

    extend_dictionary_file=
      (Optional) Path to a text file containing additional valid words,
      one per line. If provided, a WORK catalog dictionary is created and
      used by PROC SPELL.
      Example: D:\Projects\Docs\dic\add_dic.txt


  Usage Example :
    %retro_spell_check(
        target_folder = D:\in,
        output_folder = D:\out
    );

*//*** HELP END ***/

%macro retro_spell_check(
target_folder = 
,output_folder =
,extend_dictionary_file=
)
;

  %if %length(&extend_dictionary_file) ne 0 %then %do;
    filename learn "&extend_dictionary_file.";
    proc spell words  = learn
                create
                dict = work.mycatalog.spell;
    run;
    filename learn clear;
  %end;

  %macro spell_check(target_file)
  ;
  filename target "&target_folder\&target_file";
  proc printto print="&output_folder\&target_file..txt" new;
  run;
  proc spell words=target 
    %if %length(&extend_dictionary_file) ne 0 %then %do;
      dictionary = work.mycatalog.spell
    %end;
    verify 
  ;
  run;
proc printto;
run;
filename target clear;
%mend;

filename DIR1 "&target_folder";
data DT1 ;
   length  VAR  $400 ;
   did = dopen("DIR1") ;
   do i = 1 to dnum( did ) ;
       VAR = cats(dread( did , i )) ;
        output;
   end;
keep VAR;
run;
filename DIR1 clear;

data _null_;
set dt1;
text=cats('%spell_check(',VAR,")");
call execute(text);
run;

filename _log_  "&output_folder\*.txt" ;
data log;
length fname _fname $200. record $256.;
  infile _log_ filename=_fname truncover ; 
  input record 1-256 ;
  fname=tranwrd(kreverse(kscan(kreverse(_fname),1,"\")),".txt","");
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

data output;
set log2;
length=klength(_record);
if UPCASE(_record)=_record then delete;
if 4<=length;
drop length _name_;
label _record = "Word";
run;

ods excel file="&output_folder\spell_chk..xlsx";
 proc print data=output noobs label;
 run;
ods excel close;
%mend;
