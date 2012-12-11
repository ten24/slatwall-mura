/*

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

*/
component displayname="Schedule" entityname="SlatwallSchedule" table="SlatwallSchedule" persistent="true" accessors="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="scheduleID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="scheduleName" ormtype="string";
	
	property name="recuringType" ormtype="string" formFieldtype="select";										// Daily, Weekly, Monthly										Daily	
	property name="daysOfWeekToRun" ormtype="string" formfieldType="checkboxgroup";		// 1, 2, 3, 4, 5, 6, 7											NULL	(required if recuringType is weekly)
	property name="daysOfMonthToRun" ormtype="string" formfieldType="checkboxgroup";	// 1 - 31			[1,10,20]									NULL	(required if recuringType is monthly)
	
	// During an individual Day
	property name="frequencyInterval" ormtype="integer";								// 1 - x (minutes)
	property name="frequencyStartTime" ormtype="timestamp" formfieldType="time" formatType="time";		// 4 PM	
	property name="frequencyEndTime" ormtype="timestamp" formfieldType="time" formatType="time";			// 12 PM	
	
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	
	
	
	public array function getRecuringTypeOptions() {
		var options = [
			{name="Daily", value="daily"},
			{name="Weekly", value="weekly"},
			{name="Monthly", value="monthly"}
		];
		return options;
	}

	public array function getDaysOfWeekToRunOptions() {
		var options = [
			{name="Sunday", value="1"},
			{name="Monday", value="2"},
			{name="Tuesday", value="3"},
			{name="Wednesday", value="4"},
			{name="Thursday", value="5"},
			{name="Friday", value="6"},
			{name="Saturday", value="7"}
		];
		return options;
	}

	public array function getDaysOfMonthToRunOptions() {
		var options = [];
		for(var i=1; i<=31; i++) {
			arrayAppend(options,i) ;
		}
		return options;
	}

	public string function getNextRunDateTime(startDateTime, endDateTime){
		var nextRun='';
		
		if(endDateTime > now()){
			switch(getrecuringType()){
				case 'Daily':
					//task is daily
					
					if(startDateTime > now()){
						//is the start time in the future?
						nextRun= createDateTime(year(startDateTime),month(startDateTime),day(startDateTime),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
					}else if(!len(getfrequencyEndTime())){
						var updatedStart = createDateTime(year(now()),month(now()),day(now()),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						if(updatedStart > now()){
							//hasn't run today
							nextRun=updatedStart;
						}else{
							//has already run for today
							tomorrow = dateadd("d",1,now());
							nextRun= createDateTime(year(tomorrow),month(tomorrow),day(tomorrow),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}
					}else if(isBetweenHours(getFrequencyStartTime(),getFrequencyEndTime(),now())){
					//is the next time today?
						//currently in the run period. work out next interval
						nextRun=getNextTimeSlot(getFrequencyStartTime(),getFrequencyInterval(),now());
					}else{
						//next time is tomorrow and start time
						tomorrow = dateadd("d",1,now());
						nextRun= createDateTime(year(tomorrow),month(tomorrow),day(tomorrow),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
					}
					
				break;
				
				case 'Weekly':
					var todayNumber = dayofweek(now());
					
					if(startDateTime > now()){
						var futureDayNumber=dayofweek(startDateTime);
						
						var nextDay='';
						
						for(i=1; i <= listLen(getDaysOfWeekToRun()); i++){
							if(listgetAt(getDaysOfWeekToRun(),i) > todayNumber){
								nextDay=listGetAt(getDaysOfWeekToRun(),i);
							}
						}
						
						if(nextDay ==''){
							nextDay=listgetAt(getDaysOfWeekToRun(),1);
						}
						
						if(nextDay < todayNumber){
							nextRunDay = (7-dayofweek(now())) + nextDay;
						}else{
							nextRunDay = nextDay - todayNumber;
						}
						
						nextDay = dateadd("d",nextRunDay,startDateTime);
						nextRun= createDateTime(year(nextDay),month(nextDay),day(nextDay),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						
					} else if(listfind(getdaysOfWeekToRun(),dayofweek(now())) && !len(getFrequencyEndTime())){
						//only runs once 
						
						var updatedStart = createDateTime(year(now()),month(now()),day(now()),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						if(updatedStart > now()){
							nextRun=getNextTimeSlot(getFrequencyStartTime(),getFrequencyInterval(),now());
						}else{
							var nextDay='';
						
						for(i=1; i <= listLen(getDaysOfWeekToRun()); i++){
							if(listgetAt(getDaysOfWeekToRun(),i) > todayNumber){
								nextDay=listGetAt(getDaysOfWeekToRun(),i);
							}
						}
						
						if(nextDay ==''){
							nextDay=listgetAt(getDaysOfWeekToRun(),1);
						}
						
						if(nextDay < todayNumber){
							nextRunDay = (7-dayofweek(now())) + nextDay;
						}else{
							nextRunDay = nextDay - todayNumber;
						}
						
						nextDay = dateadd("d",nextRunDay,now());
						nextRun= createDateTime(year(nextDay),month(nextDay),day(nextDay),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}	
					}else if(listfind(getdaysOfWeekToRun(),dayofweek(now())) && isBetweenHours(getFrequencyStartTime(),getFrequencyEndTime(),now())){	
					//is the next time today?
					
						//it runs today. are we in the window?
						//currently in the run period. work out next interval
						nextRun=getNextTimeSlot(getFrequencyStartTime(),getFrequencyInterval(),now());
					}else{
						//next time is next schedule day and start time
						var nextDay='';
						
						for(i=1; i <= listLen(getDaysOfWeekToRun()); i++){
							if(listgetAt(getDaysOfWeekToRun(),i) > todayNumber){
								nextDay=listGetAt(getDaysOfWeekToRun(),i);
							}
						}
						
						if(nextDay ==''){
							nextDay=listgetAt(getDaysOfWeekToRun(),1);
						}
						
						if(nextDay < todayNumber){
							nextRunDay = (7-dayofweek(now())) + nextDay;
						}else{
							nextRunDay = nextDay - todayNumber;
						}
						
						nextDay = dateadd("d",nextRunDay,now());
						nextRun= createDateTime(year(nextDay),month(nextDay),day(nextDay),hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
					}
					
				break;
				
				case 'Monthly':
					
					if(startDateTime > now()){
						for(i=1; i <= listLen(getDaysOfMonthToRun()); i++){
							if(listgetAt(getDaysOfMonthToRun(),i) > day(startDateTime)){
								nextDay=listGetAt(getDaysOfMonthToRun(),i);
							}
						}
						
						if(nextDay==''){
							//remember to account for new years!
							
							nextDay = listGetAt(getDaysOfMonthToRun,1);
							nextRun= createDateTime(year(startDateTime),month(startDateTime),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
							nextRun = dateAdd("m",1,nextRun);
						}else{
							nextRun= createDateTime(year(startDateTime),month(startDateTime),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}
												
						//is the next time today?
					}else if(listfind(getDaysOfMonthToRun(),day(now())) && isBetweenHours(getFrequencyStartTime(),getFrequencyEndTime(),now())){
						//it runs today. are we in the window?
						//currently in the run period. work out next interval
						nextRun=getNextTimeSlot(getFrequencyStartTime(),getFrequencyInterval(),now());
					}else{
						//next time is next schedule day and start time
						
						nextDay='';
						
						for(i=1; i <= listLen(getDaysOfMonthToRun()); i++){
							if(listgetAt(getDaysOfMonthToRun(),i) > day(now)){
								nextDay=listGetAt(getDaysOfMonthToRun(),i);
							}
						}
						
						if(nextDay==''){
							//remember to account for new years!
							
							nextDay = listGetAt(getDaysOfMonthToRun,1);
							nextRun= createDateTime(year(now()),month(now()),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
							nextRun = dateAdd("m",1,nextRun);
						}else{
							nextRun= createDateTime(year(now()),month(now()),nextDay,hour(getFrequencyStartTime()),minute(getFrequencyStartTime()),second(getFrequencyStartTime()));
						}
					}	
						
				break;
				
			}
		}
		
		//if next run is after the end time then it will not be run again
		if(nextRun > endDateTime){
			nextRun='';
		}
		return nextRun;
	}
	
	private boolean function isBetweenHours(required startTime, required endTime, required testTime){
		var response = false;
		var formattedStartTime = createDateTime(year(testTime),month(testTime),day(testTime),hour(startTime),minute(startTime),second(startTime));
		var formattedEndTime = createDateTime(year(testTime),month(testTime),day(testTime),hour(endTime),minute(endTime),second(endTime));
		
		if( formattedStartTime lte testTime && testTime lte formattedEndTime){
			response=true;
		}
		
		return response;
	}	
	
	private function getNextTimeSlot(required startTime, required numeric interval, required targetTime){
		var found = false;
		var processingTime=createDateTime(year(targetTime),month(targetTime),day(targetTime),hour(startTime),minute(startTime),second(startTime));
		
		while(!found){
			
			if(processingTime gt targetTime){
				found = true;
			}else{
				processingTime=dateAdd("n",interval,processingTime);
			}
		}
		return processingTime;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}