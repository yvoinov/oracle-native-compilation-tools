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
rem -- IDENTIFICATION: chk_invalid_plsql.sql                                --
rem -- DESCRIPTION: Script for checking invalid PL/SQL units.               --
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
 Check PL/SQL invalid units. Must be run as SYS account as
 SYSDBA. Input SYS password and ORACLE_SID.
#############################################################
#############################################################
#

connect / as sysdba

set verify off
set echo on

spool chk_invalid_plsql.log

select count(*) as "INVALID OBJ-PB,PROC,FUNC,TRG"
--object_name,owner, object_type
 from dba_objects where status = 'INVALID'
 and object_type IN ('PACKAGE BODY','PROCEDURE','FUNCTION','TRIGGER')
 and owner = 'SYS';

spool off

disconnect

exit
