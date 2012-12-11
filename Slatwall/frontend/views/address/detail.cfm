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
<cfparam name="address" type="any" />
<cfparam name="edit" type="boolean" default="true" />
<cfparam name="fieldNamePrefix" type="string" default="" />
<cfparam name="showName" type="boolean" default="true" />
<cfparam name="showCompany" type="boolean" default="true" />
<cfparam name="showStreetAddress" type="boolean" default="true" />
<cfparam name="showStreet2Address" type="boolean" default="true" />
<cfparam name="showLocality" type="boolean" default="true" />
<cfparam name="showCity" type="boolean" default="true" />
<cfparam name="showState" type="boolean" default="true" />
<cfparam name="showPostalCode" type="boolean" default="true" />
<cfparam name="showCountry" type="boolean" default="true" />

<cfoutput>
	<div class="addressDisplay">
		<cfif edit>
			<dl>
				<cfif showCountry>
					<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#countryCode" property="countryCode" fieldType="select" edit="true" />
				</cfif>
				<cfif showName>
					<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#name" property="name" edit="true" />
				</cfif>
				<cfif showCompany>
					<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#company" property="company" edit="true" />
				</cfif>
				<cfif address.getCountry().getStreetAddressShowFlag() and showStreetAddress>
					<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#streetAddress" property="streetAddress" edit="true" />
				</cfif>
				<cfif address.getCountry().getStreet2AddressShowFlag() and showStreet2Address>
					<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#street2Address" property="street2Address" edit="true" />
				</cfif>
				<cfif address.getCountry().getCityShowFlag() and showCity>
					<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#city" property="city" edit="true" />
				</cfif>
				<cfif address.getCountry().getStateCodeShowFlag() and showState>
					<cfif arrayLen(address.getStateCodeOptions()) gt 1>
						<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#stateCode" property="stateCode" fieldType="select" edit="true" />
					<cfelse>
						<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#stateCode" property="stateCode" fieldType="text" edit="true" />
					</cfif>
				</cfif>
				<cfif address.getCountry().getPostalCodeShowFlag() and showPostalCode>
					<cf_SlatwallPropertyDisplay object="#address#" fieldName="#fieldNamePrefix#postalCode" property="postalCode" edit="#edit#" />
				</cfif>
				<input type="hidden" name="#fieldNamePrefix#addressID" value="#address.getAddressID()#" />
			</dl>
			
			<script type="text/javascript">
				jQuery(document).ready(function(){
					jQuery('select[name="#fieldNamePrefix#countryCode"]').change(function() {
						jQuery.ajax({
							type: 'get',
							url: '/plugins/Slatwall/api/index.cfm/country/' + jQuery('select[name="#fieldNamePrefix#countryCode"]').val() + '/',
							data: {
								apiKey: '#$.slatwall.getAPIKey("country", "get")#'
							},
							dataType: "json",
							context: document.body,
							success: function(r) {
								console.log(r);
							}
						});
					});
				});
			</script>
		<cfelse>
			<cfif len(address.getName())><strong>#address.getName()#</strong><br /></cfif>
			<cfif len(address.getCompany())>#address.getCompany()#<br /></cfif>
			<cfif len(address.getStreetAddress())>#address.getStreetAddress()#<br /></cfif>
			<cfif len(address.getStreet2Address())>#address.getStreet2Address()#<br /></cfif>
			<cfif len(address.getCity())>#address.getCity()#, </cfif>
			<cfif len(address.getStateCode())>#address.getStateCode()# </cfif>
			<cfif len(address.getPostalCode())>#address.getPostalCode()#</cfif><br />
			<cfif len(address.getCountryCode())>#address.getCountryCode()#</cfif>
		</cfif>
	</div>
</cfoutput>