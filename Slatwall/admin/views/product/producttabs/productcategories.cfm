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

<!---<cfoutput>
	<cfif rc.edit>
		<input type="hidden" name="productCategories" value="" />
		<input type="hidden" name="productCategoriesFeatured" value="" />
		<cfif rc.categories.recordCount gt 0>
			<table id="productCategories" class="listing-grid stripe">
				<tr>
					<th></th>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productCategories.categoryTitle")#</th>
					<th>#$.slatwall.rbKey("admin.product.productCategories.isFeatured")#</th>
				</tr>
				<cfloop query="rc.categories">
					<tr>
						<td>
							<input type="hidden" name="pcPath_#rc.categories.categoryID#" value="#rc.categories.idPath#">
							<input type="checkbox" name="productCategories" value="#rc.categories.categoryID#" <cfif listFind(rc.product.getCategoryIDs(), rc.categories.categoryID)> checked="checked"</cfif>/> 
						</td>
						<cfset local.thisNest = rc.categories.treeDepth eq 0 ? "neston" : "nest" & rc.categories.treeDepth & "on" />
						<td class="varWidth">
							<ul class="#local.thisNest#">
				                <li class="Category"><label for="#rc.categories.categoryID#">#rc.categories.name#</label></li>
							</ul> 
						</td>
						<td>
							<input type="checkbox" name="productCategoriesFeatured" value="#rc.categories.categoryID#"<cfif listFind(rc.product.getCategoryIDs(featured="true"),rc.categories.categoryID)> checked="checked"</cfif> /> 
						</td>
					</tr>	
				</cfloop>
			</table>
		<cfelse>
			<p><em>#rc.$.Slatwall.rbKey("categorymanager.nocategories")#</em></p>
		</cfif>
	<cfelse>
		<cfif arrayLen(rc.product.getProductCategories())>
			<table id="ProductCategories" class="listing-grid stripe">
				<tr>
					<th class="varWidth">#rc.$.Slatwall.rbKey("admin.product.productCategories.categoryTitle")#</th>
					<th>#rc.$.Slatwall.rbKey("admin.product.productCategories.categoryPath")#</th>
					<th>#$.slatwall.rbKey("admin.product.productCategories.isFeatured")#</th>
				</tr>
				<cfloop query="rc.categories">
					<cfif listFindNoCase(rc.product.getCategoryIDs(),rc.categories.categoryID)>
						<tr>
							<td class="varWidth">#rc.categories.Name#</td>
							<td>#listChangeDelims(rc.categories.namePath," &raquo; ")#</td>
							<td>
								<cfif listFind(rc.product.getCategoryIDs(featured="true"),rc.categories.categoryID)>
									<img src="#$.slatwall.getSlatwallRootPath()#/staticAssets/images/admin.ui.check_green.png" with="16" height="16" alt="#rc.$.Slatwall.rbkey('sitemanager.yes')#" title="#rc.$.Slatwall.rbkey('sitemanager.yes')#" />
								</cfif>
							</td>
						</tr>
					</cfif>
				</cfloop>
			</table>
		<cfelse>
			<em>#rc.$.Slatwall.rbKey("admin.product.productCategories.noProductCategoriesAssigned")#</em>
		</cfif>
	</cfif>	
</cfoutput>--->