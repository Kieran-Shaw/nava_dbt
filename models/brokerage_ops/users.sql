/*
This .sql model materializes a users view
This users view is important for maintaining an accurate user list of people with access to nest.
Any time someone is added to SF users table (ex, new partner), we can expect that person to be added to the nest users table.
I am thinking of having a different namespace for the airtable information, and then using dbt to pull the information in to the public schema / namespace
*/
{{ config(materialized="table") }}

with
    user_normalized as (

        select
            "Id" as sfdc_id,
            isactive,
            firstname as first_name,
            lastname as last_name,
            email as email,
            usertype,
            lastmodifieddate as sfdc_last_modified_date

        from airbyte_data."User"

        where
            isactive is true
            and email like '%@navabenefits.com%'
            and (lastname not like '%BenefitMall%' and lastname not like '%Integration%')

    )

select *
from user_normalized
