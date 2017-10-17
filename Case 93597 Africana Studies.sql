--affiliated majors/minors
WITH alumn AS (
SELECT DISTINCT cn.pidm
, cn.banner_id
FROM  c_cn_constituent cn
WHERE cn.donor_code_primary IN ('ALMB', 'ALMG')
AND cn.dead_ind = 'N'
AND EXISTS(SELECT 1 
            FROM c_cn_education edu
            WHERE cn.pidm = edu.pidm 
            AND school_code = '002365'
            and (major_code_1 IN ('IAFS', 'AFS', 'AAS')
            OR major_code_2 IN ('IAFS', 'AFS', 'AAS')
            OR major_code_3 IN ('IAFS', 'AFS', 'AAS')
            OR major_code_4 IN ('IAFS', 'AFS', 'AAS')
            OR majr_code_minr_1 IN ('IAFS', 'AFS', 'AAS')
            OR majr_code_minr_2 IN ('IAFS', 'AFS', 'AAS')
                )
            )
)
,  aff AS (
SELECT DISTINCT cn.pidm
, cn.banner_id
FROM  c_cn_constituent cn
WHERE cn.donor_code_primary IN ('ALMB', 'ALMG')
AND cn.dead_ind = 'N'
AND EXISTS(SELECT 1 
            FROM c_cn_education edu
            WHERE cn.pidm = edu.pidm 
            AND school_code = '002365'
            AND (major_code_1 IN  ('HIST', 'IHIS', 'ARHS', 'ARHI', 'VHSA', 'VHSN','ENGL', 'IENL', 'IENG','GLST','THTR', 'TCTH','REL','JSW', 'JOUR', 'J/SW','POLS','DES', 'AHST')
            OR major_code_2 IN  ('HIST', 'IHIS', 'ARHS', 'ARHI', 'VHSA', 'VHSN','ENGL', 'IENL', 'IENG','GLST','THTR', 'TCTH','REL','JSW', 'JOUR', 'J/SW','POLS','DES', 'AHST')
            OR major_code_3 IN  ('HIST', 'IHIS', 'ARHS', 'ARHI', 'VHSA', 'VHSN','ENGL', 'IENL', 'IENG','GLST','THTR', 'TCTH','REL','JSW', 'JOUR', 'J/SW','POLS','DES', 'AHST')
            OR major_code_4 IN  ('HIST', 'IHIS', 'ARHS', 'ARHI', 'VHSA', 'VHSN','ENGL', 'IENL', 'IENG','GLST','THTR', 'TCTH','REL','JSW', 'JOUR', 'J/SW','POLS','DES', 'AHST')
            OR majr_code_minr_1 IN  ('HIST', 'IHIS', 'ARHS', 'ARHI', 'VHSA', 'VHSN','ENGL', 'IENL', 'IENG','GLST','THTR', 'TCTH','REL','JSW', 'JOUR', 'J/SW','POLS','DES', 'AHST')
            OR majr_code_minr_2 IN  ('HIST', 'IHIS', 'ARHS', 'ARHI', 'VHSA', 'VHSN','ENGL', 'IENL', 'IENG','GLST','THTR', 'TCTH','REL','JSW', 'JOUR', 'J/SW','POLS','DES', 'AHST')
                )
            )
--and cn.pidm not in ( select pidm from alumn)
)
, balance AS (
SELECT distinct cn.pidm
, cn.banner_id
FROM c_cn_constituent cn
WHERE  cn.dead_ind = 'N'
--and cn.donor_code_primary IN ('ALMB', 'ALMG')
and EXISTS(   select 1
                FROM c_cn_activities act
                WHERE cn.pidm = act.pidm
                AND act.activity_code IN ('BAL', 'BALM', 'BLL', 'BLLC')
                )
), breakdown as (
SELECT pidm
, banner_id
, 'AFR' as grp
FROM alumn
UNION
SELECT pidm
, banner_id
, 'Affiliated'
FROM aff
UNION
SELECT pidm
, banner_id
, 'Balance'
FROM balance)
SELECT distinct cn.banner_id
, cn.name_sort
, cn.primary_staff_desc
, cn.donor_code_primary
, cn.donor_code_desc
, cn.class_year_pref
, cp.email_pref_address
, CASE
    WHEN cn.pidm IN (SELECT alumn.pidm FROM alumn)
    THEN 'Y'
    ELSE 'N'
    END AS "Africana_Studies_Alum"
, CASE
    WHEN cn.pidm IN (SELECT aff.pidm FROM aff)
    THEN 'Y'
    ELSE 'N'
    END AS "Affiliated_Alum"
, CASE
    WHEN cn.pidm IN (SELECT balance.pidm FROM balance)
    THEN 'Y'
    ELSE 'N'
    END AS "Balance_member"
, lu.d1_degree_desc "Degree_1"
, lu.d1_degree_year "Degree_1_year"
, lu.d1_college_desc "Degree_1_college"
, lu.d1_major_desc_1 "Degree_1_major_1"
, lu.d1_major_desc_2 "degree_1_major_2"
, lu.d1_minor_desc_1 "degree_1_minor_1"
, lu.d1_minor_desc_2 "degree_1_minor_2"
, lu.d2_degree_desc "Degree_2"
, lu.d2_degree_year "Degree_2_year"
, lu.d2_college_desc "Degree_2_college"
, lu.d2_major_desc_1 "Degree_2_major_1"
, lu.d2_major_desc_2 "degree_2_major_2"
, lu.d2_minor_desc_1 "degree_2_minor_1"
, lu.d2_minor_desc_2 "degree_2_minor_2"
FROM c_cn_constituent cn
, c_cn_contact_pref cp
, c_cn_exclusions_by_id ex
, breakdown bk
, c_cn_education_lu_by_id lu
WHERE cn.pidm = cp.pidm
AND cn.pidm = ex.pidm
AND cn.pidm = bk.pidm
and cn.pidm = lu.pidm (+)
AND 'N' = excl_noc AND 'N' = excl_nml AND 'N'=excl_dec AND 'N' =excl_dns AND 'N' = excl_inl AND 'N' = excl_inr AND 'N' = excl_rpd 
ORDER BY cn.name_Sort;

--60 alum
--6206 affil
--376 balance
