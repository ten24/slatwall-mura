<cfoutput>
	<div id="updateAllSKUPricesDialog" class="ui-helper-hidden dialog" title="#rc.$.Slatwall.rbKey('admin.product.skupriceupdatedialog.title')#">
		<form action="#buildURL('admin:product.updateSKUPrices')#" method="post">
			<input type="hidden" name="productID" value="#rc.product.getProductId()#">	
			#rc.$.Slatwall.rbKey('admin.product.skupriceupdatedialog.newprice')#: <input type="text" name="price">
		</form>
	</div>
</cfoutput>