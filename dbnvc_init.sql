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
rem -- IDENTIFICATION: dbnvc_init.sql                                       --
rem -- DESCRIPTION: Script for switchover Native Compilation init params.   --
rem --              Must be run as SYS.                                     --
rem --                                                                      --
rem --                                                                      --
rem -- INTERNAL_FILE_VERSION: 0.0.0.2                                       --
rem --                                                                      --
rem -- COPYRIGHT: Yuri Voinov (C) 2006,2008                                 --
rem --                                                                      --
rem -- MODIFICATIONS:                                                       --
rem -- 02.11.2006 -Initial code written.                                    --
rem --------------------------------------------------------------------------

doc
#############################################################
#############################################################
 Script for switchover Native Compilation init parameters.

 Must be run as SYS account as SYSDBA.

 Input compilation mode (NATIVE or INTERPRET,default NATIVE),
 lib subdirectories count (default 100), native PL/SQL
 library directory (where subdirectories created).

 Note 1: Subdirectories must be created first with generated
         script make_dirs.* (create with make_dirs.sql).
 Note 2: BEWARE! Native library directiry must exists and has
         enough file rights for oracle account!
 Note 3: Parameters will be set for BOTH - SPFILE and memory.
#############################################################
#############################################################
#
prompt
prompt <Input SYS password and Oracle SID>
accept nc_mode char default 'native' -
prompt 'Input mode (NATIVE or INTERPRETED, default NATIVE): '
accept p_subdirs char default '100' -
prompt 'Input subdirectories count (default 100):'
accept p_nc_dir char -
prompt 'Input NC PL/SQL directory name:'

connect / as sysdba

set verify off
set echo on
set serveroutput on

spool dbnvc_init.log

declare

 v_mode varchar2(50) := lower('&nc_mode');
 v_ddl varchar2(255);
 v_nc_lib_dir varchar2(255) := '&p_nc_dir';
 v_dirs number := to_number('&p_subdirs');

begin
 dbms_output.put_line('Native Compilation init parameters:');
 dbms_output.put_line('-----------------------------------');
 if v_mode in ('native','interpreted') and v_mode = 'native' then
  v_ddl := 'alter system set plsql_code_type=native scope=both';
 elsif v_mode in ('native','interpreted') and v_mode = 'interpret' then
  v_ddl := 'alter system set plsql_code_type=interpreted scope=both';
 end if;
  execute immediate v_ddl;
  dbms_output.put_line('plsql_code_type='||v_mode||' is set.');
 if v_mode = 'native' then
  v_ddl := 'alter system set plsql_native_library_dir='''||v_nc_lib_dir||''' scope=both';
  execute immediate v_ddl;
  dbms_output.put_line('plsql_native_library_dir='||v_nc_lib_dir||' is set.');
  v_ddl := 'alter system set plsql_native_library_subdir_count='||v_dirs||' scope=both';
  execute immediate v_ddl;
  dbms_output.put_line('plsql_native_library_subdir_count='||v_dirs||' is set.');
 end if;
exception
 when others then raise_application_error(-20100, 'ORA'||SQLCODE||' raised.');
end;
/

spool off

set echo off
set serveroutput off

disconnect

exit
