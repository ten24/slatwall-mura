<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.product" type="any" />
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.product#" edit="#rc.edit#">
		<cf_SlatwallActionBar type="detail" object="#rc.product#" edit="#rc.edit#">
			<cf_SlatwallActionCaller action="admin:main.createimage" queryString="productID=#rc.product.getProductID()#&directory=product&returnAction=admin:product.detailproduct" type="list" modal=true />
			<li class="divider"></li>
			<cf_SlatwallProcessCaller entity="#rc.product#" action="admin:product.processproduct" processContext="updateSkus" querystring="productID=#rc.product.getProductID()#" type="list" modal="true" />
			<cf_SlatwallProcessCaller entity="#rc.product#" action="admin:product.processproduct" processContext="addOptionGroup" querystring="productID=#rc.product.getProductID()#" type="list" modal="true" />
			<cf_SlatwallProcessCaller entity="#rc.product#" action="admin:product.processproduct" processContext="addOption" querystring="productID=#rc.product.getProductID()#" type="list" modal="true" />
			<cf_SlatwallProcessCaller entity="#rc.product#" action="admin:product.processproduct" processContext="addSubscriptionTerm" querystring="productID=#rc.product.getProductID()#" type="list" modal="true" />
		</cf_SlatwallActionBar>
		
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList divClass="span6">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="activeFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="publishedFlag" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="productName" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="productCode" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="urlTitle" edit="#rc.edit#" valueLink="#rc.product.getProductURL()#">
			</cf_SlatwallPropertyList>
			<cf_SlatwallPropertyList divClass="span6">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="brand" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.product#" property="productType" edit="#rc.edit#">
				<cf_SlatwallFieldDisplay title="#$.slatwall.rbKey('define.qats.full')#" value="#rc.product.getQuantity('QATS')#">
				<cf_SlatwallFieldDisplay title="#$.slatwall.rbKey('define.qiats.full')#" value="#rc.product.getQuantity('QIATS')#">
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		<cf_SlatwallTabGroup object="#rc.product#" allowCustomAttributes="true">
			<cf_SlatwallTab view="admin:product/producttabs/skus" />
			<cf_SlatwallTab view="admin:product/producttabs/productdescription" />
			<cf_SlatwallTab view="admin:product/producttabs/productpages" />
			<cf_SlatwallTab view="admin:product/producttabs/productcategories" />
			<cf_SlatwallTab view="admin:product/producttabs/alternateimages" />
			<cf_SlatwallTab view="admin:product/producttabs/productreviews" />
			<cf_SlatwallTab view="admin:product/producttabs/relatedproducts" />
			<cf_SlatwallTab view="admin:product/producttabs/vendors" />
			<cf_SlatwallTab view="admin:product/producttabs/productsettings" />
			<cf_SlatwallTab view="admin:product/producttabs/skusettings" />
		</cf_SlatwallTabGroup>
		
	</cf_SlatwallDetailForm>

</cfoutput>