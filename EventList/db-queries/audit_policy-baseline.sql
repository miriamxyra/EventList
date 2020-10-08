/*
** Baseline query showing all Advanced Audit Policy settings
** 
** Mapping for "Windows 10 and Windows Server 2016 security auditing and
** monitoring reference" available at
** https://www.microsoft.com/en-us/download/details.aspx?id=52630
**
** Returned columns reference:
**   - success_failure_id: 1 == success, 2 == failure, 3 == success and failure
*/
select
    c.category_name,
    sc.subcategory_name,
    e.event_id,
    ref.success_failure_id,
    ref.event_name
from
    events_advanced_audit_categories c,
    events_advanced_audit_subcategories sc,
    events_audit_subcategory e,
    events_main ref
where
    c.id = sc.c_id
    and sc.id = e.audit_subc_id
    and e.event_id = ref.id
