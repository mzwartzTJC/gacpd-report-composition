-----NPSG XML-------
USE DBSTD03_SWIP
DECLARE @prj_efc_dt AS DATE = '01/01/2026'
DECLARE @prg_ix_id AS INT = 23
--DECLARE @deem_ix_id AS INT = 3068

----------------------------------------------------------------------------------------------------
--AHC = 23
--ALC = 6294
--BHC = 6
--CAH = 69 NPG
--HAP = 2 NPG
--OME = 22
--LAB = 21
--NCC = 5
--OBS = 68
--RHC = 6331
--TEL = 6368
----------------------------------------------------------------------------------------------------
--Generate report data
DROP TABLE IF EXISTS #tmp_report_info
SELECT FORMAT(GETDATE(), 'MMMM dd, yyyy') AS run_date
	, FORMAT(@prj_efc_dt, 'MMMM dd, yyyy') AS efc_dt
	INTO #tmp_report_info FROM prd.t_ix 
	WHERE ix_id = @prg_ix_id

--Get CoP relate data
DROP TABLE IF EXISTS #tmp_cop_ep_rlt, #tmp_cop_ep_rlt_agg
SELECT cop_ep.*, ele.cop_rqr_nm_sort_no, ele.cop_rqr_nm
INTO #tmp_cop_ep_rlt FROM wip.fn_swip_lst_cop_ep_rlt_all_prg_ix(@prj_efc_dt, @prg_ix_id) cop_ep
JOIN wip.fn_swip_lst_cop_element_all(@prj_efc_dt) ele ON ele.cop_ele_id = cop_ep.cop_ele_id
JOIN wip.fn_swip_lst_cop_all(@prj_efc_dt) cop ON cop.cop_id = ele.cop_id
WHERE cop.deem_ix_id IN(SELECT ix_id FROM prd.t_ix WHERE ix_typ_id = 19) AND cop_ep.process_sts_ind <> 'D'

SELECT mc_tx_id, STRING_AGG(cop_rqr_nm, ', ') WITHIN GROUP (ORDER BY cop_rqr_nm_sort_no) AS cop_rlts
	INTO #tmp_cop_ep_rlt_agg FROM #tmp_cop_ep_rlt
	GROUP BY mc_tx_id

--Get all EP data (documentation, critical tagging, CoP relations)
--Filter EPs for faster query
DROP TABLE IF EXISTS #tmp_ep
SELECT  ep_tx.prg_ix_id, ep.mc_id, ep.std_id, ep_tx.mc_tx_id, ep_tx.mc_tx_seq_qt, ep_tx.mc_body_tx
	INTO #tmp_ep
	FROM wip.fn_swip_lst_ep_all(@prj_efc_dt) ep
	JOIN wip.fn_swip_lst_ep_tx_all(@prj_efc_dt) ep_tx ON ep.mc_id = ep_tx.mc_id
	WHERE ep.process_sts_ind <> 'D' AND ep_tx.process_sts_ind <> 'D' 
	AND prg_ix_id = @prg_ix_id

--Relate EPs to indexes
DROP TABLE IF EXISTS #tmp_ep_rlt
SELECT mc_tx_id
	, MAX(CASE WHEN rlt.ix_id = 1344 THEN 'Critical Change' END) AS 'crit_chng' 
	, MAX(CASE WHEN rlt.ix_id = 2154 THEN 'Documentation Required' END) AS 'doc_tag'
	INTO #tmp_ep_rlt 
	FROM wip.fn_swip_lst_ep_tx_ix_rlt_all(@prj_efc_dt) rlt
	GROUP BY mc_tx_id
	
