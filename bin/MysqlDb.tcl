encoding system utf-8

namespace eval ::webapp::mysql {

    proc connect {} \
    {
        ::tdbc::mysql::connection create ::request::conn -user $::db_user -password $::db_password -host $::db_host -port $::db_port -db $::db_name 
    }
    
    proc close {} \
    {
        ::request::conn close
    }

    proc getRecordSetWithQuery { what from where } \
    {
        set query "select $what from $from where $where"
        return [::webapp::mysql::runQuery $query]
    }

    proc getDistinctRecordSetWithQuery { what from where } \
    {
        set query "select distinct $what from $from where $where"
        return [::webapp::mysql::runQuery $query]
    }

    proc runQuery {query} \
    {
        ::webapp::mysql::connect
        set stm [::request::conn prepare $query]
        set result [$stm execute]
        set retval [$result allrows -as lists]
        $result close
        $stm close
        ::request::conn close
        return $retval
    }
    
    proc runSelect {query} \
    {
        return [::webapp::mysql::runQuery $query]
    }
}