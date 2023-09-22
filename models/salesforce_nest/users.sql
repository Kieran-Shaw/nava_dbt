/*
This .sql model materializes a users view
This users view is important for maintaining an accurate user list of people with access to nest.
Any time someone is added to SF users table (ex, new partner), we can expect that person to be added to the nest users table.
I am thinking of having a different namespace for the airtable information, and then using dbt to pull the information in to the public schema / namespace
*/

{{ config(materialized="table") }}

with users_salesforce_raw as (

    select
        id as sfdc_id,
        firstname as first_name,
        lastname as last_name,
        email as email,
        isactive as is_active,
        department as department,
        division as division,
        usertype as user_type,
        title as job_title
    from salesforce.User
    
)

select *
from users_salesforce_raw
order by last_name asc
