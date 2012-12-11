<cfoutput>
	
<script language="JavaScript">
	priceGroupData = #rc.priceGroupDataJSON#;	
</script>

<!--- These are DIVs used by the modal dialog for the SKUs price grid. We can't put this into skus.cfm since we need to avoid nested forms. --->
<div id="updatePriceGroupSKUSettingsDialog" class="ui-helper-hidden dialog" title="#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.title')#">
	<form action="#buildURL('admin:product.updatePriceGroupSKUSettings')#" method="post">
		<input type="hidden" name="productId" value="#rc.product.getProductId()#">
		
		<dl class="twoColumn">
			<dt class="title">#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.groupname')#: </dt>
			<dd class="value"><span id="updatePriceGroupSKUSettings_GroupName"></span></dd>
			
			<dt class="title">#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.currentrate')#: </dt>
			<dd class="value"><span id="updatePriceGroupSKUSettings_CurrentRate"></span></dd>
			
			<dt class="title">#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.selectrate')#: </dt>
			<dd class="value">
				<p class="ui-helper-hidden">No rates were defined for this price group.</p>
					
				<select name="priceGroupRateId" id="updatePriceGroupSKUSettings_PriceGroupRateId">
					<option value="new amount">#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.newamount')#</option>
					<option value="inherited">#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.inherited')#</option>
					<option value="">#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.selectarate')#</option>	
				</select>
				
				<div id="updatePriceGroupSKUSettings_norates" class="ui-helper-hidden">
					<p>#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.norates')#</p>
				</div>		
			</dd>
			<dt class="title ui-helper-hidden" id="updatePriceGroupSKUSettings_newAmountTitle">#rc.$.Slatwall.rbKey('admin.product.pricegroupskuupdatedialog.newamount')#: </dt>
			<dd class="value ui-helper-hidden" id="updatePriceGroupSKUSettings_newAmountValue">$<input type="text" name="amount"></dd>
		</dl>
	</form>
</div>
</cfoutput>