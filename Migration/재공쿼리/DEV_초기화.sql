--DEV 
/*1. �ʱ�ȭ*/
	BEGIN TRAN  
		--UMLOT
		DELETE UMLOT WHERE FacilityID = 'PB1'
		DELETE LMLOTINFO WHERE FacilityID = 'PB1'
		DELETE LMSEGMENTRECORD WHERE FacilityID = 'PB1'
		DELETE UMWORKORDER WHERE FacilityID = 'PB1'
		DELETE LMWORKORDERINFO WHERE FacilityID = 'PB1'
	COMMIT
	

	
	
	 
	
		
		 
	
	
	
