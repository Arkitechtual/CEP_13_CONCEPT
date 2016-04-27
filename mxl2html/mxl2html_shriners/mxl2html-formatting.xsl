<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hl7="urn:hl7-org:v3">
	<xsl:template name="get-address">
		<xsl:param name="addr" />
		<br />
		<xsl:value-of select="$addr/hl7:streetAddressLine" />
		<br />
		<xsl:value-of select="$addr/hl7:city" />
		,
		<xsl:value-of select="$addr/hl7:state" />
		,
		<xsl:value-of select="$addr/hl7:postalCode" />
	</xsl:template>

	<xsl:template name="get-telecom">
		<xsl:param name="telecom" />
		<br />
		<xsl:value-of select="$telecom/@value" />
	</xsl:template>
	
	<!-- Get a Name  -->
	<xsl:template name="get-name">
		<xsl:param name="name" />
		<xsl:choose>
			<xsl:when test="$name/family">
				<xsl:value-of select="$name/given" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="$name/family" />
				<xsl:text> </xsl:text>
				<xsl:if test="$name/suffix">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$name/suffix" />
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="get-participant">
		<xsl:param name="participant" />

		<p>
			<xsl:call-template name="get-name">
				<xsl:with-param name="name" select="$participant/hl7:associatedPerson/hl7:name" />
			</xsl:call-template>
			<xsl:if test="$participant/hl7:addr">
				<xsl:call-template name="get-address">
					<xsl:with-param name="addr" select="$participant/hl7:addr" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$participant/hl7:telecom">
				<xsl:call-template name="get-telecom">
					<xsl:with-param name="telecom" select="$participant/hl7:telecom" />
				</xsl:call-template>
			</xsl:if>

		</p>
	</xsl:template>
	
	
	<!-- Transforms a datestring from YYYYMMDD to YYYY-MM-DD -->
	<xsl:template name="addSlashes">
		<xsl:param name="time" />
		<xsl:value-of select="substring($time, 1, 4)" />-<xsl:value-of select="substring($time, 5, 2)" />-<xsl:value-of select="substring($time, 7, 2)" />
	</xsl:template>
	
	<xsl:template name="format-xsl-date">
		<xsl:param name="date" />
		
		<xsl:variable name="ymd-list"> 
			<xsl:choose>
				<xsl:when test="contains($date, '-')">
					<xsl:for-each select="tokenize($date,'-')">
						<xsl:if test="string-length(.) &gt; 0">
 							<lala><xsl:value-of select="." /></lala>
 						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="contains($date, '/')"> 
					<xsl:variable name="tmp">
						<lala><xsl:value-of select="substring($date, 7, 5)" /></lala>
						<lala><xsl:value-of select="substring($date, 0, 3)" /></lala>
						<lala><xsl:value-of select="substring($date, 4, 2)" /></lala>
					</xsl:variable>
					<xsl:for-each select="$tmp/lala">
						<xsl:if test="string-length(.) &gt; 0">
 							<lala><xsl:value-of select="." /></lala>
 						</xsl:if>
 					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="tmp">
						<lala><xsl:value-of select="substring($date, 0, 5)" /></lala>
						<lala><xsl:value-of select="substring($date, 5, 2)" /></lala>
						<lala><xsl:value-of select="substring($date, 7, 2)" /></lala>
					</xsl:variable>
					<xsl:for-each select="$tmp/lala">
						<xsl:if test="string-length(.) &gt; 0">
 							<lala><xsl:value-of select="." /></lala>
 						</xsl:if>
 					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="$ymd-list/lala"><xsl:value-of select="."/><xsl:if test="position() != last()">-</xsl:if></xsl:for-each>
	</xsl:template>
		
	<xsl:template name="int-print-full-age">
		<xsl:param name="first-date" />
		<xsl:param name="second-date" />
		<xsl:param name="print-month" />
		<xsl:param name="print-year-letter" />
		
		<xsl:variable name="date0" select="xs:date($first-date)" />
		<xsl:variable name="date1" select="xs:date($second-date)" />
		
		<xsl:variable name="year0" select="substring($first-date, 0, 5)" />
		<xsl:variable name="year1" select="substring($second-date, 0, 5)" />

		<xsl:variable name="month0" select="substring($first-date, 6, 2)" />
		<xsl:variable name="month1" select="substring($second-date, 6, 2)" />

		<xsl:variable name="diff-years" select="number($year1) - number($year0)" />
		<xsl:variable name="diff-months" select="number($month1) - number($month0)" />
		
		<xsl:variable name="diff-months-mod">
			<xsl:if test="$diff-months &lt; 0"><xsl:value-of select="$diff-months + 12"/></xsl:if>
			<xsl:if test="$diff-months &gt;= 0"><xsl:value-of select="$diff-months"/></xsl:if>
		</xsl:variable>
		
		<xsl:variable name="month-correlation">
			<xsl:if test="($diff-months-mod) &gt;= 0"><xsl:value-of select="0" /></xsl:if>
			<xsl:if test="($diff-months-mod) &lt; 0"><xsl:value-of select="-1" /></xsl:if>
		</xsl:variable>

		<!-- Now we should calculate the difference between dates in number of days -->
		<xsl:variable name="days-duration" select="xs:duration($date1 - $date0)" />
		<xsl:variable name="total-days" select="days-from-duration($days-duration)" />
		
		<xsl:variable name="adiff-years" select="floor($total-days div 365.25)" />
		<!-- 
		<xsl:variable name="diff-months" select="floor(($total-days - $diff-years * $total-days) div 31)" />
		 -->
		 <!-- 
		<xsl:message>
			$total-days: "<xsl:value-of select="$total-days" />"
			$diff-years: "<xsl:value-of select="$diff-years" />"
			$diff-months-mod: "<xsl:value-of select="$diff-months-mod" />"
			$days-duration: "<xsl:value-of select="$days-duration" />"
		</xsl:message>-->
		
		<xsl:choose>
			<xsl:when test="$total-days &gt;= 365">
				<xsl:value-of select="$adiff-years" /><xsl:if test="$print-year-letter = 1">y</xsl:if><xsl:if test="$diff-months-mod != '0' and $print-month = 1">,<xsl:value-of select="$diff-months-mod" />m</xsl:if>
			</xsl:when>
			<xsl:when test="$total-days &lt; 365 and $total-days &gt;= 31">
				<xsl:value-of select="$diff-months-mod" />m
			</xsl:when>
			<xsl:when test="$total-days &lt; 31 and $total-days &gt;= 0">
				<xsl:value-of select="$total-days" />d
			</xsl:when>
			<xsl:otherwise>Future</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="int-print-month-year-age">
		<xsl:param name="first-date" />
		<xsl:param name="second-date" />
		<xsl:param name="print-month" />
		<xsl:param name="print-year-letter" />
		
		<xsl:variable name="year0" select="substring($first-date, 0, 5)" />
		<xsl:variable name="year1" select="substring($second-date, 0, 5)" />
		
		<!-- TODO: is the last param ok? -->
		<xsl:variable name="month0" select="substring($first-date, 6, 2)" />
		<xsl:variable name="month1" select="substring($second-date, 6, 2)" />
		
		<xsl:variable name="diff-years" select="number($year1) - number($year0)" />
		<xsl:variable name="diff-months" select="number($month1) - number($month0)" />
		
		<xsl:variable name="diff-months-mod">
			<xsl:if test="$diff-months &lt; 0"><xsl:value-of select="$diff-months + 12"/></xsl:if>
			<xsl:if test="$diff-months &gt;= 0"><xsl:value-of select="$diff-months"/></xsl:if>
		</xsl:variable>
		
		<xsl:variable name="month-correlation">
			<xsl:if test="($diff-months) &gt;= 0"><xsl:value-of select="0" /></xsl:if>
			<xsl:if test="($diff-months) &lt; 0"><xsl:value-of select="-1" /></xsl:if>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="($diff-years + $month-correlation &gt;= 1) and ($print-month = 1)">
				<xsl:if test="$diff-months &gt; 0"><xsl:value-of select="$diff-years + $month-correlation" /><xsl:if test="$print-year-letter = 1">y,</xsl:if><xsl:value-of
						select="$diff-months" />m</xsl:if>
				<xsl:if test="$diff-months &lt; 0"><xsl:value-of select="$diff-years + $month-correlation"
						/>y,<xsl:value-of select="12 + $diff-months" />m</xsl:if>
				<xsl:if test="$diff-months = 0"><xsl:value-of select="$diff-years + $month-correlation" /><xsl:if test="$print-year-letter = 1">y</xsl:if></xsl:if>
			</xsl:when>
			<xsl:when test="$diff-years + $month-correlation = 0">
				<xsl:if test="$diff-months &gt;= 0"><xsl:value-of select="$diff-months" />m</xsl:if>
				<xsl:if test="$diff-months &lt; 0"><xsl:value-of select="12 + $diff-months" />m</xsl:if>
			</xsl:when>
			<xsl:otherwise>Future</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="print-age">
		<xsl:param name="first-date" />
		<xsl:param name="second-date" required="no">
			<xsl:value-of select="substring(string(current-dateTime()), 0, 11)" />
		</xsl:param>
		<xsl:param name="print-month" required="no">1</xsl:param>
		<xsl:param name="print-year-letter" required="no">1</xsl:param>
		<xsl:param name="debug" required="no">0</xsl:param>
		
		<!-- STANDARDIZE THE INPUT -->
		<xsl:variable name="date0"><xsl:call-template name="format-xsl-date"><xsl:with-param name="date" select="$first-date" /></xsl:call-template></xsl:variable>
		<xsl:variable name="date1"><xsl:call-template name="format-xsl-date"><xsl:with-param name="date" select="$second-date" /></xsl:call-template></xsl:variable>

		<xsl:if test="$debug = 1">
			Date0: "<xsl:value-of select="$date0" />" Date1: "<xsl:value-of select="$date1" />"
		</xsl:if>
		
		<!-- Now we look at the days difference, and use a different formatter for days, months and years with months -->
		<xsl:variable name="output">
			<xsl:choose>
				<xsl:when test="string-length($date0) = 4 or string-length($date1) = 4">
					<xsl:variable name="year0" select="number(substring($date0, 0, 5))" />
					<xsl:variable name="year1" select="number(substring($date1, 0, 5))" />
					<xsl:if test="$year1 - $year0 &gt;= 0">
					<xsl:value-of select="$year1 - $year0" /><xsl:if test="$print-year-letter = 1">y</xsl:if>
					</xsl:if>
					<xsl:if test="$year1 - $year0 &lt; 0">
						Future
					</xsl:if>
				</xsl:when>
				<xsl:when test="string-length($date0) = 7 or string-length($date1) = 7">
					<xsl:call-template name="int-print-month-year-age">
						<xsl:with-param name="first-date" select="$date0" />
						<xsl:with-param name="second-date" select="$date1" />
						<xsl:with-param name="print-month" select="$print-month" />
						<xsl:with-param name="print-year-letter" select="$print-year-letter" />
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="string-length($date0) = 10 and string-length($date1) = 10">
					<xsl:call-template name="int-print-full-age">
						<xsl:with-param name="first-date" select="$date0" />
						<xsl:with-param name="second-date" select="$date1" />
						<xsl:with-param name="print-month" select="$print-month" />
						<xsl:with-param name="print-year-letter" select="$print-year-letter" />
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:value-of select="normalize-space($output)" />
	</xsl:template>
	

	<!--
		Format Date outputs a date in Month Day, Year form e.g., 19991207 ==> December 07, 1999
	-->
	<xsl:template name="format-date-long">
		<xsl:param name="date" />
		
		<xsl:variable name="contains-day" select="string-length($date) &gt;= 8" />
		<xsl:variable name="contains-month" select="string-length($date) &gt;= 6" />
		
		<xsl:if test="$contains-month">
			<xsl:variable name="month" select="substring ($date, 5, 2)" />
			<xsl:choose>
				<xsl:when test="$month='01'">
					<xsl:text>January </xsl:text>
				</xsl:when>
				<xsl:when test="$month='02'">
					<xsl:text>February </xsl:text>
				</xsl:when>
				<xsl:when test="$month='03'">
					<xsl:text>March </xsl:text>
				</xsl:when>
				<xsl:when test="$month='04'">
					<xsl:text>April </xsl:text>
				</xsl:when>
				<xsl:when test="$month='05'">
					<xsl:text>May </xsl:text>
				</xsl:when>
				<xsl:when test="$month='06'">
					<xsl:text>June </xsl:text>
				</xsl:when>
				<xsl:when test="$month='07'">
					<xsl:text>July </xsl:text>
				</xsl:when>
				<xsl:when test="$month='08'">
					<xsl:text>August </xsl:text>
				</xsl:when>
				<xsl:when test="$month='09'">
					<xsl:text>September </xsl:text>
				</xsl:when>
				<xsl:when test="$month='10'">
					<xsl:text>October </xsl:text>
				</xsl:when>
				<xsl:when test="$month='11'">
					<xsl:text>November </xsl:text>
				</xsl:when>
				<xsl:when test="$month='12'">
					<xsl:text>December </xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="$contains-day"><xsl:value-of select="substring ($date, 7, 2)"/></xsl:if>
		<xsl:if test="$contains-day or $contains-month">,</xsl:if>
		
		<!-- Print year -->
		<xsl:value-of select="substring ($date, 1, 4)" />
	</xsl:template>
	
	<xsl:template name="format-date-short">
		<xsl:param name="date" />
		<xsl:choose>
            <xsl:when test="$DATE_FORMAT='English'">
                <xsl:variable name="contains-day" select="string-length($date) &gt;= 8" />
                <xsl:variable name="contains-month" select="string-length($date) &gt;= 6" />

                <xsl:if test="$contains-day"><xsl:value-of select="substring ($date, 7, 2)"/>/</xsl:if>
                <xsl:if test="$contains-month"><xsl:value-of select="substring ($date, 5, 2)" />/</xsl:if>
                <xsl:value-of select="substring($date, 0, 5)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="contains-day" select="string-length($date) &gt;= 8" />
                <xsl:variable name="contains-month" select="string-length($date) &gt;= 6" />

                <xsl:if test="$contains-month"><xsl:value-of select="substring ($date, 5, 2)" />/</xsl:if><xsl:if
                    test="$contains-day"><xsl:value-of select="substring ($date, 7, 2)"/>/</xsl:if><xsl:value-of
                    select="substring($date, 0, 5)" />
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>
	
	<xsl:template name="format-date">
		<xsl:param name="date" />
		<xsl:param name="short" required="no">1</xsl:param>
		
		<xsl:choose>
			<xsl:when test="$short = 0">
				<xsl:call-template name="format-date-long">
					<xsl:with-param name="date" select="$date" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="format-date-short">
					<xsl:with-param name="date" select="$date" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="format-time">
		<xsl:param name="date" />
		
		<xsl:variable name="contains-hour" select="string-length($date) &gt;= 10" />
		<xsl:variable name="contains-minute" select="string-length($date) &gt;= 12" />
		<xsl:variable name="contains-second" select="string-length($date) &gt;= 14" />
	
		<xsl:variable name="final-time">
			<xsl:if test="$contains-hour">
				<xsl:variable name="hour">
					<xsl:value-of select="number(substring($date, 9, 2))"/>
				</xsl:variable>
				
				<xsl:variable name="normalized-hour-0">
					<xsl:choose>
						<xsl:when test="$hour = 0">12</xsl:when>
						<xsl:when test="$hour != 0 and $hour &lt;= 12"><xsl:value-of select="$hour" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="$hour - 12" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="normalized-hour">
					<xsl:choose>
						<xsl:when test="$normalized-hour-0 &lt; 10">0<xsl:value-of select="$normalized-hour-0" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="$normalized-hour-0" /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="time-suffix">
					<xsl:choose>
						<xsl:when test="$hour &lt; 12">AM</xsl:when>
						<xsl:otherwise>PM</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:choose>
				<xsl:when test="$contains-minute">
					<xsl:variable name="minute">
						<xsl:value-of select="number(substring($date, 11, 2))"/>
					</xsl:variable>
					
					<xsl:variable name="normalized-minute">
						<xsl:choose>
							<xsl:when test="$minute &lt; 10">0<xsl:value-of select="$minute" /></xsl:when>
							<xsl:otherwise><xsl:value-of select="$minute" /></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="$contains-second">
							<xsl:variable name="second">
								<xsl:value-of select="number(substring($date, 13, 2))"/>
							</xsl:variable>
							<xsl:variable name="normalized-second">
								<xsl:choose>
									<xsl:when test="$second &lt; 10">0<xsl:value-of select="$second" /></xsl:when>
									<xsl:otherwise><xsl:value-of select="$second" /></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:value-of select="$normalized-hour" />:<xsl:value-of select="$normalized-minute" />:<xsl:value-of select="$normalized-second" />
							&#160;<xsl:value-of select="$time-suffix" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$normalized-hour" />:<xsl:value-of select="$normalized-minute" />
							&#160;<xsl:value-of select="$time-suffix" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$normalized-hour" />&#160;<xsl:value-of select="$time-suffix" />
				</xsl:otherwise>
				</xsl:choose>
	       </xsl:if>
       </xsl:variable>
       
       <xsl:value-of select="normalize-space($final-time)" />
	</xsl:template>
	
	<xsl:template name="section-header">
		<xsl:param name="title" />
		<xsl:param name="name" />
        <xsl:param name="summary-div-id" />
        <xsl:param name="details-div-id" />
		
		<div class="wrap_window_header" id="width_measure">
			<table class="wrap_window_header_table">
			  <tbody>
			    <tr>
			      <td class="wrap_window_header_label"><xsl:value-of select="$title" /></td>
			      <td class="wrap_window_header_details">
                  <span class="but">
                      <span class="switch_button">
                          <xsl:attribute name="onclick">switchView('<xsl:value-of select="$summary-div-id"/>','<xsl:value-of select="$details-div-id"/>','sd')</xsl:attribute>
                          <xsl:attribute name="id">section-header-<xsl:value-of select="normalize-space($name)"/></xsl:attribute>
                          <xsl:choose>
                              <xsl:when test="normalize-space($name) = 'vital-signs-table'">
                                    <xsl:text>All Results</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                    <xsl:text>Summary/Details</xsl:text>
                              </xsl:otherwise>
                          </xsl:choose>
                      </span> &#160;
                      <span class="switch_button">
                          <xsl:attribute name="onclick">switchView('<xsl:value-of select="$summary-div-id"/>','<xsl:value-of select="$details-div-id"/>','pm')</xsl:attribute>
                          <xsl:attribute name="id">section-header-<xsl:value-of select="normalize-space($name)"/></xsl:attribute><xsl:text>+/-</xsl:text>
                      </span> &#160;
                      <span class="switch_button">
                          <xsl:attribute name="onclick">toPrint(this)</xsl:attribute>
                          <xsl:attribute name="id">section-header-<xsl:value-of select="normalize-space($name)"/></xsl:attribute><xsl:text>Print</xsl:text>
                      </span>
                  </span>
			             &#160;
			      </td>
			    </tr>
                <xsl:if test="$name = 'labs-table'">
			         <tr>
						<th colspan="2" style="font-size:10px">
							<!--<span class="switch_button" style="text-align:left;float:left;" onclick="codes(this)">codes on</span>-->
							<span style="text:align:right;float:right;" class="but">
								<span onclick="labviews('labs','1year');" id="labs-past-year" class="switch_button">Past Year</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs','18months');" id="labs-past-18month" class="switch_button">Past 18 Mo's</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs','2year');" id="labs-past-2year" class="switch_button">Past 2 Years</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs','3year');" id="labs-past-3year" class="switch_button">Past 3 Years</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs','all');" id="labs-past-all" class="switch_button">All Historical</span>
							</span>
						</th>
					</tr>
                  </xsl:if>
                  <xsl:if test="$name = 'labs-results-table'">
					<tr>
						<th colspan="2" style="font-size:10px">
							<!--<span id="{$name}_codes" class="switch_button" style="float:left;text-align:left" onclick="codes(this)">codes on</span>-->
							<span style="float:right;text-align: right;" class="but">
								<span onclick="labviews('labs-results','1year');" id="year" class="switch_button">Past Year</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs-results','18months');" id="18month" class="switch_button">Past 18 Mo's</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs-results','2year');" id="2year" class="switch_button">Past 2 Years</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs-results','3year');" id="3year" class="switch_button">Past 3 Years</span><xsl:text>&#32;</xsl:text>
								<span onclick="labviews('labs-results','all');" id="all" class="switch_button">All Historical</span>
							</span>
						</th>
					</tr>
				</xsl:if>
			  </tbody>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template name="make-empty-row-col">
		<xsl:param name="content" required="no" select="''" />
		<xsl:param name="last-content" required="no" select="''" />
		<xsl:param name="columns-count"/>
		<xsl:param name="content-class-name" select="''" required="no" />

		<xsl:if test="$columns-count = 1">
			<td><xsl:value-of select="$last-content" /></td>
		</xsl:if>
		<xsl:if test="$columns-count &gt; 1">		
			<xsl:choose>
				<xsl:when test="string-length($content) &gt; 0">
					<td><span><xsl:attribute name="class" select="$content-class-name" /><xsl:value-of select="$content" /></span></td>
				</xsl:when>
				<xsl:otherwise><td></td></xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		<xsl:if test="$columns-count &gt; 0">
			<xsl:call-template name="make-empty-row-col">
				<xsl:with-param name="columns-count" select="$columns-count - 1" />
				<xsl:with-param name="last-content" select="$last-content" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="make-empty-row">
		<xsl:param name="first-column" required="no"></xsl:param>
		<xsl:param name="last-column" required="no"></xsl:param>
		<xsl:param name="first-column-classname" required="no" select="''" />
		<xsl:param name="columns-count" />
		
		<tr>
			<xsl:call-template name="make-empty-row-col">
				<xsl:with-param name="content" select="$first-column" />
				<xsl:with-param name="last-content" select="$last-column" />
				<xsl:with-param name="columns-count" select="$columns-count" />
				<xsl:with-param name="content-class-name" select="$first-column-classname" />
			</xsl:call-template>
		</tr>
	</xsl:template>
</xsl:stylesheet>