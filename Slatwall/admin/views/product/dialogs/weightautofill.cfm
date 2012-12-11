<cfoutput>
	<div id="updateAllSKUWeightsDialog" class="ui-helper-hidden dialog" title="#rc.$.Slatwall.rbKey('admin.product.skuweightupdatedialog.title')#">
		<form action="#buildURL('admin:product.updateSKUWeights')#" method="post">
			<input type="hidden" name="productID" value="#rc.product.getProductId()#">	
			#rc.$.Slatwall.rbKey('admin.product.skuweightupdatedialog.newweight')#: <input type="text" name="weight">
		</form>
	</div>
</cfoutput>