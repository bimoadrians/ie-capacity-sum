SELECT sa.*, sc.PART_NAME partdx, sb.LINE_DESC linedx, sb.LINE_PREF unitx
 FROM (
   SELECT sa.idx, sa.partx, sa.linex, sa.groupx, sa.datex, sa.byx, SUM(timex) timex
   FROM (        
     SELECT a.anali_id idx, a.anali_part partx, a.anali_line linex, a.anali_group groupx, a.anali_date datex, a.anali_fch fchx, IFNULL(a.anali_by, '') byx, 
     IFNULL(ROUND((((IFNULL(3600/b.anali_act_ct1, 0) + IFNULL(3600/b.anali_act_ct2, 0)) - ((ROUND((((a.anali_hc * a.anali_wh)/a.anali_fch)*1000),0) * a.anali_eff)/a.anali_wh)) * b.anali_act_ct1)/60, 0), '') timex
     FROM ie_capacity_analih a 
     LEFT JOIN ie_capacity_analid b ON a.anali_id = b.anali_id
     UNION ALL
     SELECT a.anali_id idx, a.anali_part partx, a.anali_line linex, a.anali_group groupx, a.anali_date datex, a.anali_fch fchx, IFNULL(a.anali_by, '') byx, 
     IFNULL(ROUND((((IFNULL(3600/b.anali_act_ct1, 0) + IFNULL(3600/b.anali_act_ct2, 0)) - ((ROUND((((a.anali_hc * a.anali_wh)/a.anali_fch)*1000),0) * a.anali_eff)/a.anali_wh)) * b.anali_act_ct1)/60, 0), '') timex
     FROM ie_capacity_analih a 
     RIGHT JOIN ie_capacity_analidc b ON a.anali_id = b.anali_id
   ) sa GROUP BY sa.idx, sa.partx, sa.linex, sa.groupx, sa.datex, sa.byx
 ) sa
 LEFT JOIN line sb ON sa.linex = sb.LINE_CODE
 LEFT JOIN toy_part sc ON sa.partx = sc.PART_NUM 
 WHERE 1=1
 ORDER BY partdx ASC, datex DESC;
    
SELECT anali_part partx, COUNT(*) countx
FROM ie_capacity_analih
GROUP BY partx
ORDER BY partx ASC;
 
SELECT idx, datex, linex, c.LINE_DESC linedx, leadx, groupx, partx, b.PART_NAME partdx, a.pfchx, a.pflagx, a.procx, a.procdx, a.mcx, a.fchx, a.effx, a.hcx, a.whx, a.tqtyx, 
ROUND(3600 * (a.whx/a.tqtyx), 0) ttx, ROUND(a.tqtyx/a.whx, 0) thx, IFNULL(ROUND(a.cbstx, 0), 0) cbstx, 
IFNULL(ROUND(3600/a.cbstx, 0), 0) cbsctx, IFNULL(ROUND(3600/(a.cbstx*effx), 1), 0) effctx, IFNULL(ROUND(3600/(3600/(a.cbstx*effx)), 0), 0) efftjx,
a.oprx, IFNULL(a.oprct1x, '') oprct1x, IFNULL(a.oprct2x, '') oprct2x, IFNULL(3600/a.oprct1x, '') poprct1x, IFNULL(3600/a.oprct2x, '') poprct2x, (IFNULL(3600/a.oprct1x, 0) + IFNULL(3600/a.oprct2x, 0)) tpoprct,
(IFNULL(3600/a.oprct1x, 0) + IFNULL(3600/a.oprct2x, 0)) - ROUND(a.tqtyx/a.whx,0) oprblx, 
IFNULL(ROUND(oprct1x/(3600 * (a.whx/a.tqtyx)), 2), '') oprnedx,
IFNULL(ROUND((((IFNULL(3600/a.oprct1x, 0) + IFNULL(3600/a.oprct2x, 0)) - (a.tqtyx/a.whx)) * a.oprct1x)/60, 0), '') bltmx
FROM (
  SELECT
    c.anali_id idx, c.anali_date datex, c.anali_line linex, c.anali_lead leadx, c.anali_part partx, c.anali_fch pfchx, c.anali_group groupx, 
    'CBS' pflagx, a.anali_proc_id procx, b.CBSD_PROC_DESC procdx, b.CBSD_PROC_MC_TOOL mcx, a.anali_fch fchx, IFNULL(a.anali_opr, '') oprx, c.anali_eff effx,
    a.anali_act_ct1 oprct1x, a.anali_act_ct2 oprct2x, 
    (1000/a.anali_fch) cbstx,
    ROUND((((c.anali_hc * c.anali_wh)/c.anali_fch)*1000),0) * c.anali_eff tqtyx,
    c.anali_hc hcx, c.anali_wh whx
  FROM ie_capacity_analid a 
  LEFT JOIN toy_part_cbsd b ON a.anali_proc_id = b.CBSD_ID
  LEFT JOIN ie_capacity_analih c ON a.anali_id = c.anali_id
  WHERE a.anali_id = '68' AND IFNULL(b.CBSD_PROC_FCH, 0) <> 0
  UNION ALL
  SELECT
    c.anali_id idx, c.anali_date datex, c.anali_line linex, c.anali_lead leadx, c.anali_part partx, c.anali_fch pfchx, c.anali_group groupx, 
    'CUS' pflagx, a.anali_proc_id procx, a.anali_proc procdx, a.anali_mc mcx, a.anali_fch fchx, IFNULL(a.anali_opr, '') oprx, c.anali_eff effx,
    a.anali_act_ct1 oprct1x, a.anali_act_ct2 oprct2x,
    (1000/a.anali_fch) cbstx,
    ROUND((((c.anali_hc * c.anali_wh)/c.anali_fch)*1000),0) * c.anali_eff tqtyx,
    c.anali_hc hcx, c.anali_wh whx
  FROM ie_capacity_analidc a
  LEFT JOIN ie_capacity_analih c ON a.anali_id = c.anali_id
  WHERE a.anali_id = '68'
) a
LEFT JOIN toy_part b on a.partx = b.PART_NUM
LEFT JOIN line c on a.linex = c.LINE_CODE;