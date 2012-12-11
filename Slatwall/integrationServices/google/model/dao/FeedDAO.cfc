<cfcomponent accessors="true" output="false">
	
	
	<cffunction name="getProductFeedQuery" access="public" output="false" returntype="Query">
		<cfset rs = "" />
		
		<cfquery name="rs">
			SELECT
				SlatwallSku.skuCode,
				SlatwallProduct.calculatedTitle,
				
			FROM
				SlatwallSku
			  INNER JOIN
			  	SlatwallProduct
			WHERE
				SlatwallSku.activeFlag = 1
			  AND
			  	SlatwallProduct.activeFlag = 1
			  AND
			  	SlatwallProduct.publishedFlag = 1
			  AND
			  	SlatwallProduct.calculatedQATS > 0
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
</cfcomponent>