--Combine all EP data into one table
DROP TABLE IF EXISTS #tmp_ep_all
SELECT ep.*
	, CASE WHEN lnk.mc_tx_id IS NULL THEN ep.mc_body_tx ELSE ep.mc_body_tx + ' (See also ' + lnk.see_also_tx + ')' END AS full_body_tx
	, rlt.crit_chng, rlt.doc_tag
	, cop.cop_rlts
	INTO #tmp_ep_all FROM #tmp_ep ep
	LEFT JOIN #tmp_ep_rlt rlt ON ep.mc_tx_id = rlt.mc_tx_id
	LEFT JOIN wip.fn_swip_lst_ep_link_tx_all(@prj_efc_dt) lnk ON ep.mc_tx_id = lnk.mc_tx_id AND lnk.process_sts_ind <> 'D'
	LEFT JOIN #tmp_cop_ep_rlt_agg cop ON cop.mc_tx_id = ep.mc_tx_id

--Get addendums (all for program)
DROP TABLE IF EXISTS #tmp_adndm
SELECT * INTO #tmp_adndm FROM wip.fn_swip_lst_addendum_all(@prj_efc_dt) adndm
	WHERE adndm.process_sts_ind <> 'D' 
	AND adndm.cert_lst_typ_id IN (
		SELECT cert_lst_typ_id FROM wip.fn_swip_lst_cert_lst_typ_all(@prj_efc_dt) 
		WHERE prg_ix_id = @prg_ix_id)

--Get all Goal Statements
DROP TABLE IF EXISTS #tmp_lst_std_goal_all
SELECT * INTO #tmp_lst_std_goal_all FROM wip.fn_swip_lst_std_intro_all(@prj_efc_dt)
	WHERE process_sts_ind <> 'D' AND ix_id = @prg_ix_id 
	AND (std_intro_hdr_ds LIKE 'Goal%' OR std_intro_hdr_ds LIKE 'Introduction to the Universal Protocol%')

--Get all Standard Intros
DROP TABLE IF EXISTS #tmp_lst_std_intro_all
SELECT intr.* INTO #tmp_lst_std_intro_all FROM wip.fn_swip_lst_std_intro_all(@prj_efc_dt) intr
	WHERE intr.process_sts_ind <> 'D' AND intr.ix_id = @prg_ix_id 
	AND (intr.std_intro_hdr_ds NOT LIKE 'Goal%' AND intr.std_intro_hdr_ds NOT LIKE 'Introduction to the Universal Protocol%')

--Filter out repeated intros
DROP TABLE IF EXISTS #tmp_lst_std_intro
SELECT intr.*, RANK() OVER (PARTITION BY intr.std_intro_id ORDER BY std.std_id) AS 'intr_std_rank'
	INTO #tmp_lst_std_intro FROM #tmp_lst_std_intro_all intr
	JOIN wip.fn_swip_lst_std_lbl_all(@prj_efc_dt) std ON std.std_id = intr.std_id AND std.process_sts_ind <> 'D' 

--Get all standard tx, rationale, and intros (not goals)
DROP TABLE IF EXISTS #tmp_std_all
SELECT * INTO #tmp_std_all FROM wip.fn_swip_lst_std_all(@prj_efc_dt) std
	WHERE std.process_sts_ind <> 'D'
	AND std.ix_id = @prg_ix_id

DROP TABLE IF EXISTS #tmp_std
SELECT std.*, intr.std_intro_hdr_ds, intr.std_intro_tx
	, goal.std_intro_id AS 'goal_id', goal.std_intro_hdr_ds AS 'goal_hdr', goal.std_intro_tx AS 'goal_tx'
	, RANK() OVER (ORDER BY std.std_lbl) AS 'goal_order'
INTO #tmp_std FROM #tmp_std_all std
	LEFT JOIN #tmp_lst_std_intro intr ON std.std_id = intr.std_id AND intr.intr_std_rank = 1
	LEFT JOIN #tmp_lst_std_goal_all goal on std.std_id = goal.std_id
	WHERE std.fnc_id IN (43, 1585)
	
--Get distinct Goals and order for XML
DROP TABLE IF EXISTS #tmp_dstnct_goal
SELECT fnc_id, goal_id, goal_hdr, goal_tx, max(goal_order) as 'goal_order'
	INTO #tmp_dstnct_goal 
	FROM #tmp_std WHERE goal_id IS NOT NULL
	GROUP BY fnc_id, goal_id, goal_hdr, goal_tx


