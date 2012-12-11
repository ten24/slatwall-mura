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
<cfparam name="rc.productImage" type="any" />
<cfparam name="rc.product" type="any" default="#rc.productImage.getProduct()#"/>
<cfparam name="rc.edit" type="boolean" default="false" />

<cfoutput>
	<cf_SlatwallDetailForm object="#rc.productImage#" edit="#rc.edit#" enctype="multipart/form-data">
		<cf_SlatwallActionBar type="detail" object="#rc.productImage#" edit="#rc.edit#">
		</cf_SlatwallActionBar>
		<input type="hidden" name="product.productID" value="#rc.product.getProductID()#" />
		<input type="hidden" name="returnAction" value="admin:product.editProduct&productID=#rc.product.getProductID()###tabalternateimages" />
		<cf_SlatwallDetailHeader>
			<cf_SlatwallPropertyList>
				<cf_SlatwallPropertyDisplay object="#rc.productImage#" property="imageName" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.productImage#" property="imageDescription" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.productImage#" property="imageType" edit="#rc.edit#">
				<cf_SlatwallPropertyDisplay object="#rc.productImage#" property="imageFile" edit="#rc.edit#" fieldtype="file">
				
				<div class="control-group">
					<label class="control-label">&nbsp;</label>
					<div class="controls">
						<cfif len(trim(rc.productImage.getImageFile()))>
							<img src="#rc.productImage.getResizedImagePath(width="200",height="200")#" border="0" /><br />
							<input type="checkbox" name="deleteImage" value="1" /> Delete
						</cfif>	
					</div>
				</div>
			</cf_SlatwallPropertyList>
		</cf_SlatwallDetailHeader>
		
	</cf_SlatwallDetailForm>

</cfoutput>