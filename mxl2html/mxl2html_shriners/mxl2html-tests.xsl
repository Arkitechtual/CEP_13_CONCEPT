<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:hl7="urn:hl7-org:v3">
	
	<xsl:import href="mxl2html-formatting.xsl" />

	<xsl:template name="test-age-difference">
		<xsl:param name="date0" />
		<xsl:param name="date1" />
		<xsl:param name="expected" />
			
		<xsl:variable name="res0">
			<xsl:call-template name="print-age">
				<xsl:with-param name="first-date" select="$date0" />
				<xsl:with-param name="second-date" select="$date1" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$res0 != $expected">
			<xsl:message>Dates ('<xsl:value-of select="$date0" />', '<xsl:value-of select="$date1"
				/>') don't match: The difference should be '<xsl:value-of select="$expected"/>', was '<xsl:value-of
				select="$res0" />'.</xsl:message>
		</xsl:if>
	</xsl:template>

	<xsl:template name="test-age-year-only">
		<xsl:variable name="now">2000</xsl:variable>
		<xsl:variable name="date0">2000</xsl:variable>
		<xsl:variable name="date1">2001</xsl:variable>
		<xsl:variable name="date2">1998</xsl:variable>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date0" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">0y</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date1" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">Future</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date2" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">2y</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="test-age-year-month">
		<xsl:variable name="now">200106</xsl:variable>
		<xsl:variable name="date0">200105</xsl:variable>
		<xsl:variable name="date1">200201</xsl:variable>
		<xsl:variable name="date2">200007</xsl:variable>
		<xsl:variable name="date3">200005</xsl:variable>
		<xsl:variable name="date4">200006</xsl:variable>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date0" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1m</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date1" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">Future</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date2" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">11m</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date3" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1y,1m</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date4" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1y</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="test-age-year-month-day">
		<xsl:variable   name="now">20010615</xsl:variable>
		<xsl:variable name="date00">20010514</xsl:variable>
		<xsl:variable name="date01">20010515</xsl:variable>
		<xsl:variable name="date02">20010516</xsl:variable>
		
		
		<xsl:variable name="date10">20020110</xsl:variable>
		
		<!-- Difference about 1month  -->
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date00" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1m</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date01" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1m</xsl:with-param>
		</xsl:call-template>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date02" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">30d</xsl:with-param>
		</xsl:call-template>
		
		<!-- Future -->
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date10" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">Future</xsl:with-param>
		</xsl:call-template>
		
		<!-- Difference about 11 months -->
		<xsl:variable name="date20">20000714</xsl:variable>
		<xsl:variable name="date21">20000715</xsl:variable>
		<xsl:variable name="date22">20000716</xsl:variable>
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date20" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">11m</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date21" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">11m</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date22" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">11m</xsl:with-param>
		</xsl:call-template>
		
		<!-- Difference about 1y 1m -->
		<xsl:variable name="date30">20000514</xsl:variable>
		<xsl:variable name="date31">20000515</xsl:variable>
		<xsl:variable name="date32">20000516</xsl:variable>
		
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date30" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1y,1m</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date31" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1y,1m</xsl:with-param>
		</xsl:call-template>
		<xsl:call-template name="test-age-difference">
			<xsl:with-param name="date0" select="$date32" />
			<xsl:with-param name="date1" select="$now" />
			<xsl:with-param name="expected">1y,1m</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="age-test-suite">
		<xsl:call-template name="test-age-year-only" />
		<xsl:call-template name="test-age-year-month" />
		<xsl:call-template name="test-age-year-month-day" />
	</xsl:template>
</xsl:stylesheet>