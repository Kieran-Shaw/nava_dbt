/* client bor information, populates bor table */

{{ config(materialized="view") }}

with customers_bor_info as (

    select
        customers.sfdc_id,
        opp."Id" as sfdc_opp_id,
        opp."Type" as opp_type,
        true as is_new_deal,
        bor_date__c as bor_date_final,
        bor_date_sales_estimate__c as bor_date_sales_estimate,
        bor_date_finance_update__c as bor_date_finance_upate,
        lastmodifieddate as sfdc_last_modified_date
        -- add in ben admin system here
        -- make sure partner to client uses this information




    from {{ ref('customers') }} as customers
        join airbyte_data.opportunity as opp on customers.sfdc_id = opp.accountid

    where
        opp.renewal__c is false
        and isclosed is true
        and isdeleted is false

)

select *
from customers_bor_info