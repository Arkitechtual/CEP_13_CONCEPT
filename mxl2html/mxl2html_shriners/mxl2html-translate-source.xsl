<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hl7="urn:hl7-org:v3">

	<!-- Table of translations??? -->
	<xsl:template name="translate-source">
		<xsl:param name="id-tag" />

		<xsl:choose>
                    <xsl:when test='contains($id-tag,",")'>
                        <xsl:call-template name="translate-source-with-comma">
                            <xsl:with-param name="id-tag" select="$id-tag"/>
                        </xsl:call-template>
                    </xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.428.1.1'">
			    <xsl:text>HRMC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.429.1.1'">
				<xsl:text>NWHS</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = 'http://www.stfrancismaryville.com/Pages/default.aspx'">
			    <xsl:text>SFHHS</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.0.100'">
				<xsl:text>MHHS</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.1'">
				<xsl:text>MH Texas Medical Center</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.3'">
				<xsl:text>MH Southeast</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.4'">
				<xsl:text>MH Northwest</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.5'">
				<xsl:text>MH Southwest</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.6'">
				<xsl:text>MH The Woodlands</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.7'">
				<xsl:text>MH Memorial City</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.8'">
				<xsl:text>MH Sugarland</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.9'">
				<xsl:text>MH Katy</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.615.10'">
				<xsl:text>MH Northeast</xsl:text>
			</xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.1'">
				<xsl:text>Integris</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.2'">
				<xsl:text>IBMC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.3'">
				<xsl:text>IBRH</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.4'">
				<xsl:text>IBRHC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.5'">
				<xsl:text>ICVRH</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.6'">
				<xsl:text>ISMC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.7'">
				<xsl:text>ICIO</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.8'">
				<xsl:text>ICRH</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.9'">
				<xsl:text>IGGH</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.10'">
				<xsl:text>IMCMC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.11'">
				<xsl:text>IMDL</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.12'">
				<xsl:text>IMHC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.594.1.13'">
				<xsl:text>IBBHC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.582.1.2'">
				<xsl:text>MMC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.582.1.3'">
				<xsl:text>HPX</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.582.1.4'">
				<xsl:text>NRH</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.627.1.1'">
				<xsl:text>TCH</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.637.1.1'">
				<xsl:text>OUMC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.637.2.1'">
				<xsl:text>MERCY_HC</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.4.391.8'">
				<xsl:text>EHX</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.619.1.1'">
				<xsl:text>Oklahoma Heart</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.2'">
				<xsl:text>Claremore Hospital</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.3'">
				<xsl:text>AMO Salina Health Center</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.4'">
				<xsl:text>Bartlesville Health Clinic</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.5'">
				<xsl:text>Nowata Primary Care Center</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.6'">
				<xsl:text>Sam Hider Community Clinic</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.7'">
				<xsl:text>Vinita Health Clinic</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.8'">
				<xsl:text>Cherokee Nation Eye Clinic</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.9'">
				<xsl:text>Cherokee Nation Ga-Du-Gi Clin</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.10'">
				<xsl:text>Cherokee Nation Tahlequah Clin</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.11'">
				<xsl:text>Muskogee Health Center</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.12'">
				<xsl:text>Redbird Smith Health Center</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.13'">
				<xsl:text>Wilma P. Mankiller Hlth Ctr</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.14'">
				<xsl:text>WW Hastings Indian Hospital</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.15'">
				<xsl:text>ENT Childers</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.16'">
				<xsl:text>Jack Brown Youth TX Cntr</xsl:text>
			</xsl:when>
			<xsl:when test="$id-tag = '2.16.840.1.113883.3.599.1.17'">
			    <xsl:text>Tahlequah City Operating Room</xsl:text>
			</xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.593.1.1'">
                <xsl:text>Unity</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.566.1.1'">
                <xsl:text>UMHC</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.547.1.1'">
                <xsl:text>CRMC</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.588.1.1'">
                <xsl:text>NEO</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.581.1.1'">
                <xsl:text>St. Anthony</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.582.1.1'">
                <xsl:text>NRHS</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.637.3.1'">
                <xsl:text>OU Medical Center Edmond</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.637.5.1'">
                <xsl:text>HCA URN</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.0.0'">
                <xsl:text>BWMC</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.4.317'">
                <xsl:text>HWSHC</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.1.1'">
                <xsl:text>Mission Hospitals</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.1'">
                <xsl:text>Mission Hospitals</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.2'">
                <xsl:text>Mission Outpatient Neuro</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.3'">
                <xsl:text>Mission Staff Health</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.4'">
                <xsl:text>Mission OccuMed (Separate LD)</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.5'">
                <xsl:text>McDowell Health Plus</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.6'">
                <xsl:text>McDowell OB/GYN</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.7'">
                <xsl:text>McDowell Family Care Associates</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.8'">
                <xsl:text>McDowell Surgical Services</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.9'">
                <xsl:text>McDowell Orthopedics</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.10'">
                <xsl:text>Sugar Hill Family Care</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.11'">
                <xsl:text>West Buncombe Family Medicine</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.12'">
                <xsl:text>McDowell Family Physicians</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.13'">
                <xsl:text>Mission Fullerton Genetics Center</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.14'">
                <xsl:text>MCS Child Medical Exam</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.15'">
                <xsl:text>McDowell Pediatrics</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.16'">
                <xsl:text>Mission Children&apos;s Specialists Olson Huff</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.17'">
                <xsl:text>Mission Children&apos;s Specialists Peds GI</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.18'">
                <xsl:text>Mission Children&apos;s Specialists Peds Endo</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.19'">
                <xsl:text>Mission Children&apos;s Specialists Peds Neuro</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.20'">
                <xsl:text>Mission Children&apos;s Specialists Peds Pulm</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.21'">
                <xsl:text>Mission Children&apos;s Specialists Peds Surgery</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.22'">
                <xsl:text>Mission Children&apos;s Specialists Peds Weight Mgmt</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.789.23'">
                <xsl:text>Mission Children&apos;s Specialists Peds Comm Trans</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.781'">
                <xsl:text>MCG</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.779'">
                <xsl:text>MCCG</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.701.001'">
                <xsl:text>Emory University Hospital</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.701.0.10'">
                <xsl:text>Emory University Hospital EMPI</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.701.002'">
                <xsl:text>Crawford Long Hospital</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.701.003'">
                <xsl:text>The Emory Clinic</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '2.16.840.1.113883.3.701.004'">
                <xsl:text>Wesley Woods Hospital</xsl:text>
            </xsl:when>
            <xsl:when test="$id-tag = '5.55.555.5.123456.5.555.1.1'">
                <xsl:text>Stanislaus</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                    <xsl:value-of select="$id-tag" />
            </xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="translate-source-with-comma">
            <xsl:param name="id-tag" />

            <xsl:for-each select="tokenize($id-tag,',')">
                <xsl:call-template name="translate-source">
                    <xsl:with-param name="id-tag" select="."/>
                </xsl:call-template>
                <xsl:if test="position()!=last()"><xsl:text>, </xsl:text></xsl:if>
            </xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
