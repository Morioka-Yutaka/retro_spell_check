# retro_spell_check
Batch spell verification for all files in a target folder. For each file, runs PROC SPELL with optional custom dictionary, writes the spell output to a per-file .txt, aggregates results, and exports a review-friendly Excel report.

<img width="360" height="360" alt="Image" src="https://github.com/user-attachments/assets/faf23728-e2d9-4b72-933d-ef79a7eb2d4d" />

## `%retro_spell_check()` macro <a name="retrospellcheck-macro-1"></a> ###### 
Purpose       : Batch spell verification for all files in a target folder.　  　
                  For each file, runs PROC SPELL with optional custom dictionary,  
                  writes the spell output to a per-file .txt, aggregates results,  
                  and exports a review-friendly Excel report.  

### Assumptions :  
~~~text
    - PROC SPELL is an *undocumented* and unsupported SAS procedure.  
      It may not be available or functional in modern environments such as SAS Viya.  
~~~

 ### Description   :  
    1) (Optional) Builds a custom spell dictionary from a plain-text word list.  
    2) Iterates over files in &target_folder.  
    3) For each file:  
         - Routes PROC SPELL output to "&output_folder\<filename>.txt".  
         - Uses the custom dictionary if provided.  
    4) Reads all generated .txt logs, extracts candidate words,  
       pivots them to "word * files", and outputs to Excel.  

  ### Parameters    :  
  ~~~sas
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
~~~

 ###  Usage Example :
 ~~~sas
    %retro_spell_check(
        target_folder = D:\in,
        output_folder = D:\out
    );
~~~

<img width="190" height="122" alt="image" src="https://github.com/user-attachments/assets/6732a02a-0c9c-4c93-89d1-5454f0225874" />  
   


<img width="368" height="238" alt="image" src="https://github.com/user-attachments/assets/2bdf516b-9c4e-48ea-9d63-1e503608c668" />    

▽  
▽  
▽  

<img width="540" height="410" alt="image" src="https://github.com/user-attachments/assets/7f577f87-4bf9-4501-96bf-b48399aad1df" />  
  
<img width="254" height="234" alt="image" src="https://github.com/user-attachments/assets/ea7533ec-77e1-4c32-a400-b3acbd1faf6a" />



#### To prevent terms like “proc” or “ttest” from triggering spell checks, create an additional dictionary in a text file and load it.

<img width="260" height="196" alt="image" src="https://github.com/user-attachments/assets/970b7c51-fbbf-4a5f-8e02-2e1c43950142" />　　

~~~sas
%retro_spell_check(
target_folder = D:\in
,output_folder =D:\out
,extend_dictionary_file=D:\add_dic.txt
)
~~~

<img width="508" height="346" alt="image" src="https://github.com/user-attachments/assets/de0a5893-ef87-4dc3-b894-88318ece87e3" />


---

## Notes on versions history
- 0.1.0(13ONovember2025): Initial version.

---

## What is SAS Packages?

The package is built on top of **SAS Packages Framework(SPF)** developed by Bartosz Jablonski.

For more information about the framework, see [SAS Packages Framework](https://github.com/yabwon/SAS_PACKAGES).

You can also find more SAS Packages (SASPacs) in the [SAS Packages Archive(SASPAC)](https://github.com/SASPAC).

## How to use SAS Packages? (quick start)

### 1. Set-up SAS Packages Framework

First, create a directory for your packages and assign a `packages` fileref to it.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
filename packages "\path\to\your\packages";
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Secondly, enable the SAS Packages Framework.
(If you don't have SAS Packages Framework installed, follow the instruction in 
[SPF documentation](https://github.com/yabwon/SAS_PACKAGES/tree/main/SPF/Documentation) 
to install SAS Packages Framework.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%include packages(SPFinit.sas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### 2. Install SAS package

Install SAS package you want to use with the SPF's `%installPackage()` macro.

- For packages located in **SAS Packages Archive(SASPAC)** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located in **PharmaForest** run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, mirror=PharmaForest)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- For packages located at some network location run:
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
  %installPackage(packageName, sourcePath=https://some/internet/location/for/packages)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (e.g. `%installPackage(ABC, sourcePath=https://github.com/SomeRepo/ABC/raw/main/)`)


### 3. Load SAS package

Load SAS package you want to use with the SPF's `%loadPackage()` macro.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sas
%loadPackage(packageName)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### Enjoy!
  
