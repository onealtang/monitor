package sql

var (
	Get_Adunit_Summary = `
		SELECT a.campaignId as campaign_id,
		   a.campaignName as campaign_name,
		   b.cnt AS receive_count,
		   c.cnt AS postback_count
		FROM   adunit a
			   LEFT JOIN (SELECT campaign,
								 Count(DISTINCT( guid )) cnt
						  FROM   conversion_rel_act_clk
						  WHERE  1 = 1
						  and time between ? and ?
						  GROUP  BY campaign) b
					  ON a.campaignid = b.campaign
			   LEFT JOIN (SELECT campaignid,
								 Count(DISTINCT( deviceid )) AS cnt
						  FROM   call_postbacklog
						  WHERE  1 = 1
						  and createTime between ? and ?
						  GROUP  BY campaignid) c
					  ON a.campaignid = c.campaignid
              `
)