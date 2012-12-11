<form action="?s=1">
	<input type="hidden" name="slatAction" value="mura:main.updateviews" />
	<cfset assignedSites = application.pluginManager.getConfig("Slatwall").getAssignedSites() />
	<select name="siteid">
		<cfloop query="assignedSites">
			<cfoutput><option value="#assignedSites.siteID#">#assignedSites.siteID#</option></cfoutput>
		</cfloop>
	</select>
	<button type="submit">Update Frontend Views</button>
</form>