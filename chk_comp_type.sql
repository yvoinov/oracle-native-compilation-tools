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
rem -- IDENTIFICATION: chk_comp_type.sql                                    --
rem -- DESCRIPTION: Script for cchecking PL/SQL compilation settingsg.      --
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
 Check PL/SQL units compilation type settings. Must be run as
 SYS account as SYSDBA. Input SYS password and ORACLE_SID.
#############################################################
#############################################################
#

connect / as sysdba

set verify off
set echo on

col plsql_code_type format a20

spool chk_comp_type.log

select type, plsql_code_type, count(*)
from dba_plsql_object_settings
where plsql_code_type is not null
group by type, plsql_code_type
order by type, plsql_code_type;

spool off

disconnect

exit
