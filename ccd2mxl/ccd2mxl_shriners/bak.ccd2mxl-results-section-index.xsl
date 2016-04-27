<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rtf="http://www.browsersoft.com/">

    <xsl:import href="ccd2mxl-formatting.xsl"/>
    <xsl:import href="ccd2mxl-lib.xsl"/>
    <xsl:import href="ccd2mxl-sections-labs-results.xsl"/>
    <xsl:import href="ccd2mxl-sections-micro.xsl"/>
    <xsl:import href="ccd2mxl-sections-results.xsl"/>

    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'"/>
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

    <xsl:param name="globalContentMap"/>
    <xsl:param name="resolvedEncounterId"/>
    <xsl:param name="resolvedEncounterOrigin"/>
    <xsl:param name="globalDocumentTs"/>
    <xsl:param name="globalOrganizertype"/>
    <xsl:param name="globalAuthor"/>

    <xsl:param name="globalOrganizerDisplayName"/>

    <xsl:param name="globalOrderingProviderId"/>
    <xsl:param name="globalOrderingProviderOid"/>
    <xsl:param name="globalOrderingProviderFirst"/>
    <xsl:param name="globalOrderingProviderMiddle"/>
    <xsl:param name="globalOrderingProviderLast"/>
    <xsl:param name="globalOrderingProviderSuffix"/>

    <xsl:param name="globalVerifierId"/>
    <xsl:param name="globalVerifierOid"/>
    <xsl:param name="globalVerifierFirst"/>
    <xsl:param name="globalVerifierMiddle"/>
    <xsl:param name="globalVerifierLast"/>
    <xsl:param name="globalVerifierSuffix"/>

    <xsl:template match="/">
        <xsl:call-template name="build-section-labs-results">
            <xsl:with-param name="organizer"
                            select="./entry/organizer[(templateId/@root ='2.16.840.1.113883.10.20.1.32' and code/@code!='46680005' and code/@code!='363680008' and code/@code!='19851009' and code/@code!='53807006' and code/@code!='108257001' and code/@code!='373942005' and code/@code!='371526002') or (code/@codeSystem='2.16.840.1.113883.6.12') or (code/@code='252275004') or (code/@code='275711006') or
                                (code/@code='108257001') or (templateId/@root = '2.16.840.1.113883.10.20.22.4.1') or (code/@code='68793005') or (code/@code='59524001') or (code/originalText='URINALYSIS') or
                                (code/@nullFlavor='OTH') or (code/@nullFlavor='UNK') or (code/@code='OTH') or (code/@codeSystem='2.16.840.1.113883.6.96' and (code/@code!='46680005' and code/@code!='363680008' and code/@code!='19851009' and code/@code!='53807006' and code/@code!='108257001' and code/@code!='373942005' and code/@code!='371526002'))]" />
        </xsl:call-template>

        <!-- Call this again to get procedure tags from Results section.  These are orders -->
        <xsl:call-template name="build-section-labs-results">
            <xsl:with-param name="organizer"
                            select="./entry/procedure[(templateId/@root = '2.16.840.1.113883.10.20.1.32') or (templateId/@root = '2.16.840.1.113883.10.20.1.29')  or (code/@codeSystem='2.16.840.1.113883.6.12') or (code/@code='252275004') or (code/@code='275711006') or
                                (code/@code='108257001') or (templateId/@root = '2.16.840.1.113883.10.20.22.4.1') or (code/@code='68793005') or (code/@code='59524001') or (code/originalText='URINALYSIS') or
                                (code/@nullFlavor='OTH') or (code/@nullFlavor='UNK') or (code/@code='OTH') or (code/@codeSystem='2.16.840.1.113883.6.96' and (code/@code!='46680005' and code/@code!='363680008' and code/@code!='19851009' and code/@code!='53807006' and code/@code!='108257001' and code/@code!='373942005' and code/@code!='371526002'))]" />
        </xsl:call-template>

        <xsl:call-template name="build-section-micro">
            <xsl:with-param name="organizer"
                            select="./entry/organizer[(code/@code='19851009') or (code/@code='630-4')]"/>
        </xsl:call-template>

        <xsl:call-template name="build-section-results">
            <xsl:with-param name="organizer"
                            select="./entry/organizer[(code/@code='anatomic-pathology') or (code/@code='11529-5') or (code/@code='108257001')]" />
            <xsl:with-param name="organizer-type">anatomic-pathology</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="build-section-results">
            <xsl:with-param name="organizer"
                            select="./entry/organizer[(code/@code='363679005') or (code/@code='363680008')
                                or (code/@code='16310003') or (code/@code='77477000') or (code/@code='113091000')
                                or (code/@code='77343006') or (code/@code='40701008') or (code/@code='radiology') or (code/@code='24727-0') or (code/@code='74022')or (code/@code='74220')]"/>
            <xsl:with-param name="organizer-type">radiology</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="build-section-results">
            <xsl:with-param name="organizer"
                            select="./entry/organizer[(code/@code='history-physical') or (code/@code='34117-2') or (code/@code='53807006')]"/>
            <xsl:with-param name="organizer-type">history-physical</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="build-section-results">
            <xsl:with-param name="organizer"
                            select="./entry/organizer[(code/@code='discharge-summary') or (code/@code='373942005') or (code/@code='18842-5')]"/>
            <xsl:with-param name="organizer-type">discharge-summary</xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="build-section-results">
            <xsl:with-param name="organizer"
                            select="./entry/organizer[(code/@code='other-reports') or (code/@code='371526002') or (code/@code='371530004') or (code/@code='99241')]"/>
            <xsl:with-param name="organizer-type">other-reports</xsl:with-param>
        </xsl:call-template>

    </xsl:template>
</xsl:stylesheet>