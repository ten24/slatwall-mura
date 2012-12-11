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
<cfoutput>
<div class="accountDetails">
	<form name="account" method="post">
		<h4>Login Details</h4>
		<dl>
			<cf_SlatwallErrorDisplay object="#rc.account#" errorName="cmsError" />
			<!--- login info --->
			<dt class="spdemailaddress">
				<label for="emailAddress" class="required">#$.slatwall.rbKey('entity.accountEmailAddress.emailAddress')#</label>
			</dt>
			<dd id="spdemailaddress">
				<cfset emailValue = "" />
				<cfif not isNull(rc.account.getPrimaryEmailAddress()) and not isNull(rc.account.getPrimaryEmailAddress().getEmailAddress())>
					<cfset emailValue = rc.account.getPrimaryEmailAddress().getEmailAddress() />	
				</cfif>
				<input type="text" name="emailAddress" value="#emailValue#" />
				<cf_SlatwallErrorDisplay object="#rc.account#" errorName="primaryEmailAddress" for="emailAddress" />
			</dd>
			<dt class="spdpassword">
				<label for="password">Password</label>
			</dt>
			<dd id="spdpassword">
				<input type="password" name="password" value="" />
				<cf_SlatwallErrorDisplay object="#rc.account#" errorName="password" for="password" />
			</dd>
		</dl>
		<input type="hidden" name="slatAction" value="frontend:account.save" />
		<button type="submit">Save</button>
	</form>
</div>
</cfoutput>

