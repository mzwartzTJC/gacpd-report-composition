------Crosswalk (1020) Report XML---
DECLARE @efc_dt AS DATE = '01/01/2026'
DECLARE @prg_id AS INT = 2
DECLARE @deem_ix AS INT = 3068

-------------------------------------------------
--ADI: prg_id = 23 deem_ix = 3243 --No tags
--ASC: prg_id = 23 deem_ix = 2181 --include comments
--CAH: prg_id = 69 deem_ix = 3066 --include comments
--DPU: prg_id = 69 deem_ix = 3068 --filtered comments 
--HAP: prg_id = 2 deem_ix = 3068 --filtered comments
--HI: prg_id = 22 deem_ix = 3610 --No tags
--HME: prg_id = 22 deem_ix = 2180 --No tags
--HPC: prg_id = 22 deem_ix = 2179
--LTC: prg_id = 5 deem_ix = 3247 --disclaimer page
--OME: prg_id = 22 deem_ix = 2178 
--OPD: prg_id = 6 deem_ix = 3141 --No Tags
--PSY: prg_id = 2 deem_ix = 3248
--RHC: prg_id = 6331 deem_ix = 6332 --filtered comments
-------------------------------------------------

--Get crosswalk info
DROP TABLE IF EXISTS #tmp_info
SELECT *, FORMAT(@efc_dt, 'MMMM dd, yyyy') AS efc_dt
	, FORMAT(GETDATE(), 'MMMM dd, yyyy') AS run_date
	--Generate crosswalk title
	, CASE WHEN @deem_ix = 3243 THEN 'Advanced Diagnostic Imaging Services Crosswalk'
		WHEN @deem_ix = 2181 THEN 'Ambulatory Surgical Center Crosswalk'
		WHEN @deem_ix = 3066 THEN 'Critical Access Hospital Crosswalk'
		WHEN @deem_ix = 3068 AND @prg_id = 69 THEN 'Critical Access Hospital Distinct Part Unit Crosswalk'
		WHEN @deem_ix = 3068 THEN 'Hospital Crosswalk'
		WHEN @deem_ix = 3610 THEN 'Home Infusion Therapy Crosswalk'
		WHEN @deem_ix = 2180 THEN 'Durable Medical Equipment, Prosthetics, Orthotics, and Supplies Crosswalk'
		WHEN @deem_ix = 2179 THEN 'Hospice Crosswalk'
		WHEN @deem_ix = 3247 THEN 'Nursing Care Center (NCC) Requirements Reference Guide'
		WHEN @deem_ix = 2178 THEN 'Home Health Agency Crosswalk'
		WHEN @deem_ix = 3141 THEN 'Opioid Treatment Program Crosswalk'
		WHEN @deem_ix = 3248 THEN 'Psychiatric Hospital Crosswalk'
		WHEN @deem_ix = 6332 THEN 'Rural Health Crosswalk'
		ELSE NULL END AS title_text 
	, CASE WHEN @deem_ix = 3243 THEN 'Medicare Imaging Accreditation Standards to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Ambulatory Care Standards & EPs'
		WHEN @deem_ix = 2181 THEN 'Medicare Ambulatory Surgical Center Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Ambulatory Surgical Center Standards & EPs'
		WHEN @deem_ix = 3066 THEN 'Medicare Critical Access Hospital Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Critical Access Hospital Standards & EPs'
		WHEN @deem_ix = 3068 AND @prg_id = 69 THEN 'Medicare Hospital Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Critical Access Hospital Distinct Part Unit Standards & EPs'
		WHEN @deem_ix = 3068 THEN 'Medicare Hospital Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Hospital Standards & EPs'
		WHEN @deem_ix = 3610 THEN 'Medicare Home Infusion Therapy Requirements crosswalked to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Home Care Standards & EPs'
		WHEN @deem_ix = 2180 THEN 'Medicare Quality Standards to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Home Care Standards & EPs'
		WHEN @deem_ix = 2179 THEN 'Medicare Hospice Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Home Care Standards & EPs'
		WHEN @deem_ix = 3247 THEN 'Select Medicare Long Term Care Requirements to Relevant ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission NCC Accreditation Program Standards & EPs'
		WHEN @deem_ix = 2178 THEN 'Medicare Home Health Agency Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Home Care Standards & EPs'
		WHEN @deem_ix = 3141 THEN 'Federal Regulations for Opioid Treatment Program to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Opioid Treatment Program Standards & EPs'
		WHEN @deem_ix = 3248 THEN 'Medicare Special Psychiatric Hospital Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Hospital Standards & EPs'
		WHEN @deem_ix = 6332 THEN 'Medicare Rural Health Clinic Requirements to ' + FORMAT(@efc_dt, 'yyyy') + ' Joint Commission Rural Health Standards & EPs'
		ELSE NULL END AS crswlk_desc
