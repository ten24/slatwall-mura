<!--- Menu Building based on Permissions --->
<cfset local.permissionService = request.slatwallScope.getService("permissionService") />
<cfsavecontent variable="local.productSub">
	<cfoutput>
		<cfif local.permissionService.secureDisplay('admin:product.listproduct')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listproduct">#request.slatwallScope.rbKey('entity.product_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:product.listproducttype')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listproducttype">#request.slatwallScope.rbKey('entity.producttype_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:product.listoptiongroup')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listoptiongroup">#request.slatwallScope.rbKey('entity.optiongroup_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:product.listbrand')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listbrand">#request.slatwallScope.rbKey('entity.brand_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:product.listsubscriptionterm')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listsubscriptionterm">#request.slatwallScope.rbKey('entity.subscriptionterm_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:product.listsubscriptionbenefit')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listsubscriptionbenefit">#request.slatwallScope.rbKey('entity.subscriptionbenefit_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:product.listproductreview')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.listproductreview">#request.slatwallScope.rbKey('entity.productreview_plural')#</a></li>	
		</cfif> 
		<cfif local.permissionService.secureDisplay('admin:pricing.listpromotion')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:pricing.listpromotion">#request.slatwallScope.rbKey('entity.promotion_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:pricing.listpricegroup')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:pricing.listpricegroup">#request.slatwallScope.rbKey('entity.pricegroup_plural')#</a></li>
		</cfif>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.orderSub">
	<cfoutput>
		<cfif local.permissionService.secureDisplay('admin:order.listorder')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:order.listorder">#request.slatwallScope.rbKey('entity.order_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:order.listorderfulfillment')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:order.listorderfulfillment">#request.slatwallScope.rbKey('entity.orderfulfillment_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:vendor.listvendororder')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:vendor.listvendororder">#request.slatwallScope.rbKey('entity.vendororder_plural')#</a></li>
		</cfif>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.accountSub">
	<cfoutput>
		<cfif local.permissionService.secureDisplay('admin:account.listaccount')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:account.listaccount">#request.slatwallScope.rbKey('entity.account_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:vendor.listvendor')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:vendor.listvendor">#request.slatwallScope.rbKey('entity.vendor_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:account.listsubscriptionusage')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:account.listsubscriptionusage">#request.slatwallScope.rbKey('entity.subscriptionusage_plural')#</a></li>
		</cfif>
		<cfif local.permissionService.secureDisplay('admin:account.listpermissiongroup')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:account.listpermissiongroup">#request.slatwallScope.rbKey('entity.permissiongroup_plural')#</a></li>
		</cfif>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.integrationSub">
	<cfoutput>
		<cfif local.permissionService.secureDisplay('admin:integration.listintegration')>
			<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:integration.listintegration">#request.slatwallScope.rbKey('entity.integration_plural')#</a></li>
		</cfif>
		<cfset local.integrationSubsystems = request.slatwallScope.getService('integrationService').getActiveFW1Subsystems() />
		<cfloop array="#local.integrationSubsystems#" index="local.intsys">
			<cfif local.permissionService.secureDisplay('#local.intsys.subsystem#:main.default')>
				<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=#local.intsys.subsystem#:main.default">#local.intsys.name#</a></li>
			</cfif>
		</cfloop>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="local.pageSub">
	<cfoutput>
		<cfif not request.slatwallScope.getCurrentProduct().isNew()>
			<cfif local.permissionService.secureDisplay('admin:product.detailproduct')>
				<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.detailproduct&productID=#request.slatwallScope.getCurrentProduct().getProductID()#">Product Admin</a></li>
			</cfif>
			<cfif local.permissionService.secureDisplay('admin:product.detailproducttype')>
				<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.detailproducttype&productTypeID=#request.slatwallScope.getCurrentProduct().getProductType().getProductTypeID()#">Product Type Admin</a></li>
			</cfif>
			<cfif local.permissionService.secureDisplay('admin:product.detailbrand') && !isNull(request.slatwallScope.getCurrentProduct().getBrand())>
				<li><a href="#request.slatwallScope.getSlatwallRootURL()#/?slatAction=admin:product.detailbrand&brandID=#request.slatwallScope.getCurrentProduct().getBrand().getBrandID#">Brand Admin</a></li>
			</cfif>
		</cfif>
	</cfoutput>
</cfsavecontent>

<!--- Actual Output --->
<cfif len(local.productSub) or len(local.orderSub) or len(local.accountSub) or len(local.integrationSub) or len(pageSub)>
	<cfoutput>
		<link rel="stylesheet" href="#request.slatwallScope.getSlatwallRootURL()#/assets/fetools/fetools.css" type="text/css" media="all" />
		<script src="#request.slatwallScope.getSlatwallRootURL()#/assets/fetools/fetools.js" type="text/javascript" language="Javascript"></script>
		<div id="sw-fetools">
			<div class="sw-handle">
				<a href="##" class="sw-logo"></a>	
			</div>
			<ul class="sw-menu">
				<cfif len(local.productSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-tags"></i> #request.slatwallScope.rbKey('admin.product_nav')#</a>
						<ul>
							#local.productSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.orderSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-inbox"></i> #request.slatwallScope.rbKey('admin.order_nav')#</a>
						<ul>
							#local.orderSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.accountSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-user"></i> #request.slatwallScope.rbKey('admin.account_nav')#</a>
						<ul>
							#local.accountSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.integrationSub)>
					<li>
						<a href="##" class="sw-submenu-toggle"><i class="icon icon-random"></i> #request.slatwallScope.rbKey('admin.integration_nav')#</a>
						<ul>
							#local.integrationSub#
						</ul>
					</li>
					<li class="divider"></li>
				</cfif>
				<cfif len(local.pageSub)>
					<li>
						<a href="##" class="sw-submenu-toggle active"><i class="icon icon-file"></i> Page Tools</a>
						<ul class="open">
							#local.pageSub#
						</ul>
					</li>
				</cfif>
			</ul>	
		</div>
	</cfoutput>
</cfif>