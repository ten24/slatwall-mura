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

<cfif thisTag.executionMode eq "start">
	<cfparam name="attributes.smartList" type="any" />
	<cfparam name="attributes.hiddenPageSymbol" type="string" default="..." />
	<cfparam name="attributes.previousPageSymbol" type="string" default="&laquo;" />
	<cfparam name="attributes.nextPageSymbol" type="string" default="&raquo;" /> 
	
	<cfsilent>
		<cfset local.pageStart = 1 />
		<cfset local.pageCount = 2 />
		
		<cfif attributes.smartList.getTotalPages() gt 6>
			<cfif attributes.smartList.getCurrentPage() lte 3>
				<cfset local.pageCount = 4 />
			<cfelseif attributes.smartList.getCurrentPage() gt 3 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
				<cfset local.pageStart = attributes.smartList.getCurrentPage()-1 />
			<cfelseif attributes.smartList.getCurrentPage() gte attributes.smartList.getTotalPages() - 3>
				<cfset local.pageStart = attributes.smartList.getTotalPages()-3 />
				<cfset local.pageCount = 4 />
			</cfif>
		<cfelse>
			<cfset local.pageCount = attributes.smartList.getTotalPages() - 1 />
		</cfif>
		
		<cfset local.pageEnd = local.pageStart + local.pageCount />
	</cfsilent>
	
	<cfoutput>
		<cfif attributes.smartList.getTotalPages() gt 1>
			<div class="sw-listing-pager">
				<div class="pagination">
					<ul>
						<cfif attributes.smartList.getCurrentPage() gt 1>
							<li><a href="?p:show=#attributes.smartList.getCurrentPage() - 1#" class="listing-pager prev" data-page="#attributes.smartList.getCurrentPage() - 1#">#attributes.previousPageSymbol#</a></li>
						<cfelse>
							<li class="disabled"><a href="##" class="listing-pager prev">#attributes.previousPageSymbol#</a></li>
						</cfif>
						<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() gt 3>
							<li><a href="?p:show=1" class="listing-pager" data-page="1">1</a></li>
							<li class="disabled"><a href="##">#attributes.hiddenPageSymbol#</a></li>
						</cfif>
						
						<cfloop from="#local.pageStart#" to="#local.pageEnd#" index="i" step="1">
							<li <cfif attributes.smartList.getCurrentPage() eq i>class="active"</cfif>><a href="?p:show=#i#" class="listing-pager" data-page="#i#">#i#</a></li>
						</cfloop>
						
						<cfif attributes.smartList.getTotalPages() gt 6 and attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages() - 3>
							<li class="disabled"><a href="##">#attributes.hiddenPageSymbol#</a></li>
							<li><a href="?p:show=#attributes.smartList.getTotalPages()#" class="listing-pager" data-page="#attributes.smartList.getTotalPages()#">#attributes.smartList.getTotalPages()#</a></li>
						</cfif>
						<cfif attributes.smartList.getCurrentPage() lt attributes.smartList.getTotalPages()>
							<li><a href="?p:show=#attributes.smartList.getCurrentPage() + 1#" class="listing-pager next" data-page="#attributes.smartList.getCurrentPage() + 1#">#attributes.nextPageSymbol#</a></li>
						<cfelse>
							<li class="disabled"><a href="##" class="listing-pager next">#attributes.nextPageSymbol#</a></li>
						</cfif>
					</ul>
				</div>
			</div>
		</cfif>
	</cfoutput>
</cfif>