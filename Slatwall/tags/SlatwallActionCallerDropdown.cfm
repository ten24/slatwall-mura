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
<cfparam name="attributes.title" type="string" default="">
<cfparam name="attributes.icon" type="string" default="plus">
<cfparam name="attributes.type" type="string" default="button" />
<cfparam name="attributes.dropdownClass" type="string" default="" />
<cfparam name="attributes.buttonClass" type="string" default="btn-primary" />

<cfif thisTag.executionMode is "end">
	<cfif len(thisTag.generatedContent) gt 5>
		<cfif attributes.type eq "button">
			<cfoutput>
				<div class="btn-group">
					<button class="btn #attributes.buttonClass# dropdown-toggle" data-toggle="dropdown"><i class="icon-#attributes.icon# icon-white"></i> #attributes.title# <span class="caret"></span></button>
					<ul class="dropdown-menu #attributes.dropdownClass#">
						#thisTag.generatedContent#
						<cfset thisTag.generatedContent = "" />
					</ul>
				</div>
			</cfoutput>
		<cfelseif attributes.type eq "nav">
			<cfoutput>
				<li class="dropdown ">
					<a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-#attributes.icon#"></i> #attributes.title# </a>
					<ul class="dropdown-menu #attributes.dropdownClass#">
						#thisTag.generatedContent#
						<cfset thisTag.generatedContent = "" />
					</ul>
				</li>
			</cfoutput>
		</cfif>
	</cfif>
</cfif>
