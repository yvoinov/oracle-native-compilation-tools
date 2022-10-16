rem --------------------------------------------------------------------------
rem -- PROJECT_NAME: DBNC                                                   --
rem -- RELEASE_VERSION: 1.0.0.1                                             --
rem -- RELEASE_STATUS: Release                                              --
rem --                                                                      --
rem -- REQUIRED_ORACLE_VERSION: 10.2.0.x                                    --
rem -- MINIMUM_ORACLE_VERSION: 10.1.0.x                                     --
rem -- MAXIMUM_ORACLE_VERSION: 11.x.x.x                                     --
rem -- PLATFORM_IDENTIFICATION: Generic                                     --
rem --                                                                      --
rem -- IDENTIFICATION: make_dirs.sql                                        --
rem -- DESCRIPTION: Script for native subdirectories creation script        --
rem --              generation.(PLSQL_NATIVE_LIBRARY_SUBDIR_COUNT).         --
rem --              Must be run as SYS. Script will be platform-specific.   --
rem --                                                                      --
rem --                                                                      --
rem -- INTERNAL_FILE_VERSION: 0.0.0.2                                       --
rem --                                                                      --
rem -- COPYRIGHT: Yuri Voinov (C) 2006,2008                                 --
rem --                                                                      --
rem -- MODIFICATIONS:                                                       --
rem -- 15.05.2008 -Bug with DBMS_OUTPUT buffer exception (in 10R2).         --
rem -- 02.11.2006 -Initial code written.                                    --
rem --------------------------------------------------------------------------

doc
#############################################################
#############################################################
 Script for native subdirectories creation script generation.
 (PLSQL_NATIVE_LIBRARY_SUBDIR_COUNT). Must be run as SYS.

 Generated script will be platform-specific (BAT for Windows,
 SH for UNIX and other platforms).

 Input subdirectories count.
 (Default subdirectories count is 100)
#############################################################
#############################################################
#
prompt
prompt <Input SYS password, subdirectories count and Oracle SID>
accept p_subdirs char default '100' -
prompt 'Input subdirectories count (default 100):'

connect / as sysdba

set serveroutput on
set verify off
set echo off
set feedback off

column spool_cmd2 new_value spool_cmd
select decode(substr(dbms_utility.port_string, -
              instr(dbms_utility.port_string,'WIN'),3), -
              'WIN','make_dirs.bat','make_dirs.sh') spool_cmd2
from dual;

spool &spool_cmd

declare
 v_platform varchar2(500);
begin
 begin
  dbms_output.enable(&p_subdirs*100); -- Enable dbms_output and
                                      -- set enough buffer. For 10R2.
 exception
  when others then null; -- Catch any exception in DB prior to 10R2
 end;
 v_platform := substr(dbms_utility.port_string,instr(dbms_utility.port_string,'WIN'),3);
 if v_platform = 'WIN' then
  dbms_output.put_line('@Echo off');
  dbms_output.put_line('rem Make '||&p_subdirs||' subdirs for use with PLSQL_NATIVE_LIBRARY_SUBDIR_COUNT parameter');
  dbms_output.put_line('rem Must be run as Oracle Software owner under PLSQL_NATIVE_LIBRARY_DIR');
  dbms_output.put_line('rem This is generated file by script make_dirs.sql');
 else
  dbms_output.put_line('#!/bin/sh');
  dbms_output.put_line('# Make '||&p_subdirs||' subdirs for use with PLSQL_NATIVE_LIBRARY_SUBDIR_COUNT parameter');
  dbms_output.put_line('# Must be run as Oracle Software owner under PLSQL_NATIVE_LIBRARY_DIR');
  dbms_output.put_line('# This is generated file by script make_dirs.sql');
 end if;
 -- Create mkdir commands
 for j in 0..&p_subdirs
 loop
   dbms_output.put_line('mkdir d'||to_char(j));
 end loop;
exception
 when others then
  raise_application_error(-20099, 'ORA'||SQLCODE||' raised.');
end;
/

spool off
set serveroutput off
set feedback on

disconnect

exit