INTO #tmp_info FROM wip.fn_swip_lst_ix_all(@efc_dt) WHERE ix_id = @deem_ix

--Get all CoP element info
DROP TABLE IF EXISTS #tmp_cop
SELECT * INTO #tmp_cop
	FROM wip.fn_swip_lst_cop_all(@efc_dt) 
	WHERE deem_ix_id = @deem_ix AND process_sts_ind <> 'D'

--Get all CoP tag info
DROP TABLE IF EXISTS #tmp_cop_tag
SELECT t.cop_tag_id, t.deem_ix_id, t.cop_tag_cd, r.cop_ele_id, r.cop_ele_tag_rlt_id
	, CASE WHEN t.hdg_ds = '' THEN NULL ELSE t.hdg_ds END AS hdg_ds
	, t.cop_tag_seq_qt
	INTO #tmp_cop_tag FROM wip.fn_swip_lst_cop_tag_all(@efc_dt) t
	JOIN wip.fn_swip_lst_cop_ele_tag_rlt_all(@efc_dt) r ON t.cop_tag_id = r.cop_tag_id
	WHERE t.deem_ix_id = @deem_ix AND t.cop_tag_cd NOT LIKE '%--%'
	AND t.process_sts_ind <> 'D' 

--Get IGs & SPs
DROP TABLE IF EXISTS #tmp_cop_ele_tx
SELECT tx_rlt.cop_ele_tag_rlt_id, ele_tx.deem_ix_id, ele_tx.cop_ele_tx_id, ele_tx.cop_ele_tx, ele_tx.cop_tx_typ_id
	INTO #tmp_cop_ele_tx FROM wip.fn_swip_lst_cop_ele_tx_all(@efc_dt) ele_tx
	JOIN wip.fn_swip_lst_cop_ele_tx_rlt_all(@efc_dt) tx_rlt ON ele_tx.cop_ele_tx_id = tx_rlt.cop_ele_tx_id AND tx_rlt.process_sts_ind <> 'D' 
	WHERE ele_tx.deem_ix_id = @deem_ix AND ele_tx.process_sts_ind <> 'D'


--Comment filters for deemed crosswalks
DROP TABLE IF EXISTS #tmp_comm_filtered
SELECT rmk.* INTO #tmp_comm_filtered FROM wip.fn_swip_lst_cop_ele_rmk_all(@efc_dt) rmk
		JOIN wip.fn_swip_lst_cop_element_all(@efc_dt) ele ON rmk.cop_ele_id = ele.cop_ele_id AND ele.process_sts_ind <> 'D'
	WHERE rmk.process_sts_ind <> 'D'

IF @deem_ix = 3068 AND @prg_id = 69 --DPU comment filter
BEGIN 
	DELETE FROM #tmp_comm_filtered
	WHERE cop_ele_id NOT IN (27243, 27244, 27245, 27246, 27869, 2001, 2063, 31054, 31052, 31112, 31127, 31079, 31049)
END 
ELSE IF @deem_ix = 3068 AND @prg_id = 2 --HAP comment filter
BEGIN 
	DELETE FROM #tmp_comm_filtered
	WHERE cop_ele_id NOT IN (27869, 2001, 2063, 27353, 27354, 27355, 27356, 28734, 31052)

END 
ELSE IF @deem_ix IN (3243, 3610, 2180, 2179, 2178, 3247, 3141, 3248) --Remove comments for these programs
BEGIN
	DELETE FROM #tmp_comm_filtered WHERE cop_ele_id IS NOT NULL
