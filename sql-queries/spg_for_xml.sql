DECLARE @efc_dt AS DATE = '07/01/2026'
DECLARE @prg_ix_id AS INT = 2
DECLARE @deem_ix_id AS INT = 3068

--Generate table with report info
DROP TABLE IF EXISTS #tmp_report_info
SELECT
	(SELECT ix_ds FROM prd.t_ix WHERE ix_id = @prg_ix_id) AS program
	,(SELECT ix_ds + ' Accreditation Survery Process Guide' FROM prd.t_ix WHERE ix_id = @prg_ix_id) AS prg_title 
	,(SELECT ix_ds + ' Crosswalk' FROM prd.t_ix WHERE ix_id = @deem_ix_id) AS crosswalk_title
	, @deem_ix_id as deem_ix_id
	, FORMAT(GETDATE(), 'MMMM dd, yyyy') AS run_date
	, FORMAT(@efc_dt, 'MMMM dd, yyyy') AS efc_dt
	INTO #tmp_report_info 

--Temp table for CoPs for deemed index
DROP TABLE IF EXISTS #tmp_cop
SELECT 
	cop.cop_id, 
	cop.cop_seq_qt,
	cop.deem_ix_id, 
	cop.cop_nm, 
	cop.cop_ttl_ds 
INTO #tmp_cop 
FROM wip.fn_swip_lst_cop_all(@efc_dt) cop
WHERE cop.process_sts_ind <> 'D'  AND deem_ix_id = @deem_ix_id


--Generate temp tables with SPGs for deem_ix
DROP TABLE IF EXISTS #tmp_spg 
SELECT 
	ele_tx.cop_ele_tx_id, 
	ele_tx.deem_ix_id, 
	ele_tx.cop_ele_tx, 
	tag_rlt.cop_ele_tag_rlt_id
INTO #tmp_spg 
FROM wip.fn_swip_lst_cop_ele_tx_all(@efc_dt) ele_tx
	JOIN wip.fn_swip_lst_cop_ele_tx_rlt_all(@efc_dt) tag_rlt ON tag_rlt.cop_ele_tx_id = ele_tx.cop_ele_tx_id AND tag_rlt.process_sts_ind <> 'D' 
WHERE cop_tx_typ_id=9 AND deem_ix_id = @deem_ix_id AND ele_tx.process_sts_ind <> 'D'

--Generate table with SPG text and related cop_id for XML
DROP TABLE IF EXISTS #tmp_spg_rlt
SELECT 
	spg.cop_ele_tx_id, 
	spg.deem_ix_id, 
	cop.cop_id, 
	cop_ele_rlt.cop_ele_id, 
	cop.cop_rqr_nm_sort_no,
	spg.cop_ele_tx, 
	spg.cop_ele_tag_rlt_id
INTO #tmp_spg_rlt FROM #tmp_spg spg
	JOIN wip.fn_swip_lst_cop_ele_tag_rlt_all(@efc_dt) cop_ele_rlt ON cop_ele_rlt.cop_ele_tag_rlt_id = spg.cop_ele_tag_rlt_id AND cop_ele_rlt.process_sts_ind <> 'D' 
	JOIN wip.fn_swip_lst_cop_element_all(@efc_dt) cop ON cop.cop_ele_id = cop_ele_rlt.cop_ele_id AND cop.process_sts_ind <> 'D' 

--SELECT * FROM wip.fn_swip_lst_cop_ele_tx_all('07-01-2026') 
--SELECT * FROM wip.fn_swip_lst_cop_ele_tx_rlt_all('07-01-2026') 
--SELECT * FROM wip.fn_swip_lst_cop_ele_tag_rlt_all('07-01-2026') 
--SELECT * FROM wip.fn_swip_lst_cop_element_all('07-01-2026') 

--Generate temp tables with CoPs with tag relate ids 
DROP TABLE IF EXISTS #tmp_cop_ele
SELECT 
	cop.deem_ix_id, 
	cop.cop_id, 
	spg.cop_ele_tx_id, 
	spg.cop_ele_tag_rlt_id, 
	ele.cop_ele_id, 
	ele.cop_rqr_nm, 
	ele.cop_rqr_nm_sort_no, 
	ele.cop_tx
INTO #tmp_cop_ele 
FROM wip.fn_swip_lst_cop_element_all(@efc_dt) ele
	JOIN #tmp_cop cop ON ele.cop_id = cop.cop_id
	JOIN #tmp_spg_rlt spg ON ele.cop_ele_id = spg.cop_ele_id
WHERE ele.process_sts_ind <> 'D'

--Generate temp tables for EPs with tag relate ids 
DROP TABLE IF EXISTS #tmp_ep
SELECT * INTO #tmp_ep
FROM wip.fnc_dssm_ep_all(@efc_dt)
WHERE process_sts_ind <> 'D' AND prg_ix_id=@prg_ix_id

