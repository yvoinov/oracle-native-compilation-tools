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
rem -- IDENTIFICATION: pre_upd_invalid.sql                                  --
rem -- DESCRIPTION: Script for pre-update checking invalid PL/SQL units.    --
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
 Pre-update check PL/SQL invalid units.

 Must be run as SYS account as SYSDBA.
 Input SYS password and ORACLE_SID.
#############################################################
#############################################################
#

connect / as sysdba

set verify off
set echo on

col object_name format a30
col owner format a12
col object_type format a18

spool pre_upd_invalid.log

select o.owner, o.object_name, o.object_type
from dba_objects o, dba_plsql_object_settings s
where o.object_name = s.name and o.status='INVALID'
order by o.owner, o.object_type;

spool off

disconnect

exit