END 

--all CoP element text
DROP TABLE IF EXISTS #tmp_cop_ele_sorted
SELECT ele.*, com.cop_ele_rmk_tx, t.cop_tag_seq_qt
	, CASE WHEN @deem_ix = 2180 THEN ROW_NUMBER() OVER (ORDER BY t.cop_tag_seq_qt, ele.cop_ele_seq_qt)
			ELSE ROW_NUMBER() OVER (ORDER BY ele.cop_rqr_nm_sort_no, t.cop_tag_seq_qt) END AS 'cop_ele_and_tag_sort'
	, ROW_NUMBER() OVER (PARTITION BY ele.cop_ele_id ORDER BY ele.cop_rqr_nm_sort_no) AS cop_count
INTO #tmp_cop_ele_sorted FROM wip.fn_swip_lst_cop_element_all(@efc_dt) ele 
	LEFT JOIN #tmp_cop_tag t ON ele.cop_ele_id = t.cop_ele_id 
	LEFT JOIN #tmp_comm_filtered com ON ele.cop_ele_id = com.cop_ele_id
	WHERE ele.cop_id IN (SELECT cop_id FROM #tmp_cop)
	AND ele.process_sts_ind <> 'D' 
	ORDER BY cop_ele_and_tag_sort

--Select distinct to remove duplicate cop elements linked to multiple tags
DROP TABLE IF EXISTS #tmp_cop_ele
SELECT cop_id, cop_ele_id, cop_rqr_nm, cop_tx, cop_ele_rmk_tx, cop_ele_and_tag_sort
	INTO #tmp_cop_ele  FROM #tmp_cop_ele_sorted
	WHERE cop_count = 1

--Cop ele filters for programs
IF @deem_ix = 3243 --Drop duplicate CoP Elementes from ADI
BEGIN 
	DELETE FROM #tmp_cop_ele
	WHERE cop_ele_id NOT IN (6875, 6876, 6771, 6772, 6774, 6773, 6877, 6878)

END
ELSE IF @deem_ix = 3141 --Drop CoP Elemets under §8.11 
BEGIN 
	DELETE FROM #tmp_cop_ele
	WHERE cop_ele_id IN (2823, 2824, 2825, 2826, 2827, 2828, 2829, 2830, 2831, 2832, 2833, 2834, 2835, 2836, 2837, 2838, 2839, 2840, 2841, 2842, 2843, 2844, 2845, 2846
						, 2847, 2848, 2849, 2850, 2851, 2852, 2769, 2853, 2854, 2855, 2856, 2857, 2858, 2859, 2860, 2861, 2862, 2863, 2864, 2865, 2866)
END
ELSE IF @deem_ix = 3066 --CAH CoP filter
BEGIN 
	DELETE FROM #tmp_cop_ele
	WHERE cop_ele_id IN (28774, 28775, 28776, 28829, 28777, 28778)
END
ELSE IF @deem_ix = 3068 --HAP CoP filter
BEGIN
	DELETE FROM #tmp_cop_ele
	WHERE cop_ele_id IN (28784, 28766, 51596, 30874)
END

--Get active standards and EP for program and on crosswalk
--Get table to relate CoP to std_id and mc_tx_id
DROP TABLE IF EXISTS #tmp_cop_rlt
SELECT rlt.*, ep.std_id, ep.mc_lbl_nm
	INTO #tmp_cop_rlt
	FROM wip.fn_swip_lst_cop_ep_rlt_all_prg_ix(@efc_dt, @prg_id) rlt
	JOIN wip.fn_swip_lst_ep_all(@efc_dt) ep ON ep.mc_id = rlt.mc_id AND ep.process_sts_ind <> 'D'
	WHERE cop_ele_id IN (SELECT cop_ele_id FROM #tmp_cop_ele) 
	AND rlt.process_sts_ind <> 'D'


--Temp table for standard info and related cop_ele_id
DROP TABLE IF EXISTS #tmp_std
SELECT DISTINCT std.*, rlt.cop_ele_id 
	INTO #tmp_std FROM wip.fnc_dssm_std_all(@efc_dt) std
	JOIN #tmp_cop_rlt rlt ON rlt.std_id = std.std_id AND rlt.prg_ix_id = std.ix_id
	WHERE std.process_sts_ind <> 'D'

--Temp table for EP info and related cop_ele_id
DROP TABLE IF EXISTS #tmp_ep
SELECT ep_tx.std_id, ep_tx.mc_tx_seq_qt, rlt.cop_ele_id, ep_tx.mc_tx_id  
	,ep_tx.[mc_body_tx] + IIF(ISNULL(link_tx.[see_also_tx], '') = '', '', CHAR(10) + '(See also ' + link_tx.[see_also_tx] + ')') AS [mc_body_tx]
INTO #tmp_ep 
FROM wip.fnc_dssm_ep_all(@efc_dt) ep_tx 
LEFT JOIN [wip].[fn_swip_lst_ep_link_tx_all](@efc_dt) link_tx ON ep_tx.mc_tx_id = link_tx.mc_tx_id AND link_tx.process_sts_ind <> 'D'
JOIN #tmp_cop_rlt rlt ON rlt.mc_tx_id = ep_tx.mc_tx_id 
WHERE ep_tx.prg_ix_id IN (@prg_id) AND ep_tx.process_sts_ind <> 'D'


--Generate XML
SELECT CAST('<?xml-stylesheet href="crosswalk_stylesheet.xsl" type="text/xsl" ?>' AS XML)
,(SELECT [CRSWLK].ix_nm, [CRSWLK].ix_id, [CRSWLK].efc_dt, [CRSWLK].title_text, [CRSWLK].crswlk_desc, [CRSWLK].run_date
	,(SELECT COP.cop_nm, COP.cop_seq_qt, COP.cop_ttl_ds
		,(SELECT COP_ELE.cop_rqr_nm, COP_ELE.cop_tx, COP_ELE.cop_ele_rmk_tx AS [COMMENT]
			,(SELECT TAG.cop_tag_cd AS [TAG_NM], TAG.hdg_ds AS [TAG_HDG]
				,(SELECT [COP_ELE_TX].cop_tx_typ_id AS [ELE_TX_TYP], [COP_ELE_TX].cop_ele_tx AS [ELE_TX]
					FROM #tmp_cop_ele_tx [COP_ELE_TX]
					WHERE [COP_ELE_TX].cop_ele_tag_rlt_id = [TAG].cop_ele_tag_rlt_id
					ORDER BY cop_ele_tx_id
					FOR XML AUTO, ELEMENTS, TYPE
					)
				FROM #tmp_cop_tag [TAG]
				WHERE [TAG].cop_ele_id = [COP_ELE].cop_ele_id
				ORDER BY [TAG].cop_tag_seq_qt
				FOR XML AUTO, ELEMENTS, TYPE
				)
			,(SELECT STD.std_lbl, STD.std_tx
				,(SELECT [EP].mc_tx_seq_qt, REPLACE([EP].[mc_body_tx], ' - ', '-- ') AS [mc_body_tx]
					FROM #tmp_ep [EP] 
					WHERE EP.std_id = STD.std_id
					AND EP.cop_ele_id = COP_ELE.cop_ele_id
					ORDER BY EP.mc_tx_seq_qt
					FOR XML AUTO, ELEMENTS, TYPE
					)
				FROM #tmp_std [STD]
				WHERE [STD].cop_ele_id = [COP_ELE].cop_ele_id
				ORDER BY STD.std_lbl
				FOR XML AUTO, ELEMENTS, TYPE
				)
			FROM #tmp_cop_ele [COP_ELE]
			WHERE [COP].cop_id = [COP_ELE].cop_id
			ORDER BY [COP_ELE].cop_ele_and_tag_sort
			FOR XML AUTO, ELEMENTS, TYPE
			)
		FROM #tmp_cop [COP]
		WHERE [COP].deem_ix_id = [CRSWLK].ix_id
		ORDER BY [COP].cop_seq_qt
		FOR XML AUTO, ELEMENTS, TYPE
		)
	FROM #tmp_info [CRSWLK]
	FOR XML AUTO, ELEMENTS, TYPE
	)
FOR XML PATH('')