DROP TABLE IF EXISTS #tmp_ep_rlt 
SELECT 
	ep.std_id, 
	ep.mc_id, 
	ep.mc_tx_id, 
	ep.prg_ix_id, 
	ep.std_lbl, 
	ep.mc_tx_seq_qt, 
	ep.mc_body_tx, 
	cop_rlt.cop_ele_id, 
	spg.cop_ele_tx_id
INTO #tmp_ep_rlt FROM #tmp_ep ep
	JOIN wip.fn_swip_lst_cop_ep_rlt_all(@efc_dt) cop_rlt ON ep.mc_id = cop_rlt.mc_id AND ep.prg_ix_id = cop_rlt.prg_ix_id AND cop_rlt.process_sts_ind <> 'D' 
	JOIN #tmp_spg_rlt spg ON spg.cop_ele_id = cop_rlt.cop_ele_id 
	WHERE ep.process_sts_ind <> 'D'


----Generate tables to use for XML 
--Generate distinct COPs with associated SPGs table for XML
DROP TABLE IF EXISTS #tmp_cop_dstnct
SELECT DISTINCT 
	COP.deem_ix_id, 
	COP.cop_id, 
	COP.cop_nm, 
	COP.cop_ttl_ds, 
	COP.cop_seq_qt
INTO #tmp_cop_dstnct FROM #tmp_cop COP 
WHERE COP.cop_id IN (SELECT cop_id FROM #tmp_spg_rlt)

DROP TABLE IF EXISTS #tmp_spg_dstnct 
SELECT 
	SPG.cop_ele_tx_id, 
	SPG.cop_id, 
	SPG.cop_ele_tx,
	MIN(SPG.cop_rqr_nm_sort_no) AS spg_sort_qt
INTO #tmp_spg_dstnct 
FROM #tmp_spg_rlt SPG
GROUP BY SPG.cop_ele_tx_id, SPG.cop_id, SPG.cop_ele_tx

DROP TABLE IF EXISTS #tmp_ep_rlt_dstnct
SELECT DISTINCT 
	EP_RLT.mc_tx_id,
	EP_RLT.std_lbl, 
	EP_RLT.mc_tx_seq_qt, 
	EP_RLT.mc_body_tx, 
	EP_RLT.cop_ele_tx_id
INTO #tmp_ep_rlt_dstnct
FROM #tmp_ep_rlt EP_RLT 

--SELECT * FROM #tmp_report_info
--SELECT * FROM #tmp_cop_dstnct
--SELECT * FROM #tmp_spg_dstnct
--SELECT * FROM #tmp_cop_ele
--SELECT * FROM #tmp_ep_rlt 

--Generate XML focused on CoP Tag relates
SELECT INFO.program AS PROGRAM, INFO.prg_title AS TITLE, INFO.crosswalk_title AS CRSWLK, INFO.run_date AS RUN_DT, INFO.efc_dt AS EFC_DT
	,(SELECT COP.cop_nm AS COP_NM, COP.cop_ttl_ds AS COP_TTL
		, (SELECT SPG.cop_ele_tx_id AS SPG_ID 
			, REPLACE(REPLACE(SPG.cop_ele_tx, '          - ', '--- '), '     - ', '-- ') AS SPG_TXT 
			,(SELECT EP.std_lbl AS STD_LBL, EP.mc_tx_seq_qt AS EP_LBL
				, REPLACE([EP].[mc_body_tx], ' - ', '-- ') AS EP_TXT
				FROM #tmp_ep_rlt_dstnct EP
				WHERE EP.cop_ele_tx_id = SPG.cop_ele_tx_id
				ORDER BY EP.std_lbl, EP.mc_tx_seq_qt
				FOR XML AUTO, ELEMENTS, TYPE
			)
			,(SELECT COP_ELE.cop_rqr_nm AS COP_ELE_NM, COP_ELE.cop_tx AS COP_TXT
				FROM #tmp_cop_ele COP_ELE
				WHERE COP_ELE.cop_ele_tx_id = SPG.cop_ele_tx_id
				ORDER BY COP_ELE.cop_rqr_nm_sort_no
				FOR XML AUTO, ELEMENTS, TYPE
			)
		FROM #tmp_spg_dstnct SPG
		WHERE SPG.cop_id = COP.cop_id
		ORDER BY SPG.spg_sort_qt
		FOR XML AUTO, ELEMENTS, TYPE
		)
	FROM #tmp_cop_dstnct COP
	ORDER BY COP.cop_seq_qt
	FOR XML AUTO, ELEMENTS, TYPE
	)
FROM #tmp_report_info INFO
FOR XML PATH('SPG_REPORT')

