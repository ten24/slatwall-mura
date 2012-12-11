<!---

    Slatwall - An e-commerce plugin for Mura CMS
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
<cfparam name="attributes.smartList" type="any" />
<cfparam name="attributes.showValue" default="" />
<cfparam name="attributes.showOptions" default="10,25,50,100,250,1000,ALL" />
<cfparam name="attributes.class" default="smartListPager" />

<cfset variables.fw = caller.this />

<cfif attributes.showValue eq "">
	<cfset attributes.showValue = attributes.smartList.getPageRecordsShow() />
</cfif>

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="#attributes.class#">
			<cfif attributes.smartList.getTotalPages() gt 1>
				<span class="showing">Showing #attributes.smartList.getPageRecordsStart()#-#attributes.smartList.getPageRecordsEnd()# (of #attributes.smartList.getRecordsCount()#)</span>
				<ul class="pages">
					<cfif attributes.smartList.getCurrentPage() gt 1>
						<li class="prev"><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() - 1#')#">Prev</a></li>
					</cfif>
					<cfloop from="1" to="#attributes.smartList.getTotalPages()#" step="1" index="i">
						<cfset currentPage = attributes.smartList.getCurrentPage() />
						<li class="page#i#<cfif currentPage eq i> current</cfif>">
							<cfif currentPage neq i>
								<a href="#attributes.smartList.buildURL('P:Current=#i#')#">#i#</a>
							<cfelse>
								<span>#i#</span>
							</cfif>
						</li>
					</cfloop>
					<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
						<li class="next"><a href="#attributes.smartList.buildURL('P:Current=#attributes.smartList.getCurrentPage() + 1#')#">Next</a></li>
					</cfif>
				</ul>
			</cfif>
			<cfset selectID = createUUID().toString() />
			<span class="show">Show: </span>
			<select id="#selectID#" name="P:Show">
				<cfloop list="#attributes.showOptions#" index="i" >
					<option value="#attributes.smartList.buildURL('P:Show=#i#')#" <cfif attributes.showValue eq i>selected='selected'</cfif>>#i#</option>
				</cfloop>
			</select>
			
			<script type="text/javascript">
				$('###selectID#').change(function() {
					window.location.href = $('###selectID#').val();
				});
			</script>
		</div>
	</cfoutput>
</cfif>