--Get chapter data
DROP TABLE IF EXISTS #tmp_chp
SELECT * INTO #tmp_chp FROM wip.fn_swip_lst_fnc_all(@prj_efc_dt) chp
	WHERE chp.process_sts_ind <> 'D'	
	AND fnc_id IN (SELECT fnc_id FROM #tmp_std)

--Get program data
DROP TABLE IF EXISTS #tmp_prg
SELECT * INTO #tmp_prg 
FROM wip.fn_swip_lst_prg_all(@prj_efc_dt) prg
	WHERE prg.process_sts_ind <> 'D' AND ix_id IN (@prg_ix_id)

--Produce XML data
--Need stylesheet reference added to top of output XML
SELECT run_date AS RUN_DT, efc_dt AS EFC_DT
	,(SELECT PROGRAM.ix_cd AS PROGRAM_CD, PROGRAM.ix_nm AS PROGRAM_NM
			,(SELECT CHAPTER.fnc_lbl AS CHAPTER_LBL, CHAPTER.fnc_nm AS CHAPTER_NM
				,(SELECT [GOAL].goal_hdr AS GOAL_HDR, [GOAL].goal_tx AS GOAL_TX --Comment out for clean report
					,(SELECT STANDARD.std_lbl AS STANDARD_NM, STANDARD.std_intro_hdr_ds AS INTRO_HDR, STANDARD.std_intro_tx AS INTRO_TX,
							STANDARD.std_tx AS STD_TX
							, CASE WHEN STANDARD.intent_tx IS NOT NULL THEN + STANDARD.std_lbl + '--' ELSE NULL END AS STD_RATIONALE_HDR
							, STANDARD.intent_tx AS STD_RATIONALE_TX
							,'Element(s) of performance for ' + STANDARD.std_lbl AS EP_SECT_LBL
						,(SELECT 'EP ' + CAST(EP.mc_tx_seq_qt AS VARCHAR(3)) AS EP_LBL
							, REPLACE(REPLACE([EP].[mc_body_tx], ' - ', '-- '), CHAR(10), CHAR(10)+CHAR(9)) AS EP_TX --add '--' for list tagging and CHAR(9) for InDesign styling
							, EP.doc_tag AS DOC, EP.cop_rlts AS COP
								,(SELECT ADNDM.adndm_tx_hdr_ds AS ADNDM_HDR, ADNDM.adndm_tx AS ADNDM_TX
									FROM #tmp_adndm [ADNDM]
									WHERE ADNDM.mc_tx_id = [EP].mc_tx_id
									FOR XML AUTO, ELEMENTS, TYPE
									)
								FROM #tmp_ep_all [EP]
								WHERE EP.std_id = [STANDARD].std_id
								ORDER BY EP.mc_tx_seq_qt
								FOR XML AUTO, ELEMENTS, TYPE
						)
					FROM #tmp_std [STANDARD]
					WHERE [STANDARD].goal_id = [GOAL].goal_id --Comment out for clean report
					--WHERE [STANDARD].fnc_id = [CHAPTER].fnc_id --Commonet out for chapthers WITH goals (NPSG)
					ORDER BY STANDARD.std_lbl
					FOR XML AUTO, ELEMENTS, TYPE
					)
			---- Comment out section for clean report ----
				FROM #tmp_dstnct_goal [GOAL]
				WHERE [GOAL].fnc_id = [CHAPTER].fnc_id
				ORDER BY GOAL.goal_order
				FOR XML AUTO, ELEMENTS, TYPE
				)
			FROM #tmp_chp [CHAPTER]
			ORDER BY CHAPTER.fnc_seq_qt
			FOR XML AUTO, ELEMENTS, TYPE
			)
		FROM #tmp_prg [PROGRAM]
		ORDER BY PROGRAM.ix_cd
		FOR XML AUTO, ELEMENTS, TYPE
	)
	FROM #tmp_report_info
	FOR XML PATH('REPORT')