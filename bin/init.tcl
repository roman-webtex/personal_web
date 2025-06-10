set tcl_precision 12
set ::windows_prefix "S:"
set ::unix_prefix "/pub/tyl"
set ::db_engine mysql
set ::db_host 192.168.1.10
set ::db_port 3306
set ::db_name doc_catalog
set ::db_user "U2732903012"
set ::db_password "2732903012"
set ::data 0
set ::workingDir [file dirname [info script]]
set ::table_year [clock format [clock seconds] -format "%Y"]
set ::yearList {"{ 2023 }" "{ 2024 }"}
set ::dbpersons_table_name persons
set ::title "Облік на ТКП"
set ::request::ErrorMessage ""
set ::request::SuccessMessage ""
set ::documents_path "/media/docs"
set ::scans_path "/media/docs/doc_manager/data/scans"
set ::db_table catalog_
set ::db_table_name catalog_2024
set ::request::workingYear "2024"
set ::request::rowsCount 20
namespace eval ::webapp {}
