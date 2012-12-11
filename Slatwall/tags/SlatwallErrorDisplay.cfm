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
<!--- You can pass in a object, or just an array of errors --->
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.errors" type="array" default="#arrayNew(1)#" />

<cfparam name="attributes.errorName" type="string" default="" />
<cfparam name="attributes.displayType" type="string" default="label" />
<cfparam name="attributes.for" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfsilent>
		
		<cfif not arrayLen(attributes.errors) && isObject(attributes.object)>
			<cfif attributes.errorName eq "">
				<cfloop collection="#attributes.object.getErrors()#" item="errorName">
					<cfloop array="#attributes.object.getErrors()[errorName]#" index="thisError">
						<cfset arrayAppend(attributes.errors, thisError) />
					</cfloop>
				</cfloop>
			<cfelse>
				<cfif attributes.object.hasError( attributes.errorName )>
					<cfset attributes.errors = attributes.object.getError( attributes.errorName ) />
				</cfif>
			</cfif>
		</cfif>
		
	</cfsilent>
	<cfif arrayLen(attributes.errors)>
		<cfswitch expression="#attributes.displaytype#">
			<!--- LABEL Display --->
			<cfcase value="label">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><label for="#attributes.for#" generated="true" class="error">#error#</label></cfoutput>
				</cfloop>
			</cfcase>
			<!--- DIV Display --->
			<cfcase value="div">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><div class="error">#error#</div></cfoutput>
				</cfloop>
			</cfcase>
			<!--- P Display --->
			<cfcase value="p">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><p class="error">#error#</p></cfoutput>
				</cfloop>
			</cfcase>
			<!--- BR Display --->
			<cfcase value="br">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput>#error#<br /></cfoutput>
				</cfloop>
			</cfcase>
			<!--- SPAN Display --->
			<cfcase value="span">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><span class="error">#error#</span></cfoutput>
				</cfloop>
			</cfcase>
			<!--- LI Display --->
			<cfcase value="li">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><li class="error">#error#</li></cfoutput>
				</cfloop>
			</cfcase>
		</cfswitch>	
	</cfif>
</cfif>