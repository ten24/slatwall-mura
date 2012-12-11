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
<cfcomponent extends="BaseDAO" output="false">
	
	<cffunction name="getRelatedCommentsForEntity" returntype="Array" access="public">
		<cfargument name="primaryIDPropertyName" type="string" required="true" />
		<cfargument name="primaryIDValue" type="string" required="true" />
		
		<cftry>
			<cfset var results = ormExecuteQuery("SELECT NEW MAP(
				scr.commentRelationshipID as commentRelationshipID,
				scr.referencedRelationshipFlag as referencedRelationshipFlag,
				scr.referencedExpressionStart as referencedExpressionStart,
				scr.referencedExpressionEnd as referencedExpressionEnd,
				scr.referencedExpressionEntity as referencedExpressionEntity,
				scr.referencedExpressionProperty as referencedExpressionProperty,
				scr.referencedExpressionValue as referencedExpressionValue,
				c as comment
			)
			FROM
				SlatwallCommentRelationship scr INNER JOIN scr.comment c WHERE scr.#left(arguments.primaryIDPropertyName,len(arguments.primaryIDPropertyName)-2)#.#arguments.primaryIDPropertyName# = ?", [arguments.primaryIDValue]) />
			<cfcatch>
				<cfthrow message="You have tried to get comments for an entity that does not have a comment relationship setup.  The primaryID column for the entity requesting is #arguments.primaryIDPropertyName# and you may just need to add a Many-To-One property for this entity to CommentRelationship.cfc" />
			</cfcatch>
		</cftry>
		
		<cfreturn results /> 
	</cffunction>
	
	
	<cffunction name="deleteAllRelatedCommentsForEntity" returntype="boolean" access="public">
		<cfargument name="primaryIDPropertyName" type="string" required="true" />
		<cfargument name="primaryIDValue" type="string" required="true" />
		
		<cfset var relatedComments = getRelatedCommentsForEntity(argumentcollection=arguments) />
		<cfset var relatedComment = "" />
		
		<cfloop array="#relatedComments#" index="relatedComment" >
			<cfset var results = ormExecuteQuery("DELETE SlatwallCommentRelationship WHERE commentRelationshipID = ?", [relatedComment["commentRelationshipID"]]) />
			
			<cfif not relatedComment["referencedRelationshipFlag"]>
				<cfset var results = ormExecuteQuery("DELETE SlatwallComment WHERE commentID = ?", [relatedComment["comment"].getCommentID()]) />
			</cfif>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
</cfcomponent>