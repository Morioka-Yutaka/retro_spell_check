Type : Package
Package : retro_spell_check
Title : retro_spell_check
Version : 0.1.0
Author : Yutaka Morioka(sasyupi@gmail.com)
Maintainer : Yutaka Morioka(sasyupi@gmail.com)
License : MIT
Encoding : UTF8
Required : "Base SAS Software"
ReqPackages :  

DESCRIPTION START:
Batch spell verification for all files in a target folder. For each file, runs PROC SPELL with optional custom dictionary, writes the spell output to a per-file .txt, aggregates results, and exports a review-friendly Excel report.

Assumptions :
    - PROC SPELL is an *undocumented* and unsupported SAS procedure.
      It may not be available or functional in modern environments such as SAS Viya.
DESCRIPTION END:
